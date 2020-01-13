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

public struct WMSWorkOrderRow {

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case jobID
        case vehicleID
        case notes
        case date
    }

    public var id: Int?
    public var vehicleID: WMSVehicleRow.ID
    public var jobID: WMSJobRow.ID
    public var notes: String?
    public var date: Date

    public init(id: Int? = nil, jobID: WMSJobRow.ID, vehicleID: WMSVehicleRow.ID, notes: String?, date: Date) {
        self.id = id
        self.jobID = jobID
        self.vehicleID = vehicleID
        self.notes = notes
        self.date = date
    }
}

extension WMSWorkOrderRow: DSModel {
    public static var entity: String = "WMSWorkOrder"
}

extension WMSWorkOrderRow: Hashable {

    public static func == (lhs: WMSWorkOrderRow, rhs: WMSWorkOrderRow) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension WMSWorkOrderRow: DSEntityControllable {
    public var `public`: WMSWorkOrder {
        return WMSWorkOrder(id: try! requireID(), jobID: jobID, vehicleID: vehicleID, notes: notes, date: date)
    }

    public init(id: Int) {
        self.id = id
        self.vehicleID = 0
        self.jobID = 0
        self.notes = nil
        self.date = Date()
    }

    public typealias Public = WMSWorkOrder
}

public struct WMSWorkOrder: Content, DSEntityPut {
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

    struct Post: DSEntityRelated, DSEntityPost {
        var entity: WMSWorkOrderRow {
            return WMSWorkOrderRow(id: nil, jobID: jobID, vehicleID: vehicleID, notes: notes, date: date)
        }

        typealias EntityType = WMSWorkOrderRow

        public var id: Int?
        public var jobID: WMSJobRow.ID
        public var vehicleID: WMSVehicleRow.ID
        public var notes: String?
        public var date: Date
    }
}

extension WMSWorkOrder: DSEntityRelated {
    public var entity: WMSWorkOrderRow {
        return WMSWorkOrderRow(id: id, jobID: jobID, vehicleID: vehicleID, notes: notes, date: date)
    }

    public typealias EntityType = WMSWorkOrderRow
}
