//
//  File.swift
//  
//
//  Created by Maher Santina on 12/13/19.
//

import Vapor
import DSCore
import DSWorkshop

public protocol WMSDSViewRelated: DSView {
    associatedtype View: DSView
}

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

public protocol WMSVehicleRepresentable: WMSVehicleConvertible {
    var wmsVehicleId: Int { get }
    var wmsVehicleName: String { get }
    var wmsVehicleUserID: Int { get }
}

extension WMSVehicleRepresentable {
    public var wmsVehicle: WMSVehicle {
        return WMSVehicle(id: wmsVehicleId, name: wmsVehicleName, userID: wmsVehicleUserID)
    }
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

public protocol WMSVehicleRepresentable2: WMSVehicleConvertible2 {
    var wmsVehicleId: Int { get }
    var wmsVehicleName: String { get }
    var wmsVehicleUser: WMSUserRepresentable { get }
}

public struct WMSVehicle: Content {

    public var id: Int
    public var name: String
    public var userID: Int

    public init(id: Int, name: String, userID: Int) {
        self.id = id
        self.name = name
        self.userID = userID
    }
}

public struct WMSVehicleUser {
    public var Vehicle_id: Int
    public var Vehicle_name: String
    public var Vehicle_userID: Int
    public var WMSUser_id: Int
    public var WMSUser_email: String
}

extension WMSVehicleUser: DSTwoModelView {
    public typealias Model1 = VehicleRow
    public typealias Model2 = WMSUserRow

    public static var entity: String {
        return tableName
    }

    public static var join: JoinRelationship {
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
        return WMSVehicle2(id: Vehicle_id, name: Vehicle_name, user: user)
    }
}

public struct WMSVehicle2: Content {
    public var id: Int
    public var name: String
    public var user: WMSUser
}

extension WMSVehicle2: WMSVehicleRepresentable {
    public var wmsVehicleId: Int {
        return id
    }

    public var wmsVehicleName: String {
        return name
    }

    public var wmsVehicleUserID: Int {
        return user.id
    }
}

extension WMSVehicleRepresentable2 {
    public var wmsVehicle2: WMSVehicle2 {
        return WMSVehicle2(id: wmsVehicleId, name: wmsVehicleName, user: wmsVehicleUser.wmsUser)
    }
}

public protocol WMSVehicleConvertible {
    var wmsVehicle: WMSVehicle { get }
}

extension WMSVehicle: WMSVehicleConvertible {
    public var wmsVehicle: WMSVehicle {
        return self
    }
}

public protocol WMSVehicleConvertible2 {
    var wmsVehicle2: WMSVehicle2 { get }
}

extension WMSVehicle2: WMSVehicleConvertible2 {
    public var wmsVehicle2: WMSVehicle2 {
        return self
    }
}

extension Future where T: WMSVehicleConvertible {
    public var wmsVehicle: Future<WMSVehicle> {
        return self.map{ $0.wmsVehicle }
    }
}

extension Future where T: WMSVehicleConvertible2 {
    public var wmsVehicle2: Future<WMSVehicle2> {
        return self.map{ $0.wmsVehicle2 }
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
        return Vehicle_id
    }

    public var wmsVehicleName: String {
        return Vehicle_name
    }

    public var wmsVehicleUserID: Int {
        return Vehicle_userID
    }
}

//extension WMSVehicle2: WMSDSViewRelated
