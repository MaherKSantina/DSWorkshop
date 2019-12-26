//
//  File.swift
//
//
//  Created by Maher Santina on 12/26/19.
//

import Vapor

public protocol WMSWorkOrderConvertible {
    var wmsWorkOrder: WMSWorkOrder { get }
}

public protocol WMSWorkOrderDetailsRepresentable {
    var wmsWorkOrderVehicleID: WMSVehicleRow.ID { get }
    var wmsWorkOrderJobID: WMSJobRow.ID { get }
    var wmsWorkOrderNotes: String? { get }
    var wmsWorkOrderDate: Date { get }
}

public protocol WMSWorkOrderRepresentable: WMSWorkOrderDetailsRepresentable, WMSWorkOrderConvertible {
    var wmsWorkOrderId: Int { get }
}

extension WMSWorkOrderDetailsRepresentable {
    public var wmsWorkOrderRow: WMSWorkOrderRow {
        return WMSWorkOrderRow(id: nil, jobID: wmsWorkOrderJobID, vehicleID: wmsWorkOrderVehicleID, notes: wmsWorkOrderNotes, date: wmsWorkOrderDate)
    }
}

extension WMSWorkOrderRepresentable {
    public var wmsWorkOrderRow: WMSWorkOrderRow {
        return WMSWorkOrderRow(id: wmsWorkOrderId, jobID: wmsWorkOrderJobID, vehicleID: wmsWorkOrderVehicleID, notes: wmsWorkOrderNotes, date: wmsWorkOrderDate)
    }

    public var wmsWorkOrder: WMSWorkOrder {
        return WMSWorkOrder(id: wmsWorkOrderId, jobID: wmsWorkOrderJobID, vehicleID: wmsWorkOrderVehicleID, notes: wmsWorkOrderNotes, date: wmsWorkOrderDate)
    }
}

extension Future where T: WMSWorkOrderConvertible {
    public var wmsWorkOrder: Future<WMSWorkOrder> {
        return self.map{ $0.wmsWorkOrder }
    }
}

public struct WMSWorkOrder: Content {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case jobID
        case vehicleID
        case notes
        case date
    }

    public var id: Int
    public var vehicleID: WMSVehicleRow.ID
    public var jobID: WMSJobRow.ID
    public var notes: String?
    public var date: Date

    public init(id: Int, jobID: WMSJobRow.ID, vehicleID: WMSVehicleRow.ID, notes: String? = nil, date: Date) {
        self.id = id
        self.jobID = jobID
        self.vehicleID = vehicleID
        self.notes = notes
        self.date = date
    }
}

extension WMSWorkOrderRow: WMSWorkOrderRepresentable {
    public var wmsWorkOrderId: Int {
        return try! requireID()
    }

    public var wmsWorkOrderVehicleID: WMSVehicleRow.ID {
        return vehicleID
    }

    public var wmsWorkOrderJobID: WMSJobRow.ID {
        return jobID
    }

    public var wmsWorkOrderNotes: String? {
        return notes
    }

    public var wmsWorkOrderDate: Date {
        return date
    }
}

extension WMSWorkOrderRow {
    public var wmsWorkOrder: WMSWorkOrder {
        return WMSWorkOrder(id: try! requireID(), jobID: jobID, vehicleID: vehicleID, notes: notes, date: date)
    }
}

extension Int {
    public var wmsWorkOrderRow: WMSWorkOrderRow {
        return WMSWorkOrderRow(id: self, jobID: 0, vehicleID: 0, notes: nil, date: Date())
    }
}

