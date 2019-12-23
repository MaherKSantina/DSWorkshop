//
//  File.swift
//  
//
//  Created by Maher Santina on 12/13/19.
//

import Vapor

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

public struct WMSVehicleUser: Content {
    public var vehicle_id: Int
    public var vehicle_name: String
    public var vehicle_userID: String
    public var user_id: Int
    public var user_email: String
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
        return user_id
    }

    public var wmsUserEmail: String {
        return user_email
    }
}

extension WMSVehicleUser: WMSVehicleRepresentable, WMSVehicleRepresentable2 {
    public var wmsVehicleUser: WMSUserRepresentable {
        return self
    }

    public var wmsVehicleId: Int {
        return vehicle_id
    }

    public var wmsVehicleName: String {
        return vehicle_name
    }

    public var wmsVehicleUserID: Int {
        return user_id
    }
}
