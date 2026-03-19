import type { PluginRuntime } from "synthios/plugin-sdk/core";
import { createPluginRuntimeStore } from "synthios/plugin-sdk/runtime-store";

const { setRuntime: setTelegramRuntime, getRuntime: getTelegramRuntime } =
  createPluginRuntimeStore<PluginRuntime>("Telegram runtime not initialized");
export { getTelegramRuntime, setTelegramRuntime };
