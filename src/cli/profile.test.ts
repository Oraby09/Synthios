import path from "node:path";
import { describe, expect, it } from "vitest";
import { formatCliCommand } from "./command-format.js";
import { applyCliProfileEnv, parseCliProfileArgs } from "./profile.js";

describe("parseCliProfileArgs", () => {
  it("leaves gateway --dev for subcommands", () => {
    const res = parseCliProfileArgs([
      "node",
      "synthios",
      "gateway",
      "--dev",
      "--allow-unconfigured",
    ]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBeNull();
    expect(res.argv).toEqual(["node", "synthios", "gateway", "--dev", "--allow-unconfigured"]);
  });

  it("still accepts global --dev before subcommand", () => {
    const res = parseCliProfileArgs(["node", "synthios", "--dev", "gateway"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBe("dev");
    expect(res.argv).toEqual(["node", "synthios", "gateway"]);
  });

  it("parses --profile value and strips it", () => {
    const res = parseCliProfileArgs(["node", "synthios", "--profile", "work", "status"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBe("work");
    expect(res.argv).toEqual(["node", "synthios", "status"]);
  });

  it("rejects missing profile value", () => {
    const res = parseCliProfileArgs(["node", "synthios", "--profile"]);
    expect(res.ok).toBe(false);
  });

  it.each([
    ["--dev first", ["node", "synthios", "--dev", "--profile", "work", "status"]],
    ["--profile first", ["node", "synthios", "--profile", "work", "--dev", "status"]],
  ])("rejects combining --dev with --profile (%s)", (_name, argv) => {
    const res = parseCliProfileArgs(argv);
    expect(res.ok).toBe(false);
  });
});

describe("applyCliProfileEnv", () => {
  it("fills env defaults for dev profile", () => {
    const env: Record<string, string | undefined> = {};
    applyCliProfileEnv({
      profile: "dev",
      env,
      homedir: () => "/home/peter",
    });
    const expectedStateDir = path.join(path.resolve("/home/peter"), ".synthios-dev");
    expect(env.SYNTHIOS_PROFILE).toBe("dev");
    expect(env.SYNTHIOS_STATE_DIR).toBe(expectedStateDir);
    expect(env.SYNTHIOS_CONFIG_PATH).toBe(path.join(expectedStateDir, "synthios.json"));
    expect(env.SYNTHIOS_GATEWAY_PORT).toBe("19001");
  });

  it("does not override explicit env values", () => {
    const env: Record<string, string | undefined> = {
      SYNTHIOS_STATE_DIR: "/custom",
      SYNTHIOS_GATEWAY_PORT: "19099",
    };
    applyCliProfileEnv({
      profile: "dev",
      env,
      homedir: () => "/home/peter",
    });
    expect(env.SYNTHIOS_STATE_DIR).toBe("/custom");
    expect(env.SYNTHIOS_GATEWAY_PORT).toBe("19099");
    expect(env.SYNTHIOS_CONFIG_PATH).toBe(path.join("/custom", "synthios.json"));
  });

  it("uses SYNTHIOS_HOME when deriving profile state dir", () => {
    const env: Record<string, string | undefined> = {
      SYNTHIOS_HOME: "/srv/synthios-home",
      HOME: "/home/other",
    };
    applyCliProfileEnv({
      profile: "work",
      env,
      homedir: () => "/home/fallback",
    });

    const resolvedHome = path.resolve("/srv/synthios-home");
    expect(env.SYNTHIOS_STATE_DIR).toBe(path.join(resolvedHome, ".synthios-work"));
    expect(env.SYNTHIOS_CONFIG_PATH).toBe(
      path.join(resolvedHome, ".synthios-work", "synthios.json"),
    );
  });
});

describe("formatCliCommand", () => {
  it.each([
    {
      name: "no profile is set",
      cmd: "synthios doctor --fix",
      env: {},
      expected: "synthios doctor --fix",
    },
    {
      name: "profile is default",
      cmd: "synthios doctor --fix",
      env: { SYNTHIOS_PROFILE: "default" },
      expected: "synthios doctor --fix",
    },
    {
      name: "profile is Default (case-insensitive)",
      cmd: "synthios doctor --fix",
      env: { SYNTHIOS_PROFILE: "Default" },
      expected: "synthios doctor --fix",
    },
    {
      name: "profile is invalid",
      cmd: "synthios doctor --fix",
      env: { SYNTHIOS_PROFILE: "bad profile" },
      expected: "synthios doctor --fix",
    },
    {
      name: "--profile is already present",
      cmd: "synthios --profile work doctor --fix",
      env: { SYNTHIOS_PROFILE: "work" },
      expected: "synthios --profile work doctor --fix",
    },
    {
      name: "--dev is already present",
      cmd: "synthios --dev doctor",
      env: { SYNTHIOS_PROFILE: "dev" },
      expected: "synthios --dev doctor",
    },
  ])("returns command unchanged when $name", ({ cmd, env, expected }) => {
    expect(formatCliCommand(cmd, env)).toBe(expected);
  });

  it("inserts --profile flag when profile is set", () => {
    expect(formatCliCommand("synthios doctor --fix", { SYNTHIOS_PROFILE: "work" })).toBe(
      "synthios --profile work doctor --fix",
    );
  });

  it("trims whitespace from profile", () => {
    expect(formatCliCommand("synthios doctor --fix", { SYNTHIOS_PROFILE: "  jbsynthios  " })).toBe(
      "synthios --profile jbsynthios doctor --fix",
    );
  });

  it("handles command with no args after synthios", () => {
    expect(formatCliCommand("synthios", { SYNTHIOS_PROFILE: "test" })).toBe(
      "synthios --profile test",
    );
  });

  it("handles pnpm wrapper", () => {
    expect(formatCliCommand("pnpm synthios doctor", { SYNTHIOS_PROFILE: "work" })).toBe(
      "pnpm synthios --profile work doctor",
    );
  });
});
