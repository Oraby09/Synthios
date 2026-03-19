import { vi } from "vitest";
import { installChromeUserDataDirHooks } from "./chrome-user-data-dir.test-harness.js";

const chromeUserDataDir = { dir: "/tmp/synthios" };
installChromeUserDataDirHooks(chromeUserDataDir);

vi.mock("./chrome.js", () => ({
  isChromeCdpReady: vi.fn(async () => true),
  isChromeReachable: vi.fn(async () => true),
  launchSynthiosChrome: vi.fn(async () => {
    throw new Error("unexpected launch");
  }),
  resolveSynthiosUserDataDir: vi.fn(() => chromeUserDataDir.dir),
  stopSynthiosChrome: vi.fn(async () => {}),
}));
