import { definePluginEntry } from "synthios/plugin-sdk/core";
import type { AnyAgentTool, SynthiosPluginApi, SynthiosPluginToolFactory } from "./runtime-api.js";
import { createLobsterTool } from "./src/lobster-tool.js";

export default definePluginEntry({
  id: "lobster",
  name: "Lobster",
  description: "Optional local shell helper tools",
  register(api: SynthiosPluginApi) {
    api.registerTool(
      ((ctx) => {
        if (ctx.sandboxed) {
          return null;
        }
        return createLobsterTool(api) as AnyAgentTool;
      }) as SynthiosPluginToolFactory,
      { optional: true },
    );
  },
});
