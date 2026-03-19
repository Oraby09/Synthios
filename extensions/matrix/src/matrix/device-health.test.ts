import { describe, expect, it } from "vitest";
import { isSynthiosManagedMatrixDevice, summarizeMatrixDeviceHealth } from "./device-health.js";

describe("matrix device health", () => {
  it("detects Synthios-managed device names", () => {
    expect(isSynthiosManagedMatrixDevice("Synthios Gateway")).toBe(true);
    expect(isSynthiosManagedMatrixDevice("Synthios Debug")).toBe(true);
    expect(isSynthiosManagedMatrixDevice("Element iPhone")).toBe(false);
    expect(isSynthiosManagedMatrixDevice(null)).toBe(false);
  });

  it("summarizes stale Synthios-managed devices separately from the current device", () => {
    const summary = summarizeMatrixDeviceHealth([
      {
        deviceId: "du314Zpw3A",
        displayName: "Synthios Gateway",
        current: true,
      },
      {
        deviceId: "BritdXC6iL",
        displayName: "Synthios Gateway",
        current: false,
      },
      {
        deviceId: "G6NJU9cTgs",
        displayName: "Synthios Debug",
        current: false,
      },
      {
        deviceId: "phone123",
        displayName: "Element iPhone",
        current: false,
      },
    ]);

    expect(summary.currentDeviceId).toBe("du314Zpw3A");
    expect(summary.currentSynthiosDevices).toEqual([
      expect.objectContaining({ deviceId: "du314Zpw3A" }),
    ]);
    expect(summary.staleSynthiosDevices).toEqual([
      expect.objectContaining({ deviceId: "BritdXC6iL" }),
      expect.objectContaining({ deviceId: "G6NJU9cTgs" }),
    ]);
  });
});
