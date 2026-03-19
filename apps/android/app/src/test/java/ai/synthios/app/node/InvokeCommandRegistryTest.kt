package ai.synthios.app.node

import ai.synthios.app.protocol.SynthiosCalendarCommand
import ai.synthios.app.protocol.SynthiosCameraCommand
import ai.synthios.app.protocol.SynthiosCallLogCommand
import ai.synthios.app.protocol.SynthiosCapability
import ai.synthios.app.protocol.SynthiosContactsCommand
import ai.synthios.app.protocol.SynthiosDeviceCommand
import ai.synthios.app.protocol.SynthiosLocationCommand
import ai.synthios.app.protocol.SynthiosMotionCommand
import ai.synthios.app.protocol.SynthiosNotificationsCommand
import ai.synthios.app.protocol.SynthiosPhotosCommand
import ai.synthios.app.protocol.SynthiosSmsCommand
import ai.synthios.app.protocol.SynthiosSystemCommand
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class InvokeCommandRegistryTest {
  private val coreCapabilities =
    setOf(
      SynthiosCapability.Canvas.rawValue,
      SynthiosCapability.Device.rawValue,
      SynthiosCapability.Notifications.rawValue,
      SynthiosCapability.System.rawValue,
      SynthiosCapability.Photos.rawValue,
      SynthiosCapability.Contacts.rawValue,
      SynthiosCapability.Calendar.rawValue,
      SynthiosCapability.CallLog.rawValue,
    )

  private val optionalCapabilities =
    setOf(
      SynthiosCapability.Camera.rawValue,
      SynthiosCapability.Location.rawValue,
      SynthiosCapability.Sms.rawValue,
      SynthiosCapability.VoiceWake.rawValue,
      SynthiosCapability.Motion.rawValue,
    )

  private val coreCommands =
    setOf(
      SynthiosDeviceCommand.Status.rawValue,
      SynthiosDeviceCommand.Info.rawValue,
      SynthiosDeviceCommand.Permissions.rawValue,
      SynthiosDeviceCommand.Health.rawValue,
      SynthiosNotificationsCommand.List.rawValue,
      SynthiosNotificationsCommand.Actions.rawValue,
      SynthiosSystemCommand.Notify.rawValue,
      SynthiosPhotosCommand.Latest.rawValue,
      SynthiosContactsCommand.Search.rawValue,
      SynthiosContactsCommand.Add.rawValue,
      SynthiosCalendarCommand.Events.rawValue,
      SynthiosCalendarCommand.Add.rawValue,
      SynthiosCallLogCommand.Search.rawValue,
    )

  private val optionalCommands =
    setOf(
      SynthiosCameraCommand.Snap.rawValue,
      SynthiosCameraCommand.Clip.rawValue,
      SynthiosCameraCommand.List.rawValue,
      SynthiosLocationCommand.Get.rawValue,
      SynthiosMotionCommand.Activity.rawValue,
      SynthiosMotionCommand.Pedometer.rawValue,
      SynthiosSmsCommand.Send.rawValue,
      SynthiosSmsCommand.Search.rawValue,
    )

  private val debugCommands = setOf("debug.logs", "debug.ed25519")

  @Test
  fun advertisedCapabilities_respectsFeatureAvailability() {
    val capabilities = InvokeCommandRegistry.advertisedCapabilities(defaultFlags())

    assertContainsAll(capabilities, coreCapabilities)
    assertMissingAll(capabilities, optionalCapabilities)
  }

  @Test
  fun advertisedCapabilities_includesFeatureCapabilitiesWhenEnabled() {
    val capabilities =
      InvokeCommandRegistry.advertisedCapabilities(
        defaultFlags(
          cameraEnabled = true,
          locationEnabled = true,
          sendSmsAvailable = true,
          readSmsAvailable = true,
          voiceWakeEnabled = true,
          motionActivityAvailable = true,
          motionPedometerAvailable = true,
        ),
      )

    assertContainsAll(capabilities, coreCapabilities + optionalCapabilities)
  }

  @Test
  fun advertisedCommands_respectsFeatureAvailability() {
    val commands = InvokeCommandRegistry.advertisedCommands(defaultFlags())

    assertContainsAll(commands, coreCommands)
    assertMissingAll(commands, optionalCommands + debugCommands)
  }

  @Test
  fun advertisedCommands_includesFeatureCommandsWhenEnabled() {
    val commands =
      InvokeCommandRegistry.advertisedCommands(
        defaultFlags(
          cameraEnabled = true,
          locationEnabled = true,
          sendSmsAvailable = true,
          readSmsAvailable = true,
          motionActivityAvailable = true,
          motionPedometerAvailable = true,
          debugBuild = true,
        ),
      )

    assertContainsAll(commands, coreCommands + optionalCommands + debugCommands)
  }

  @Test
  fun advertisedCommands_onlyIncludesSupportedMotionCommands() {
    val commands =
      InvokeCommandRegistry.advertisedCommands(
        NodeRuntimeFlags(
          cameraEnabled = false,
          locationEnabled = false,
          sendSmsAvailable = false,
          readSmsAvailable = false,
          voiceWakeEnabled = false,
          motionActivityAvailable = true,
          motionPedometerAvailable = false,
          debugBuild = false,
        ),
      )

    assertTrue(commands.contains(SynthiosMotionCommand.Activity.rawValue))
    assertFalse(commands.contains(SynthiosMotionCommand.Pedometer.rawValue))
  }

  @Test
  fun advertisedCommands_splitsSmsSendAndSearchAvailability() {
    val readOnlyCommands =
      InvokeCommandRegistry.advertisedCommands(
        defaultFlags(readSmsAvailable = true),
      )
    val sendOnlyCommands =
      InvokeCommandRegistry.advertisedCommands(
        defaultFlags(sendSmsAvailable = true),
      )

    assertTrue(readOnlyCommands.contains(SynthiosSmsCommand.Search.rawValue))
    assertFalse(readOnlyCommands.contains(SynthiosSmsCommand.Send.rawValue))
    assertTrue(sendOnlyCommands.contains(SynthiosSmsCommand.Send.rawValue))
    assertFalse(sendOnlyCommands.contains(SynthiosSmsCommand.Search.rawValue))
  }

  @Test
  fun advertisedCapabilities_includeSmsWhenEitherSmsPathIsAvailable() {
    val readOnlyCapabilities =
      InvokeCommandRegistry.advertisedCapabilities(
        defaultFlags(readSmsAvailable = true),
      )
    val sendOnlyCapabilities =
      InvokeCommandRegistry.advertisedCapabilities(
        defaultFlags(sendSmsAvailable = true),
      )

    assertTrue(readOnlyCapabilities.contains(SynthiosCapability.Sms.rawValue))
    assertTrue(sendOnlyCapabilities.contains(SynthiosCapability.Sms.rawValue))
  }

  private fun defaultFlags(
    cameraEnabled: Boolean = false,
    locationEnabled: Boolean = false,
    sendSmsAvailable: Boolean = false,
    readSmsAvailable: Boolean = false,
    voiceWakeEnabled: Boolean = false,
    motionActivityAvailable: Boolean = false,
    motionPedometerAvailable: Boolean = false,
    debugBuild: Boolean = false,
  ): NodeRuntimeFlags =
    NodeRuntimeFlags(
      cameraEnabled = cameraEnabled,
      locationEnabled = locationEnabled,
      sendSmsAvailable = sendSmsAvailable,
      readSmsAvailable = readSmsAvailable,
      voiceWakeEnabled = voiceWakeEnabled,
      motionActivityAvailable = motionActivityAvailable,
      motionPedometerAvailable = motionPedometerAvailable,
      debugBuild = debugBuild,
    )

  private fun assertContainsAll(actual: List<String>, expected: Set<String>) {
    expected.forEach { value -> assertTrue(actual.contains(value)) }
  }

  private fun assertMissingAll(actual: List<String>, forbidden: Set<String>) {
    forbidden.forEach { value -> assertFalse(actual.contains(value)) }
  }
}
