import {
  buildHuggingfaceModelDefinition,
  HUGGINGFACE_BASE_URL,
  HUGGINGFACE_MODEL_CATALOG,
} from "synthios/plugin-sdk/provider-models";
import {
  applyProviderConfigWithModelCatalogPreset,
  type SynthiosConfig,
} from "synthios/plugin-sdk/provider-onboard";

export const HUGGINGFACE_DEFAULT_MODEL_REF = "huggingface/deepseek-ai/DeepSeek-R1";

function applyHuggingfacePreset(cfg: SynthiosConfig, primaryModelRef?: string): SynthiosConfig {
  return applyProviderConfigWithModelCatalogPreset(cfg, {
    providerId: "huggingface",
    api: "openai-completions",
    baseUrl: HUGGINGFACE_BASE_URL,
    catalogModels: HUGGINGFACE_MODEL_CATALOG.map(buildHuggingfaceModelDefinition),
    aliases: [{ modelRef: HUGGINGFACE_DEFAULT_MODEL_REF, alias: "Hugging Face" }],
    primaryModelRef,
  });
}

export function applyHuggingfaceProviderConfig(cfg: SynthiosConfig): SynthiosConfig {
  return applyHuggingfacePreset(cfg);
}

export function applyHuggingfaceConfig(cfg: SynthiosConfig): SynthiosConfig {
  return applyHuggingfacePreset(cfg, HUGGINGFACE_DEFAULT_MODEL_REF);
}
