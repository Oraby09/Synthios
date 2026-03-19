import type { PluginRuntime } from "synthios/plugin-sdk/plugin-runtime";
import { createPluginRuntimeStore } from "synthios/plugin-sdk/runtime-store";

const { setRuntime: setTlonRuntime, getRuntime: getTlonRuntime } =
  createPluginRuntimeStore<PluginRuntime>("Tlon runtime not initialized");
export { getTlonRuntime, setTlonRuntime };
