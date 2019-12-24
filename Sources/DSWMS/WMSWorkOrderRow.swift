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

public struct WMSWorkOrderRow {

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case jobID
        case notes
        case date
    }

    public var id: Int?
    public var jobID: WMSJobRow.ID
    public var notes: String?
    public var date: Date

    public init(id: Int? = nil, jobID: WMSJobRow.ID, notes: String?, date: Date) {
        self.id = id
        self.jobID = jobID
        self.notes = notes
        self.date = date
    }
}

extension WMSWorkOrderRow: DSModel {
    public static var entity: String = "WMSWorkOrder"
}

extension WMSWorkOrderRow: Hashable {

    public static func == (lhs: WMSWorkOrderRow, rhs: WMSWorkOrderRow) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
