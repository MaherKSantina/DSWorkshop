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

public struct WMSVehicleRow {

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
        case userID
    }

    public var id: Int?
    public var name: String
    public var userID: WMSUserRow.ID

    public init(id: Int? = nil, name: String, userID: WMSUserRow.ID) {
        self.id = id
        self.name = name
        self.userID = userID
    }
}

extension WMSVehicleRow: DSModel {
    public static var entity: String = "WMSVehicle"
}

extension WMSVehicleRow: Hashable {

    public static func == (lhs: WMSVehicleRow, rhs: WMSVehicleRow) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
