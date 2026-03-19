import { describe, expect, it } from "vitest";
import {
  ensureSynthiosExecMarkerOnProcess,
  markSynthiosExecEnv,
  SYNTHIOS_CLI_ENV_VALUE,
  SYNTHIOS_CLI_ENV_VAR,
} from "./synthios-exec-env.js";

describe("markSynthiosExecEnv", () => {
  it("returns a cloned env object with the exec marker set", () => {
    const env = { PATH: "/usr/bin", SYNTHIOS_CLI: "0" };
    const marked = markSynthiosExecEnv(env);

    expect(marked).toEqual({
      PATH: "/usr/bin",
      SYNTHIOS_CLI: SYNTHIOS_CLI_ENV_VALUE,
    });
    expect(marked).not.toBe(env);
    expect(env.SYNTHIOS_CLI).toBe("0");
  });
});

describe("ensureSynthiosExecMarkerOnProcess", () => {
  it("mutates and returns the provided process env", () => {
    const env: NodeJS.ProcessEnv = { PATH: "/usr/bin" };

    expect(ensureSynthiosExecMarkerOnProcess(env)).toBe(env);
    expect(env[SYNTHIOS_CLI_ENV_VAR]).toBe(SYNTHIOS_CLI_ENV_VALUE);
  });

  it("defaults to mutating process.env when no env object is provided", () => {
    const previous = process.env[SYNTHIOS_CLI_ENV_VAR];
    delete process.env[SYNTHIOS_CLI_ENV_VAR];

    try {
      expect(ensureSynthiosExecMarkerOnProcess()).toBe(process.env);
      expect(process.env[SYNTHIOS_CLI_ENV_VAR]).toBe(SYNTHIOS_CLI_ENV_VALUE);
    } finally {
      if (previous === undefined) {
        delete process.env[SYNTHIOS_CLI_ENV_VAR];
      } else {
        process.env[SYNTHIOS_CLI_ENV_VAR] = previous;
      }
    }
  });
});
