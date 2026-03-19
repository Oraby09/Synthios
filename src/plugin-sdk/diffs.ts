// Narrow plugin-sdk surface for the bundled diffs plugin.
// Keep this list additive and scoped to symbols used under extensions/diffs.

export { definePluginEntry } from "./core.js";
export type { SynthiosConfig } from "../config/config.js";
export { resolvePreferredSynthiosTmpDir } from "../infra/tmp-synthios-dir.js";
export type {
  AnyAgentTool,
  SynthiosPluginApi,
  SynthiosPluginConfigSchema,
  SynthiosPluginToolContext,
  PluginLogger,
} from "../plugins/types.js";
