import { describe, expect, it } from "vitest";
import { buildPlatformRuntimeLogHints, buildPlatformServiceStartHints } from "./runtime-hints.js";

describe("buildPlatformRuntimeLogHints", () => {
  it("renders launchd log hints on darwin", () => {
    expect(
      buildPlatformRuntimeLogHints({
        platform: "darwin",
        env: {
          SYNTHIOS_STATE_DIR: "/tmp/synthios-state",
          SYNTHIOS_LOG_PREFIX: "gateway",
        },
        systemdServiceName: "synthios-gateway",
        windowsTaskName: "Synthios Gateway",
      }),
    ).toEqual([
      "Launchd stdout (if installed): /tmp/synthios-state/logs/gateway.log",
      "Launchd stderr (if installed): /tmp/synthios-state/logs/gateway.err.log",
    ]);
  });

  it("renders systemd and windows hints by platform", () => {
    expect(
      buildPlatformRuntimeLogHints({
        platform: "linux",
        systemdServiceName: "synthios-gateway",
        windowsTaskName: "Synthios Gateway",
      }),
    ).toEqual(["Logs: journalctl --user -u synthios-gateway.service -n 200 --no-pager"]);
    expect(
      buildPlatformRuntimeLogHints({
        platform: "win32",
        systemdServiceName: "synthios-gateway",
        windowsTaskName: "Synthios Gateway",
      }),
    ).toEqual(['Logs: schtasks /Query /TN "Synthios Gateway" /V /FO LIST']);
  });
});

describe("buildPlatformServiceStartHints", () => {
  it("builds platform-specific service start hints", () => {
    expect(
      buildPlatformServiceStartHints({
        platform: "darwin",
        installCommand: "synthios gateway install",
        startCommand: "synthios gateway",
        launchAgentPlistPath: "~/Library/LaunchAgents/com.synthios.gateway.plist",
        systemdServiceName: "synthios-gateway",
        windowsTaskName: "Synthios Gateway",
      }),
    ).toEqual([
      "synthios gateway install",
      "synthios gateway",
      "launchctl bootstrap gui/$UID ~/Library/LaunchAgents/com.synthios.gateway.plist",
    ]);
    expect(
      buildPlatformServiceStartHints({
        platform: "linux",
        installCommand: "synthios gateway install",
        startCommand: "synthios gateway",
        launchAgentPlistPath: "~/Library/LaunchAgents/com.synthios.gateway.plist",
        systemdServiceName: "synthios-gateway",
        windowsTaskName: "Synthios Gateway",
      }),
    ).toEqual([
      "synthios gateway install",
      "synthios gateway",
      "systemctl --user start synthios-gateway.service",
    ]);
  });
});
