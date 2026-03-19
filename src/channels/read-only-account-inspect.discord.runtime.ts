import { inspectDiscordAccount as inspectDiscordAccountImpl } from "synthios/plugin-sdk/discord";

export type { InspectedDiscordAccount } from "synthios/plugin-sdk/discord";

type InspectDiscordAccount = typeof import("synthios/plugin-sdk/discord").inspectDiscordAccount;

export function inspectDiscordAccount(
  ...args: Parameters<InspectDiscordAccount>
): ReturnType<InspectDiscordAccount> {
  return inspectDiscordAccountImpl(...args);
}
