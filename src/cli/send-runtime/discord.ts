import { sendMessageDiscord as sendMessageDiscordImpl } from "synthios/plugin-sdk/discord";

type RuntimeSend = {
  sendMessage: typeof import("synthios/plugin-sdk/discord").sendMessageDiscord;
};

export const runtimeSend = {
  sendMessage: sendMessageDiscordImpl,
} satisfies RuntimeSend;
