import Foundation

public enum SynthiosCameraCommand: String, Codable, Sendable {
    case list = "camera.list"
    case snap = "camera.snap"
    case clip = "camera.clip"
}

public enum SynthiosCameraFacing: String, Codable, Sendable {
    case back
    case front
}

public enum SynthiosCameraImageFormat: String, Codable, Sendable {
    case jpg
    case jpeg
}

public enum SynthiosCameraVideoFormat: String, Codable, Sendable {
    case mp4
}

public struct SynthiosCameraSnapParams: Codable, Sendable, Equatable {
    public var facing: SynthiosCameraFacing?
    public var maxWidth: Int?
    public var quality: Double?
    public var format: SynthiosCameraImageFormat?
    public var deviceId: String?
    public var delayMs: Int?

    public init(
        facing: SynthiosCameraFacing? = nil,
        maxWidth: Int? = nil,
        quality: Double? = nil,
        format: SynthiosCameraImageFormat? = nil,
        deviceId: String? = nil,
        delayMs: Int? = nil)
    {
        self.facing = facing
        self.maxWidth = maxWidth
        self.quality = quality
        self.format = format
        self.deviceId = deviceId
        self.delayMs = delayMs
    }
}

public struct SynthiosCameraClipParams: Codable, Sendable, Equatable {
    public var facing: SynthiosCameraFacing?
    public var durationMs: Int?
    public var includeAudio: Bool?
    public var format: SynthiosCameraVideoFormat?
    public var deviceId: String?

    public init(
        facing: SynthiosCameraFacing? = nil,
        durationMs: Int? = nil,
        includeAudio: Bool? = nil,
        format: SynthiosCameraVideoFormat? = nil,
        deviceId: String? = nil)
    {
        self.facing = facing
        self.durationMs = durationMs
        self.includeAudio = includeAudio
        self.format = format
        self.deviceId = deviceId
    }
}
