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

public struct WMSJobRow {

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
    }

    public var id: Int?
    public var name: String

    public init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

public struct WMSJob: Content {

    struct Post: EntityPost, EntityRelated {
        typealias EntityType = WMSJobRow

        var entity: WMSJobRow {
            return WMSJobRow(id: nil, name: name)
        }

        public var name: String
    }

    public var id: Int
    public var name: String

    init(jobRow: WMSJobRow) {
        self.id = try! jobRow.requireID()
        self.name = jobRow.name
    }

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension WMSJobRow: DSModel {
    public static var entity: String = "WMSJob"
}

extension WMSJobRow: Hashable {

    public static func == (lhs: WMSJobRow, rhs: WMSJobRow) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension WMSJobRow: EntityControllable {
    public var `public`: WMSJob {
        return WMSJob(id: try! requireID(), name: name)
    }

    public init(id: Int) {
        self.id = id
        self.name = ""
    }

    public typealias Public = WMSJob
}

extension WMSJobRow: EntityQueryable {
    public static func whereString(queryString: String) -> String {
        return "name LIKE '%\(queryString)%'"
    }
}

extension WMSJob: EntityRelated {
    public var entity: WMSJobRow {
        return WMSJobRow(id: id, name: name)
    }

    public typealias EntityType = WMSJobRow
}

extension WMSJob: EntityPost, EntityPut, EntityDelete {  }
