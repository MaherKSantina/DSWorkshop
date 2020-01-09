//
//  File.swift
//  
//
//  Created by Maher Santina on 12/26/19.
//

import Vapor

public protocol WMSVehicleConvertible {
    var wmsVehicle: WMSVehicle { get }
}

public protocol WMSVehicleRepresentable: WMSVehicleConvertible {
    var wmsVehicleId: Int { get }
    var wmsVehicleName: String { get }
    var wmsVehicleUserID: Int { get }
}

public protocol WMSCreateVehicleFormRepresentable {
    var vehicleCreateFormName: String { get }
    var vehicleCreateFormUserId: Int { get }
}

public protocol WMSUpdateVehicleFormRepresentable {
    var vehicleUpdateFormId: Int { get }
    var vehicleUpdateFormName: String { get }
    var vehicleUpdateFormUserId: Int { get }
}

extension WMSCreateVehicleFormRepresentable {
    var wmsVehicleRow: WMSVehicleRow {
        return WMSVehicleRow(id: nil, name: vehicleCreateFormName, userID: vehicleCreateFormUserId)
    }
}

extension WMSUpdateVehicleFormRepresentable {
    var wmsVehicleRow: WMSVehicleRow {
        return WMSVehicleRow(id: vehicleUpdateFormId, name: vehicleUpdateFormName, userID: vehicleUpdateFormUserId)
    }
}

extension WMSVehicleRepresentable {
    public var wmsVehicle: WMSVehicle {
        return WMSVehicle(id: wmsVehicleId, name: wmsVehicleName, userID: wmsVehicleUserID)
    }
}

extension WMSVehicle: WMSVehicleConvertible {
    public var wmsVehicle: WMSVehicle {
        return self
    }
}

extension Future where T: WMSVehicleConvertible {
    public var wmsVehicle: Future<WMSVehicle> {
        return self.map{ $0.wmsVehicle }
    }
}

public struct WMSVehicle: Content {
    public var id: Int
    public var name: String
    public var userID: Int
}

public protocol WMSVehicleConvertible2: WMSVehicleConvertible {
    var wmsVehicle2: WMSVehicle2 { get }
}

public protocol WMSVehicleRepresentable2: WMSVehicleConvertible2, WMSVehicleRepresentable {
    var wmsVehicleId: Int { get }
    var wmsVehicleName: String { get }
    var wmsVehicleUser: WMSUserRepresentable { get }
}

public struct WMSVehicle2: Content {
    public var id: Int
    public var name: String
    public var user: WMSUser
}

extension WMSVehicle2: WMSVehicleRepresentable2 {

    public var wmsVehicleId: Int {
        return id
    }

    public var wmsVehicleName: String {
        return name
    }

    public var wmsVehicleUser: WMSUserRepresentable {
        return user
    }
}

extension WMSVehicleRepresentable2 {
    public var wmsVehicleUserID: Int {
        return wmsVehicleUser.wmsUserId
    }
}

extension WMSVehicleRepresentable2 {
    public var wmsVehicle2: WMSVehicle2 {
        return WMSVehicle2(id: wmsVehicleId, name: wmsVehicleName, user: wmsVehicleUser.wmsUser)
    }
}

extension WMSVehicle2: WMSVehicleConvertible2 {
    public var wmsVehicle2: WMSVehicle2 {
        return self
    }
}

extension Future where T: WMSVehicleConvertible2 {
    public var wmsVehicle2: Future<WMSVehicle2> {
        return self.map{ $0.wmsVehicle2 }
    }
}

extension WMSVehicleRow {
    var wmsVehicle: WMSVehicle {
        return WMSVehicle(id: try! requireID(), name: name, userID: userID)
    }
}

extension WMSVehicleRow {
    func wmsVehicle2(req: DatabaseConnectable) -> Future<WMSVehicle2> {
        return WMSVehicleUser.first(where: "WMSVehicle_id = \(try! requireID())", req: req).map{ $0! }.map{ $0.wmsVehicle2 }
    }
}

extension DSWMS {

    public func updateVehicle2(vehicle: WMSUpdateVehicleFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSVehicle2> {
        return WMSVehicleRow.update(value: vehicle.wmsVehicleRow, req: on).flatMap{ $0.wmsVehicle2(req: on) }
    }

    public func createVehicle2(vehicle: WMSCreateVehicleFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSVehicle2> {
        return WMSVehicleRow.create(value: vehicle.wmsVehicleRow, req: on).flatMap{ $0.wmsVehicle2(req: on) }
    }

    public func getVehicle2(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<WMSVehicle2> {
        return WMSVehicleRow.first(where: "id = \(id)", req: on).unwrap(or: Abort(.notFound)).flatMap{ $0.wmsVehicle2(req: on) }
    }

    public func getAllVehicles2(on: DatabaseConnectable) -> EventLoopFuture<[WMSVehicle2]> {
        return getAll(type: WMSVehicleUser.self, on: on).map{ $0.map{ $0.wmsVehicle2 } }
    }
    
}
