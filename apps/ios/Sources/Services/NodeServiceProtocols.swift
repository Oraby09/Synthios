import CoreLocation
import Foundation
import SynthiosKit
import UIKit

typealias SynthiosCameraSnapResult = (format: String, base64: String, width: Int, height: Int)
typealias SynthiosCameraClipResult = (format: String, base64: String, durationMs: Int, hasAudio: Bool)

protocol CameraServicing: Sendable {
    func listDevices() async -> [CameraController.CameraDeviceInfo]
    func snap(params: SynthiosCameraSnapParams) async throws -> SynthiosCameraSnapResult
    func clip(params: SynthiosCameraClipParams) async throws -> SynthiosCameraClipResult
}

protocol ScreenRecordingServicing: Sendable {
    func record(
        screenIndex: Int?,
        durationMs: Int?,
        fps: Double?,
        includeAudio: Bool?,
        outPath: String?) async throws -> String
}

@MainActor
protocol LocationServicing: Sendable {
    func authorizationStatus() -> CLAuthorizationStatus
    func accuracyAuthorization() -> CLAccuracyAuthorization
    func ensureAuthorization(mode: SynthiosLocationMode) async -> CLAuthorizationStatus
    func currentLocation(
        params: SynthiosLocationGetParams,
        desiredAccuracy: SynthiosLocationAccuracy,
        maxAgeMs: Int?,
        timeoutMs: Int?) async throws -> CLLocation
    func startLocationUpdates(
        desiredAccuracy: SynthiosLocationAccuracy,
        significantChangesOnly: Bool) -> AsyncStream<CLLocation>
    func stopLocationUpdates()
    func startMonitoringSignificantLocationChanges(onUpdate: @escaping @Sendable (CLLocation) -> Void)
    func stopMonitoringSignificantLocationChanges()
}

@MainActor
protocol DeviceStatusServicing: Sendable {
    func status() async throws -> SynthiosDeviceStatusPayload
    func info() -> SynthiosDeviceInfoPayload
}

protocol PhotosServicing: Sendable {
    func latest(params: SynthiosPhotosLatestParams) async throws -> SynthiosPhotosLatestPayload
}

protocol ContactsServicing: Sendable {
    func search(params: SynthiosContactsSearchParams) async throws -> SynthiosContactsSearchPayload
    func add(params: SynthiosContactsAddParams) async throws -> SynthiosContactsAddPayload
}

protocol CalendarServicing: Sendable {
    func events(params: SynthiosCalendarEventsParams) async throws -> SynthiosCalendarEventsPayload
    func add(params: SynthiosCalendarAddParams) async throws -> SynthiosCalendarAddPayload
}

protocol RemindersServicing: Sendable {
    func list(params: SynthiosRemindersListParams) async throws -> SynthiosRemindersListPayload
    func add(params: SynthiosRemindersAddParams) async throws -> SynthiosRemindersAddPayload
}

protocol MotionServicing: Sendable {
    func activities(params: SynthiosMotionActivityParams) async throws -> SynthiosMotionActivityPayload
    func pedometer(params: SynthiosPedometerParams) async throws -> SynthiosPedometerPayload
}

struct WatchMessagingStatus: Sendable, Equatable {
    var supported: Bool
    var paired: Bool
    var appInstalled: Bool
    var reachable: Bool
    var activationState: String
}

struct WatchQuickReplyEvent: Sendable, Equatable {
    var replyId: String
    var promptId: String
    var actionId: String
    var actionLabel: String?
    var sessionKey: String?
    var note: String?
    var sentAtMs: Int?
    var transport: String
}

struct WatchNotificationSendResult: Sendable, Equatable {
    var deliveredImmediately: Bool
    var queuedForDelivery: Bool
    var transport: String
}

protocol WatchMessagingServicing: AnyObject, Sendable {
    func status() async -> WatchMessagingStatus
    func setReplyHandler(_ handler: (@Sendable (WatchQuickReplyEvent) -> Void)?)
    func sendNotification(
        id: String,
        params: SynthiosWatchNotifyParams) async throws -> WatchNotificationSendResult
}

extension CameraController: CameraServicing {}
extension ScreenRecordService: ScreenRecordingServicing {}
extension LocationService: LocationServicing {}
