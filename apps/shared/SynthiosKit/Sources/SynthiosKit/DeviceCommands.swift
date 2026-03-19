import Foundation

public enum SynthiosDeviceCommand: String, Codable, Sendable {
    case status = "device.status"
    case info = "device.info"
}

public enum SynthiosBatteryState: String, Codable, Sendable {
    case unknown
    case unplugged
    case charging
    case full
}

public enum SynthiosThermalState: String, Codable, Sendable {
    case nominal
    case fair
    case serious
    case critical
}

public enum SynthiosNetworkPathStatus: String, Codable, Sendable {
    case satisfied
    case unsatisfied
    case requiresConnection
}

public enum SynthiosNetworkInterfaceType: String, Codable, Sendable {
    case wifi
    case cellular
    case wired
    case other
}

public struct SynthiosBatteryStatusPayload: Codable, Sendable, Equatable {
    public var level: Double?
    public var state: SynthiosBatteryState
    public var lowPowerModeEnabled: Bool

    public init(level: Double?, state: SynthiosBatteryState, lowPowerModeEnabled: Bool) {
        self.level = level
        self.state = state
        self.lowPowerModeEnabled = lowPowerModeEnabled
    }
}

public struct SynthiosThermalStatusPayload: Codable, Sendable, Equatable {
    public var state: SynthiosThermalState

    public init(state: SynthiosThermalState) {
        self.state = state
    }
}

public struct SynthiosStorageStatusPayload: Codable, Sendable, Equatable {
    public var totalBytes: Int64
    public var freeBytes: Int64
    public var usedBytes: Int64

    public init(totalBytes: Int64, freeBytes: Int64, usedBytes: Int64) {
        self.totalBytes = totalBytes
        self.freeBytes = freeBytes
        self.usedBytes = usedBytes
    }
}

public struct SynthiosNetworkStatusPayload: Codable, Sendable, Equatable {
    public var status: SynthiosNetworkPathStatus
    public var isExpensive: Bool
    public var isConstrained: Bool
    public var interfaces: [SynthiosNetworkInterfaceType]

    public init(
        status: SynthiosNetworkPathStatus,
        isExpensive: Bool,
        isConstrained: Bool,
        interfaces: [SynthiosNetworkInterfaceType])
    {
        self.status = status
        self.isExpensive = isExpensive
        self.isConstrained = isConstrained
        self.interfaces = interfaces
    }
}

public struct SynthiosDeviceStatusPayload: Codable, Sendable, Equatable {
    public var battery: SynthiosBatteryStatusPayload
    public var thermal: SynthiosThermalStatusPayload
    public var storage: SynthiosStorageStatusPayload
    public var network: SynthiosNetworkStatusPayload
    public var uptimeSeconds: Double

    public init(
        battery: SynthiosBatteryStatusPayload,
        thermal: SynthiosThermalStatusPayload,
        storage: SynthiosStorageStatusPayload,
        network: SynthiosNetworkStatusPayload,
        uptimeSeconds: Double)
    {
        self.battery = battery
        self.thermal = thermal
        self.storage = storage
        self.network = network
        self.uptimeSeconds = uptimeSeconds
    }
}

public struct SynthiosDeviceInfoPayload: Codable, Sendable, Equatable {
    public var deviceName: String
    public var modelIdentifier: String
    public var systemName: String
    public var systemVersion: String
    public var appVersion: String
    public var appBuild: String
    public var locale: String

    public init(
        deviceName: String,
        modelIdentifier: String,
        systemName: String,
        systemVersion: String,
        appVersion: String,
        appBuild: String,
        locale: String)
    {
        self.deviceName = deviceName
        self.modelIdentifier = modelIdentifier
        self.systemName = systemName
        self.systemVersion = systemVersion
        self.appVersion = appVersion
        self.appBuild = appBuild
        self.locale = locale
    }
}
