import type { PluginRuntime } from "synthios/plugin-sdk/core";
import { createPluginRuntimeStore } from "synthios/plugin-sdk/runtime-store";

const { setRuntime: setSignalRuntime, getRuntime: getSignalRuntime } =
  createPluginRuntimeStore<PluginRuntime>("Signal runtime not initialized");
export { getSignalRuntime, setSignalRuntime };
