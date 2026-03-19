export const SYNTHIOS_CLI_ENV_VAR = "SYNTHIOS_CLI";
export const SYNTHIOS_CLI_ENV_VALUE = "1";

export function markSynthiosExecEnv<T extends Record<string, string | undefined>>(env: T): T {
  return {
    ...env,
    [SYNTHIOS_CLI_ENV_VAR]: SYNTHIOS_CLI_ENV_VALUE,
  };
}

export function ensureSynthiosExecMarkerOnProcess(
  env: NodeJS.ProcessEnv = process.env,
): NodeJS.ProcessEnv {
  env[SYNTHIOS_CLI_ENV_VAR] = SYNTHIOS_CLI_ENV_VALUE;
  return env;
}
