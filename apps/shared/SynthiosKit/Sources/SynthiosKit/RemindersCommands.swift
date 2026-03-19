import Foundation

public enum SynthiosRemindersCommand: String, Codable, Sendable {
    case list = "reminders.list"
    case add = "reminders.add"
}

public enum SynthiosReminderStatusFilter: String, Codable, Sendable {
    case incomplete
    case completed
    case all
}

public struct SynthiosRemindersListParams: Codable, Sendable, Equatable {
    public var status: SynthiosReminderStatusFilter?
    public var limit: Int?

    public init(status: SynthiosReminderStatusFilter? = nil, limit: Int? = nil) {
        self.status = status
        self.limit = limit
    }
}

public struct SynthiosRemindersAddParams: Codable, Sendable, Equatable {
    public var title: String
    public var dueISO: String?
    public var notes: String?
    public var listId: String?
    public var listName: String?

    public init(
        title: String,
        dueISO: String? = nil,
        notes: String? = nil,
        listId: String? = nil,
        listName: String? = nil)
    {
        self.title = title
        self.dueISO = dueISO
        self.notes = notes
        self.listId = listId
        self.listName = listName
    }
}

public struct SynthiosReminderPayload: Codable, Sendable, Equatable {
    public var identifier: String
    public var title: String
    public var dueISO: String?
    public var completed: Bool
    public var listName: String?

    public init(
        identifier: String,
        title: String,
        dueISO: String? = nil,
        completed: Bool,
        listName: String? = nil)
    {
        self.identifier = identifier
        self.title = title
        self.dueISO = dueISO
        self.completed = completed
        self.listName = listName
    }
}

public struct SynthiosRemindersListPayload: Codable, Sendable, Equatable {
    public var reminders: [SynthiosReminderPayload]

    public init(reminders: [SynthiosReminderPayload]) {
        self.reminders = reminders
    }
}

public struct SynthiosRemindersAddPayload: Codable, Sendable, Equatable {
    public var reminder: SynthiosReminderPayload

    public init(reminder: SynthiosReminderPayload) {
        self.reminder = reminder
    }
}
