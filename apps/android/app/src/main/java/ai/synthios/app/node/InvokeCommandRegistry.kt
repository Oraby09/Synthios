package ai.synthios.app.node

import ai.synthios.app.protocol.SynthiosCalendarCommand
import ai.synthios.app.protocol.SynthiosCanvasA2UICommand
import ai.synthios.app.protocol.SynthiosCanvasCommand
import ai.synthios.app.protocol.SynthiosCameraCommand
import ai.synthios.app.protocol.SynthiosCapability
import ai.synthios.app.protocol.SynthiosCallLogCommand
import ai.synthios.app.protocol.SynthiosContactsCommand
import ai.synthios.app.protocol.SynthiosDeviceCommand
import ai.synthios.app.protocol.SynthiosLocationCommand
import ai.synthios.app.protocol.SynthiosMotionCommand
import ai.synthios.app.protocol.SynthiosNotificationsCommand
import ai.synthios.app.protocol.SynthiosPhotosCommand
import ai.synthios.app.protocol.SynthiosSmsCommand
import ai.synthios.app.protocol.SynthiosSystemCommand

data class NodeRuntimeFlags(
  val cameraEnabled: Boolean,
  val locationEnabled: Boolean,
  val sendSmsAvailable: Boolean,
  val readSmsAvailable: Boolean,
  val voiceWakeEnabled: Boolean,
  val motionActivityAvailable: Boolean,
  val motionPedometerAvailable: Boolean,
  val debugBuild: Boolean,
)

enum class InvokeCommandAvailability {
  Always,
  CameraEnabled,
  LocationEnabled,
  SendSmsAvailable,
  ReadSmsAvailable,
  MotionActivityAvailable,
  MotionPedometerAvailable,
  DebugBuild,
}

enum class NodeCapabilityAvailability {
  Always,
  CameraEnabled,
  LocationEnabled,
  SmsAvailable,
  VoiceWakeEnabled,
  MotionAvailable,
}

data class NodeCapabilitySpec(
  val name: String,
  val availability: NodeCapabilityAvailability = NodeCapabilityAvailability.Always,
)

data class InvokeCommandSpec(
  val name: String,
  val requiresForeground: Boolean = false,
  val availability: InvokeCommandAvailability = InvokeCommandAvailability.Always,
)

object InvokeCommandRegistry {
  val capabilityManifest: List<NodeCapabilitySpec> =
    listOf(
      NodeCapabilitySpec(name = SynthiosCapability.Canvas.rawValue),
      NodeCapabilitySpec(name = SynthiosCapability.Device.rawValue),
      NodeCapabilitySpec(name = SynthiosCapability.Notifications.rawValue),
      NodeCapabilitySpec(name = SynthiosCapability.System.rawValue),
      NodeCapabilitySpec(
        name = SynthiosCapability.Camera.rawValue,
        availability = NodeCapabilityAvailability.CameraEnabled,
      ),
      NodeCapabilitySpec(
        name = SynthiosCapability.Sms.rawValue,
        availability = NodeCapabilityAvailability.SmsAvailable,
      ),
      NodeCapabilitySpec(
        name = SynthiosCapability.VoiceWake.rawValue,
        availability = NodeCapabilityAvailability.VoiceWakeEnabled,
      ),
      NodeCapabilitySpec(
        name = SynthiosCapability.Location.rawValue,
        availability = NodeCapabilityAvailability.LocationEnabled,
      ),
      NodeCapabilitySpec(name = SynthiosCapability.Photos.rawValue),
      NodeCapabilitySpec(name = SynthiosCapability.Contacts.rawValue),
      NodeCapabilitySpec(name = SynthiosCapability.Calendar.rawValue),
      NodeCapabilitySpec(
        name = SynthiosCapability.Motion.rawValue,
        availability = NodeCapabilityAvailability.MotionAvailable,
      ),
      NodeCapabilitySpec(name = SynthiosCapability.CallLog.rawValue),
    )

