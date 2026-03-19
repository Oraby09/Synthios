import { resolveChannelGroupRequireMention } from "synthios/plugin-sdk/channel-policy";
import type { SynthiosConfig } from "synthios/plugin-sdk/core";

type GoogleChatGroupContext = {
  cfg: SynthiosConfig;
  accountId?: string | null;
  groupId?: string | null;
};

export function resolveGoogleChatGroupRequireMention(params: GoogleChatGroupContext): boolean {
  return resolveChannelGroupRequireMention({
    cfg: params.cfg,
    channel: "googlechat",
    groupId: params.groupId,
    accountId: params.accountId,
  });
}
