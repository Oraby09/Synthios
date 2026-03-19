package ai.synthios.app.protocol

import org.junit.Assert.assertEquals
import org.junit.Test

class SynthiosProtocolConstantsTest {
  @Test
  fun canvasCommandsUseStableStrings() {
    assertEquals("canvas.present", SynthiosCanvasCommand.Present.rawValue)
    assertEquals("canvas.hide", SynthiosCanvasCommand.Hide.rawValue)
    assertEquals("canvas.navigate", SynthiosCanvasCommand.Navigate.rawValue)
    assertEquals("canvas.eval", SynthiosCanvasCommand.Eval.rawValue)
    assertEquals("canvas.snapshot", SynthiosCanvasCommand.Snapshot.rawValue)
  }

  @Test
  fun a2uiCommandsUseStableStrings() {
    assertEquals("canvas.a2ui.push", SynthiosCanvasA2UICommand.Push.rawValue)
    assertEquals("canvas.a2ui.pushJSONL", SynthiosCanvasA2UICommand.PushJSONL.rawValue)
    assertEquals("canvas.a2ui.reset", SynthiosCanvasA2UICommand.Reset.rawValue)
  }

  @Test
  fun capabilitiesUseStableStrings() {
    assertEquals("canvas", SynthiosCapability.Canvas.rawValue)
    assertEquals("camera", SynthiosCapability.Camera.rawValue)
    assertEquals("voiceWake", SynthiosCapability.VoiceWake.rawValue)
    assertEquals("location", SynthiosCapability.Location.rawValue)
    assertEquals("sms", SynthiosCapability.Sms.rawValue)
    assertEquals("device", SynthiosCapability.Device.rawValue)
    assertEquals("notifications", SynthiosCapability.Notifications.rawValue)
    assertEquals("system", SynthiosCapability.System.rawValue)
    assertEquals("photos", SynthiosCapability.Photos.rawValue)
    assertEquals("contacts", SynthiosCapability.Contacts.rawValue)
    assertEquals("calendar", SynthiosCapability.Calendar.rawValue)
    assertEquals("motion", SynthiosCapability.Motion.rawValue)
    assertEquals("callLog", SynthiosCapability.CallLog.rawValue)
  }

  @Test
  fun cameraCommandsUseStableStrings() {
    assertEquals("camera.list", SynthiosCameraCommand.List.rawValue)
    assertEquals("camera.snap", SynthiosCameraCommand.Snap.rawValue)
    assertEquals("camera.clip", SynthiosCameraCommand.Clip.rawValue)
  }

  @Test
  fun notificationsCommandsUseStableStrings() {
    assertEquals("notifications.list", SynthiosNotificationsCommand.List.rawValue)
    assertEquals("notifications.actions", SynthiosNotificationsCommand.Actions.rawValue)
  }

  @Test
  fun deviceCommandsUseStableStrings() {
    assertEquals("device.status", SynthiosDeviceCommand.Status.rawValue)
    assertEquals("device.info", SynthiosDeviceCommand.Info.rawValue)
    assertEquals("device.permissions", SynthiosDeviceCommand.Permissions.rawValue)
    assertEquals("device.health", SynthiosDeviceCommand.Health.rawValue)
  }

  @Test
  fun systemCommandsUseStableStrings() {
    assertEquals("system.notify", SynthiosSystemCommand.Notify.rawValue)
  }

  @Test
  fun photosCommandsUseStableStrings() {
    assertEquals("photos.latest", SynthiosPhotosCommand.Latest.rawValue)
  }

  @Test
  fun contactsCommandsUseStableStrings() {
    assertEquals("contacts.search", SynthiosContactsCommand.Search.rawValue)
    assertEquals("contacts.add", SynthiosContactsCommand.Add.rawValue)
  }

  @Test
  fun calendarCommandsUseStableStrings() {
    assertEquals("calendar.events", SynthiosCalendarCommand.Events.rawValue)
    assertEquals("calendar.add", SynthiosCalendarCommand.Add.rawValue)
  }

  @Test
  fun motionCommandsUseStableStrings() {
    assertEquals("motion.activity", SynthiosMotionCommand.Activity.rawValue)
    assertEquals("motion.pedometer", SynthiosMotionCommand.Pedometer.rawValue)
  }

  @Test
  fun callLogCommandsUseStableStrings() {
    assertEquals("callLog.search", SynthiosCallLogCommand.Search.rawValue)
  }

  @Test
  fun smsCommandsUseStableStrings() {
    assertEquals("sms.search", SynthiosSmsCommand.Search.rawValue)
  }
}