  val all: List<InvokeCommandSpec> =
    listOf(
      InvokeCommandSpec(
        name = SynthiosCanvasCommand.Present.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SynthiosCanvasCommand.Hide.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SynthiosCanvasCommand.Navigate.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SynthiosCanvasCommand.Eval.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SynthiosCanvasCommand.Snapshot.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SynthiosCanvasA2UICommand.Push.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SynthiosCanvasA2UICommand.PushJSONL.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SynthiosCanvasA2UICommand.Reset.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SynthiosSystemCommand.Notify.rawValue,
      ),
      InvokeCommandSpec(
        name = SynthiosCameraCommand.List.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = SynthiosCameraCommand.Snap.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = SynthiosCameraCommand.Clip.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = SynthiosLocationCommand.Get.rawValue,
        availability = InvokeCommandAvailability.LocationEnabled,
      ),
      InvokeCommandSpec(
        name = SynthiosDeviceCommand.Status.rawValue,
      ),
      InvokeCommandSpec(
        name = SynthiosDeviceCommand.Info.rawValue,
      ),
      InvokeCommandSpec(
        name = SynthiosDeviceCommand.Permissions.rawValue,
      ),
      InvokeCommandSpec(
        name = SynthiosDeviceCommand.Health.rawValue,
      ),
      InvokeCommandSpec(
        name = SynthiosNotificationsCommand.List.rawValue,
      ),
      InvokeCommandSpec(
        name = SynthiosNotificationsCommand.Actions.rawValue,
      ),
      InvokeCommandSpec(
        name = SynthiosPhotosCommand.Latest.rawValue,
      ),
      InvokeCommandSpec(
        name = SynthiosContactsCommand.Search.rawValue,
      ),
      InvokeCommandSpec(
        name = SynthiosContactsCommand.Add.rawValue,
      ),
      InvokeCommandSpec(
        name = SynthiosCalendarCommand.Events.rawValue,
      ),
      InvokeCommandSpec(
        name = SynthiosCalendarCommand.Add.rawValue,
      ),
      InvokeCommandSpec(
        name = SynthiosMotionCommand.Activity.rawValue,
        availability = InvokeCommandAvailability.MotionActivityAvailable,
      ),
      InvokeCommandSpec(
        name = SynthiosMotionCommand.Pedometer.rawValue,
        availability = InvokeCommandAvailability.MotionPedometerAvailable,
      ),
      InvokeCommandSpec(
        name = SynthiosSmsCommand.Send.rawValue,
        availability = InvokeCommandAvailability.SendSmsAvailable,
      ),
      InvokeCommandSpec(
        name = SynthiosSmsCommand.Search.rawValue,
        availability = InvokeCommandAvailability.ReadSmsAvailable,
      ),
      InvokeCommandSpec(
        name = SynthiosCallLogCommand.Search.rawValue,
      ),
      InvokeCommandSpec(
        name = "debug.logs",
        availability = InvokeCommandAvailability.DebugBuild,
      ),
      InvokeCommandSpec(
        name = "debug.ed25519",
        availability = InvokeCommandAvailability.DebugBuild,
      ),
    )

  private val byNameInternal: Map<String, InvokeCommandSpec> = all.associateBy { it.name }

  fun find(command: String): InvokeCommandSpec? = byNameInternal[command]

  fun advertisedCapabilities(flags: NodeRuntimeFlags): List<String> {
    return capabilityManifest
      .filter { spec ->
        when (spec.availability) {
          NodeCapabilityAvailability.Always -> true
          NodeCapabilityAvailability.CameraEnabled -> flags.cameraEnabled
          NodeCapabilityAvailability.LocationEnabled -> flags.locationEnabled
          NodeCapabilityAvailability.SmsAvailable -> flags.sendSmsAvailable || flags.readSmsAvailable
          NodeCapabilityAvailability.VoiceWakeEnabled -> flags.voiceWakeEnabled
          NodeCapabilityAvailability.MotionAvailable -> flags.motionActivityAvailable || flags.motionPedometerAvailable
        }
      }
      .map { it.name }
  }

  fun advertisedCommands(flags: NodeRuntimeFlags): List<String> {
    return all
      .filter { spec ->
        when (spec.availability) {
          InvokeCommandAvailability.Always -> true
          InvokeCommandAvailability.CameraEnabled -> flags.cameraEnabled
          InvokeCommandAvailability.LocationEnabled -> flags.locationEnabled
          InvokeCommandAvailability.SendSmsAvailable -> flags.sendSmsAvailable
          InvokeCommandAvailability.ReadSmsAvailable -> flags.readSmsAvailable
          InvokeCommandAvailability.MotionActivityAvailable -> flags.motionActivityAvailable
          InvokeCommandAvailability.MotionPedometerAvailable -> flags.motionPedometerAvailable
          InvokeCommandAvailability.DebugBuild -> flags.debugBuild
        }
      }
      .map { it.name }
  }
}
