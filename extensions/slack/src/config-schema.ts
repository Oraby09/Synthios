import { buildChannelConfigSchema, SlackConfigSchema } from "synthios/plugin-sdk/slack-core";

export const SlackChannelConfigSchema = buildChannelConfigSchema(SlackConfigSchema);