//public protocol WMSWorkOrderConvertible2: WMSWorkOrderConvertible {
//    var wmsWorkOrder2: WMSWorkOrder2 { get }
//}
//
//public protocol WMSWorkOrderRepresentable2: WMSWorkOrderConvertible2, WMSWorkOrderRepresentable {
//    var wmsWorkOrderId: Int { get }
//    var wmsWorkOrderName: String { get }
//    var wmsWorkOrderUser: WMSUserRepresentable { get }
//}
//
//public struct WMSWorkOrder2: Content {
//    public var id: Int
//    public var name: String
//    public var user: WMSUser
//}
//
//extension WMSWorkOrder2: WMSWorkOrderRepresentable2 {
//
//    public var wmsWorkOrderId: Int {
//        return id
//    }
//
//    public var wmsWorkOrderName: String {
//        return name
//    }
//
//    public var wmsWorkOrderUser: WMSUserRepresentable {
//        return user
//    }
//}
//
//extension WMSWorkOrderRepresentable2 {
//    public var wmsWorkOrderUserID: Int {
//        return wmsWorkOrderUser.wmsUserId
//    }
//}
//
//extension WMSWorkOrderRepresentable2 {
//    public var wmsWorkOrder2: WMSWorkOrder2 {
//        return WMSWorkOrder2(id: wmsWorkOrderId, name: wmsWorkOrderName, user: wmsWorkOrderUser.wmsUser)
//    }
//}
//
//extension WMSWorkOrder2: WMSWorkOrderConvertible2 {
//    public var wmsWorkOrder2: WMSWorkOrder2 {
//        return self
//    }
//}
//
//extension Future where T: WMSWorkOrderConvertible2 {
//    public var wmsWorkOrder2: Future<WMSWorkOrder2> {
//        return self.map{ $0.wmsWorkOrder2 }
//    }
//}

//extension WMSWorkOrderRow {
//    func wmsWorkOrder2(req: DatabaseConnectable) -> Future<WMSWorkOrder2> {
//        return WMSWorkOrderUser.first(where: "WMSWorkOrder_id = \(try! requireID())", req: req).map{ $0! }.map{ $0.wmsWorkOrder2 }
//    }
//}

extension DSWMS {

    public func updateWorkOrder(workOrder: WMSWorkOrderRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSWorkOrder> {
        return WMSWorkOrderRow.update(value: workOrder.wmsWorkOrderRow, req: on).map{ $0.wmsWorkOrder }
    }

    public func createWorkOrder(workOrder: WMSWorkOrderDetailsRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSWorkOrder> {
        return WMSWorkOrderRow.create(value: workOrder.wmsWorkOrderRow, req: on).map{ $0.wmsWorkOrder }
    }

    public func getWorkOrder(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<WMSWorkOrder> {
        return WMSWorkOrderRow.first(where: "id = \(id)", req: on).unwrap(or: Abort(.notFound)).map{ $0.wmsWorkOrder }
    }

    public func getAllWorkOrders(on: DatabaseConnectable) -> EventLoopFuture<[WMSWorkOrder]> {
        return getAll(type: WMSWorkOrderRow.self, on: on).map{ $0.map{ $0.wmsWorkOrder } }
    }

    public func deleteWorkOrder(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<Void> {
        return id.wmsWorkOrderRow.delete(on: on)
    }

//    public func updateWorkOrder2(workOrder: WMSUpdateWorkOrderFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSWorkOrder2> {
//        return WMSWorkOrderRow.update(value: workOrder.wmsWorkOrderRow, req: on).flatMap{ $0.wmsWorkOrder2(req: on) }
//    }
//
//    public func createWorkOrder2(workOrder: WMSCreateWorkOrderFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSWorkOrder2> {
//        return WMSWorkOrderRow.create(value: workOrder.wmsWorkOrderRow, req: on).flatMap{ $0.wmsWorkOrder2(req: on) }
//    }
//
//    public func getWorkOrder2(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<WMSWorkOrder2> {
//        return WMSWorkOrderRow.first(where: "id = \(id)", req: on).unwrap(or: Abort(.notFound)).flatMap{ $0.wmsWorkOrder2(req: on) }
//    }
//
//    public func getAllWorkOrders2(on: DatabaseConnectable) -> EventLoopFuture<[WMSWorkOrder2]> {
//        return getAll(type: WMSWorkOrderUser.self, on: on).map{ $0.map{ $0.wmsWorkOrder2 } }
//    }

}
