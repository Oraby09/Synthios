import { buildChannelConfigSchema, SignalConfigSchema } from "synthios/plugin-sdk/signal-core";

export const SignalChannelConfigSchema = buildChannelConfigSchema(SignalConfigSchema);
