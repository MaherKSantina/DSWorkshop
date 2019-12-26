//
//  File.swift
//  
//
//  Created by Maher Santina on 12/13/19.
//

import Vapor
import DSCore

public struct WMSAuthUser: Content {
    public var id: Int
    public var email: String
}

public struct WMSUser: Content {
    public var id: Int
    public var email: String

    init(userRow: WMSUserRow) {
        self.id = try! userRow.requireID()
        self.email = userRow.email
    }

    init(id: Int, email: String) {
        self.id = id
        self.email = email
    }
}

public struct WMSAccess: Content {
    public var token: String
}

public protocol WMSUserConvertible {
    var wmsUser: WMSUser { get }
}

public protocol WMSUserRepresentable: WMSUserConvertible {
    var wmsUserId: Int { get }
    var wmsUserEmail: String { get }
}

extension WMSUserRepresentable {
    public var wmsUser: WMSUser {
        return WMSUser(id: wmsUserId, email: wmsUserEmail)
    }
}

public struct WMSVehicleUser {
    public var WMSVehicle_id: Int
    public var WMSVehicle_name: String
    public var WMSVehicle_userID: Int
    public var WMSUser_id: Int
    public var WMSUser_email: String
}

extension WMSVehicleUser: DSTwoModelView {
    public typealias Model1 = WMSVehicleRow
    public typealias Model2 = WMSUserRow

    public static var entity: String {
        return tableName
    }

    public static var join: DSJoinRelationship {
        return .init(type: .inner, key1: "userID", key2: "id")
    }
    public static var model1selectFields: [String] {
        return [
            "id",
            "name",
            "userID"
        ]
    }
    public static var model2selectFields: [String] {
        return [
            "id",
            "email"
        ]
    }

    public var wmsVehicle2: WMSVehicle2 {
        let user = WMSUser(id: WMSUser_id, email: WMSUser_email)
        return WMSVehicle2(id: WMSVehicle_id, name: WMSVehicle_name, user: user)
    }
}

extension WMSVehicleUser: WMSUserRepresentable {
    public var wmsUserId: Int {
        return WMSUser_id
    }

    public var wmsUserEmail: String {
        return WMSUser_email
    }
}

extension WMSVehicleUser: WMSVehicleRepresentable, WMSVehicleRepresentable2 {
    public var wmsVehicleUser: WMSUserRepresentable {
        return self
    }

    public var wmsVehicleId: Int {
        return WMSVehicle_id
    }

    public var wmsVehicleName: String {
        return WMSVehicle_name
    }

    public var wmsVehicleUserID: Int {
        return WMSVehicle_userID
    }
}
