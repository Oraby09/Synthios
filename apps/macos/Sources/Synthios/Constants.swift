import Foundation

// Stable identifier used for both the macOS LaunchAgent label and Nix-managed defaults suite.
// nix-synthios writes app defaults into this suite to survive app bundle identifier churn.
let launchdLabel = "ai.synthios.mac"
let gatewayLaunchdLabel = "ai.synthios.gateway"
let onboardingVersionKey = "synthios.onboardingVersion"
let onboardingSeenKey = "synthios.onboardingSeen"
let currentOnboardingVersion = 7
let pauseDefaultsKey = "synthios.pauseEnabled"
let iconAnimationsEnabledKey = "synthios.iconAnimationsEnabled"
let swabbleEnabledKey = "synthios.swabbleEnabled"
let swabbleTriggersKey = "synthios.swabbleTriggers"
let voiceWakeTriggerChimeKey = "synthios.voiceWakeTriggerChime"
let voiceWakeSendChimeKey = "synthios.voiceWakeSendChime"
let showDockIconKey = "synthios.showDockIcon"
let defaultVoiceWakeTriggers = ["synthios"]
let voiceWakeMaxWords = 32
let voiceWakeMaxWordLength = 64
let voiceWakeMicKey = "synthios.voiceWakeMicID"
let voiceWakeMicNameKey = "synthios.voiceWakeMicName"
let voiceWakeLocaleKey = "synthios.voiceWakeLocaleID"
let voiceWakeAdditionalLocalesKey = "synthios.voiceWakeAdditionalLocaleIDs"
let voicePushToTalkEnabledKey = "synthios.voicePushToTalkEnabled"
let talkEnabledKey = "synthios.talkEnabled"
let iconOverrideKey = "synthios.iconOverride"
let connectionModeKey = "synthios.connectionMode"
let remoteTargetKey = "synthios.remoteTarget"
let remoteIdentityKey = "synthios.remoteIdentity"
let remoteProjectRootKey = "synthios.remoteProjectRoot"
let remoteCliPathKey = "synthios.remoteCliPath"
let canvasEnabledKey = "synthios.canvasEnabled"
let cameraEnabledKey = "synthios.cameraEnabled"
let systemRunPolicyKey = "synthios.systemRunPolicy"
let systemRunAllowlistKey = "synthios.systemRunAllowlist"
let systemRunEnabledKey = "synthios.systemRunEnabled"
let locationModeKey = "synthios.locationMode"
let locationPreciseKey = "synthios.locationPreciseEnabled"
let peekabooBridgeEnabledKey = "synthios.peekabooBridgeEnabled"
let deepLinkKeyKey = "synthios.deepLinkKey"
let modelCatalogPathKey = "synthios.modelCatalogPath"
let modelCatalogReloadKey = "synthios.modelCatalogReload"
let cliInstallPromptedVersionKey = "synthios.cliInstallPromptedVersion"
let heartbeatsEnabledKey = "synthios.heartbeatsEnabled"
let debugPaneEnabledKey = "synthios.debugPaneEnabled"
let debugFileLogEnabledKey = "synthios.debug.fileLogEnabled"
let appLogLevelKey = "synthios.debug.appLogLevel"
let voiceWakeSupported: Bool = ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 26
