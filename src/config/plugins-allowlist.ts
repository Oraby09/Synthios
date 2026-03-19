import type { SynthiosConfig } from "./config.js";

export function ensurePluginAllowlisted(cfg: SynthiosConfig, pluginId: string): SynthiosConfig {
  const allow = cfg.plugins?.allow;
  if (!Array.isArray(allow) || allow.includes(pluginId)) {
    return cfg;
  }
  return {
    ...cfg,
    plugins: {
      ...cfg.plugins,
      allow: [...allow, pluginId],
    },
  };
}
