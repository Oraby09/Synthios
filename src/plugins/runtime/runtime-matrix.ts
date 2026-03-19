import {
  setMatrixThreadBindingIdleTimeoutBySessionKey,
  setMatrixThreadBindingMaxAgeBySessionKey,
} from "synthios/plugin-sdk/matrix";
import type { PluginRuntimeChannel } from "./types-channel.js";

export function createRuntimeMatrix(): PluginRuntimeChannel["matrix"] {
  return {
    threadBindings: {
      setIdleTimeoutBySessionKey: setMatrixThreadBindingIdleTimeoutBySessionKey,
      setMaxAgeBySessionKey: setMatrixThreadBindingMaxAgeBySessionKey,
    },
  };
}
