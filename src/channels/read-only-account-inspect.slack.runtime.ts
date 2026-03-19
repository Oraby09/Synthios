import { inspectSlackAccount as inspectSlackAccountImpl } from "synthios/plugin-sdk/slack";

export type { InspectedSlackAccount } from "synthios/plugin-sdk/slack";

type InspectSlackAccount = typeof import("synthios/plugin-sdk/slack").inspectSlackAccount;

export function inspectSlackAccount(
  ...args: Parameters<InspectSlackAccount>
): ReturnType<InspectSlackAccount> {
  return inspectSlackAccountImpl(...args);
}
