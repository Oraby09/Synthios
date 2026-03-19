import { buildChannelConfigSchema, WhatsAppConfigSchema } from "synthios/plugin-sdk/whatsapp-core";

export const WhatsAppChannelConfigSchema = buildChannelConfigSchema(WhatsAppConfigSchema);
