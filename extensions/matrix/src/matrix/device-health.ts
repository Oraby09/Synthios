export type MatrixManagedDeviceInfo = {
  deviceId: string;
  displayName: string | null;
  current: boolean;
};

export type MatrixDeviceHealthSummary = {
  currentDeviceId: string | null;
  staleSynthiosDevices: MatrixManagedDeviceInfo[];
  currentSynthiosDevices: MatrixManagedDeviceInfo[];
};

const SYNTHIOS_DEVICE_NAME_PREFIX = "Synthios ";

export function isSynthiosManagedMatrixDevice(displayName: string | null | undefined): boolean {
  return displayName?.startsWith(SYNTHIOS_DEVICE_NAME_PREFIX) === true;
}

export function summarizeMatrixDeviceHealth(
  devices: MatrixManagedDeviceInfo[],
): MatrixDeviceHealthSummary {
  const currentDeviceId = devices.find((device) => device.current)?.deviceId ?? null;
  const openClawDevices = devices.filter((device) =>
    isSynthiosManagedMatrixDevice(device.displayName),
  );
  return {
    currentDeviceId,
    staleSynthiosDevices: openClawDevices.filter((device) => !device.current),
    currentSynthiosDevices: openClawDevices.filter((device) => device.current),
  };
}
