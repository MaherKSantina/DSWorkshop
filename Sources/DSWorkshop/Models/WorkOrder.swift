//
//  Invoice.swift
//  App
//
//  Created by Maher Santina on 4/28/19.
//

import Vapor
import Fluent
import FluentMySQL
import DSCore

public struct WorkOrderRow {

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case jobID
        case notes
        case date
    }

    public var id: Int?
    public var jobID: JobRow.ID
    public var notes: String?
    public var date: Date

    public init(id: Int? = nil, jobID: JobRow.ID, notes: String?, date: Date) {
        self.id = id
        self.jobID = jobID
        self.notes = notes
        self.date = date
    }
}

extension WorkOrderRow: DSModel {
    public static func routePath() throws -> String {
        return "work-order"
    }

    public static var entity: String = "WorkOrder"
}

extension WorkOrderRow: Hashable {

    public static func == (lhs: WorkOrderRow, rhs: WorkOrderRow) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
