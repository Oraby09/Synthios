import { afterEach, describe, expect, it, vi } from "vitest";

type LoggerModule = typeof import("./logger.js");

const originalGetBuiltinModule = (
  process as NodeJS.Process & { getBuiltinModule?: (id: string) => unknown }
).getBuiltinModule;

async function importBrowserSafeLogger(params?: {
  resolvePreferredSynthiosTmpDir?: ReturnType<typeof vi.fn>;
}): Promise<{
  module: LoggerModule;
  resolvePreferredSynthiosTmpDir: ReturnType<typeof vi.fn>;
}> {
  vi.resetModules();
  const resolvePreferredSynthiosTmpDir =
    params?.resolvePreferredSynthiosTmpDir ??
    vi.fn(() => {
      throw new Error("resolvePreferredSynthiosTmpDir should not run during browser-safe import");
    });

  vi.doMock("../infra/tmp-synthios-dir.js", async () => {
    const actual = await vi.importActual<typeof import("../infra/tmp-synthios-dir.js")>(
      "../infra/tmp-synthios-dir.js",
    );
    return {
      ...actual,
      resolvePreferredSynthiosTmpDir,
    };
  });

  Object.defineProperty(process, "getBuiltinModule", {
    configurable: true,
    value: undefined,
  });

  const module = await import("./logger.js");
  return { module, resolvePreferredSynthiosTmpDir };
}

describe("logging/logger browser-safe import", () => {
  afterEach(() => {
    vi.resetModules();
    vi.doUnmock("../infra/tmp-synthios-dir.js");
    Object.defineProperty(process, "getBuiltinModule", {
      configurable: true,
      value: originalGetBuiltinModule,
    });
  });

  it("does not resolve the preferred temp dir at import time when node fs is unavailable", async () => {
    const { module, resolvePreferredSynthiosTmpDir } = await importBrowserSafeLogger();

    expect(resolvePreferredSynthiosTmpDir).not.toHaveBeenCalled();
    expect(module.DEFAULT_LOG_DIR).toBe("/tmp/synthios");
    expect(module.DEFAULT_LOG_FILE).toBe("/tmp/synthios/synthios.log");
  });

  it("disables file logging when imported in a browser-like environment", async () => {
    const { module, resolvePreferredSynthiosTmpDir } = await importBrowserSafeLogger();

    expect(module.getResolvedLoggerSettings()).toMatchObject({
      level: "silent",
      file: "/tmp/synthios/synthios.log",
    });
    expect(module.isFileLogLevelEnabled("info")).toBe(false);
    expect(() => module.getLogger().info("browser-safe")).not.toThrow();
    expect(resolvePreferredSynthiosTmpDir).not.toHaveBeenCalled();
  });
});
