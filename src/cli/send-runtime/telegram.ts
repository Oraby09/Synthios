import { sendMessageTelegram as sendMessageTelegramImpl } from "synthios/plugin-sdk/telegram";

type RuntimeSend = {
  sendMessage: typeof import("synthios/plugin-sdk/telegram").sendMessageTelegram;
};

export const runtimeSend = {
  sendMessage: sendMessageTelegramImpl,
} satisfies RuntimeSend;
