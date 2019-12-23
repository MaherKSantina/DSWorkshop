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

public struct JobRow: MySQLModel {

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

extension JobRow: DSModel {
    public static func routePath() throws -> String {
        return "job"
    }

    public static var entity: String = "Job"

    static var defaultDatabase: DatabaseIdentifier<MySQLDatabase>? = .mysql
}

extension JobRow: Hashable {

    public static func == (lhs: JobRow, rhs: JobRow) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
