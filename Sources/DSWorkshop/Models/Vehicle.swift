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

public struct VehicleRow {

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
        case userID
    }

    public var id: Int?
    public var name: String
    public var userID: WorkshopUserRow.ID

    public init(id: Int? = nil, name: String, userID: WorkshopUserRow.ID) {
        self.id = id
        self.name = name
        self.userID = userID
    }
}

extension VehicleRow: DSModel {
    public static func routePath() throws -> String {
        return "vehicle"
    }

    public static var entity: String = "Vehicle"

    static var defaultDatabase: DatabaseIdentifier<MySQLDatabase>? = .mysql
}

extension VehicleRow: Hashable {

    public static func == (lhs: VehicleRow, rhs: VehicleRow) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
