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

public struct WMSVehicle: Content {
    public var id: Int
    public var name: String
    public var userID: Int

    struct Post: Content, EntityPost, EntityRelated {
        var entity: WMSVehicleRow {
            return WMSVehicleRow(id: nil, name: name, userID: userID)
        }

        typealias EntityType = WMSVehicleRow

        public var name: String
        public var userID: Int
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

extension WMSVehicleRow: EntityControllable {
    public var `public`: WMSVehicle {
        return WMSVehicle(id: try! requireID(), name: name, userID: userID)
    }

    public init(id: Int) {
        self.id = id
        self.name = ""
        self.userID = -1
    }

    public typealias Public = WMSVehicle
}

extension WMSVehicle: EntityRelated {
    public var entity: WMSVehicleRow {
        return WMSVehicleRow(id: id, name: name, userID: userID)
    }

    public typealias EntityType = WMSVehicleRow


}

extension WMSVehicle: EntityPut, EntityDelete {
    
}

// MARK: - WMSVehicle 2

public struct WMSVehicleUserRow {
    public var WMSVehicle_id: Int
    public var WMSVehicle_name: String
    public var WMSVehicle_userID: Int
    public var WMSUser_id: Int
    public var WMSUser_email: String
}

extension WMSVehicleUserRow: DSTwoModelView {
    public typealias Model1 = WMSVehicleRow
    public typealias Model2 = WMSUserRow

    public static var entity: String {
        return tableName
    }

    public static var join: DSJoinRelationship {
        return .init(type: .inner, key1: "userID", key2: "id")
    }
    public static var model1selectFields: [String] {
        return WMSVehicleRow.CodingKeys.allCases.map{ $0.rawValue }
    }
    public static var model2selectFields: [String] {
        return WMSUserRow.CodingKeys.allCases.map{ $0.rawValue }
    }

    public var wmsVehicle2: WMSVehicle2 {
        let user = WMSUser(id: WMSUser_id, email: WMSUser_email)
        return WMSVehicle2(id: WMSVehicle_id, name: WMSVehicle_name, user: user)
    }
}

extension WMSVehicleUserRow: EntityControllable {
    public var `public`: WMSVehicle2 {
        let user = WMSUser(id: WMSUser_id, email: WMSUser_email)
        return WMSVehicle2(id: WMSVehicle_id, name: WMSVehicle_name, user: user)
    }

    public static var primaryKeyString: String {
        return "WMSVehicle_id"
    }

    public init(id: Int) {
        self.WMSVehicle_id = id
        self.WMSVehicle_name = ""
        self.WMSVehicle_userID = 0
        self.WMSUser_id = 0
        self.WMSUser_email = ""
    }

    public typealias Public = WMSVehicle2

    public var id: Int? {
        get {
            return WMSVehicle_id
        }
        set(newValue) {
            WMSVehicle_id = newValue ?? 0
        }
    }

    public static func revert(on conn: MySQLDatabase.Connection) -> EventLoopFuture<Void> {
        return conn.future()
    }
}

public struct WMSVehicle2: Content {
    public var id: Int
    public var name: String
    public var user: WMSUser
}

extension WMSVehicle2: EntityRelated {
    public var entity: WMSVehicleUserRow {
        return WMSVehicleUserRow(WMSVehicle_id: id, WMSVehicle_name: name, WMSVehicle_userID: user.id, WMSUser_id: user.id, WMSUser_email: user.email)
    }

    public typealias EntityType = WMSVehicleUserRow
}
