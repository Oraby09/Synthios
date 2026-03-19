import { definePluginEntry } from "synthios/plugin-sdk/core";
import { buildElevenLabsSpeechProvider } from "synthios/plugin-sdk/speech";

export default definePluginEntry({
  id: "elevenlabs",
  name: "ElevenLabs Speech",
  description: "Bundled ElevenLabs speech provider",
  register(api) {
    api.registerSpeechProvider(buildElevenLabsSpeechProvider());
  },
});
