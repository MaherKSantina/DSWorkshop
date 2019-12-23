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

public struct WorkshopUserRow: MySQLModel {

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case email
    }

    public var id: Int?
    public var email: String

    public init(id: Int? = nil, email: String) {
        self.id = id
        self.email = email
    }
}

extension WorkshopUserRow: DSModel {
    public static func routePath() throws -> String {
        return "workshop-user"
    }

    public static var entity: String = "WorkshopUser"

    static var defaultDatabase: DatabaseIdentifier<MySQLDatabase>? = .mysql
}

extension WorkshopUserRow: Hashable {

    public static func == (lhs: WorkshopUserRow, rhs: WorkshopUserRow) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
