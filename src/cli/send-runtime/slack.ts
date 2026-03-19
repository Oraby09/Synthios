import { sendMessageSlack as sendMessageSlackImpl } from "synthios/plugin-sdk/slack";

type RuntimeSend = {
  sendMessage: typeof import("synthios/plugin-sdk/slack").sendMessageSlack;
};

export const runtimeSend = {
  sendMessage: sendMessageSlackImpl,
} satisfies RuntimeSend;
