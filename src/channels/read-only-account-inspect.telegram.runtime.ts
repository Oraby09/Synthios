import { inspectTelegramAccount as inspectTelegramAccountImpl } from "synthios/plugin-sdk/telegram";

export type { InspectedTelegramAccount } from "synthios/plugin-sdk/telegram";

type InspectTelegramAccount = typeof import("synthios/plugin-sdk/telegram").inspectTelegramAccount;

export function inspectTelegramAccount(
  ...args: Parameters<InspectTelegramAccount>
): ReturnType<InspectTelegramAccount> {
  return inspectTelegramAccountImpl(...args);
}
