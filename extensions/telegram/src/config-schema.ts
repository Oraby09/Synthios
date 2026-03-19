import { buildChannelConfigSchema, TelegramConfigSchema } from "synthios/plugin-sdk/telegram-core";

export const TelegramChannelConfigSchema = buildChannelConfigSchema(TelegramConfigSchema);
