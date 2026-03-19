import { buildChannelConfigSchema, DiscordConfigSchema } from "synthios/plugin-sdk/discord-core";

export const DiscordChannelConfigSchema = buildChannelConfigSchema(DiscordConfigSchema);
