import { buildChannelConfigSchema, IMessageConfigSchema } from "synthios/plugin-sdk/imessage-core";

export const IMessageChannelConfigSchema = buildChannelConfigSchema(IMessageConfigSchema);
