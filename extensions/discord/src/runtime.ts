import type { PluginRuntime } from "synthios/plugin-sdk/core";
import { createPluginRuntimeStore } from "synthios/plugin-sdk/runtime-store";

const { setRuntime: setDiscordRuntime, getRuntime: getDiscordRuntime } =
  createPluginRuntimeStore<PluginRuntime>("Discord runtime not initialized");
export { getDiscordRuntime, setDiscordRuntime };
