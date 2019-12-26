//
//  File.swift
//  
//
//  Created by Maher Santina on 12/26/19.
//

import Vapor

public protocol WMSJobConvertible {
    var wmsJob: WMSJob { get }
}

public protocol WMSJobRepresentable: WMSJobConvertible {
    var wmsJobId: Int { get }
    var wmsJobName: String { get }
}

public protocol WMSCreateJobFormRepresentable {
    var jobCreateFormName: String { get }
}

public protocol WMSUpdateJobFormRepresentable {
    var jobUpdateFormId: Int { get }
    var jobUpdateFormName: String { get }
}

extension WMSCreateJobFormRepresentable {
    var wmsJobRow: WMSJobRow {
        return WMSJobRow(id: nil, name: jobCreateFormName)
    }
}

extension WMSUpdateJobFormRepresentable {
    var wmsJobRow: WMSJobRow {
        return WMSJobRow(id: jobUpdateFormId, name: jobUpdateFormName)
    }
}

extension WMSJobRepresentable {
    public var wmsJob: WMSJob {
        return WMSJob(id: wmsJobId, name: wmsJobName)
    }
}

extension WMSJob: WMSJobConvertible {
    public var wmsJob: WMSJob {
        return self
    }
}

extension Future where T: WMSJobConvertible {
    public var wmsJob: Future<WMSJob> {
        return self.map{ $0.wmsJob }
    }
}

public struct WMSJob: Content {
    public var id: Int
    public var name: String

    init(jobRow: WMSJobRow) {
        self.id = try! jobRow.requireID()
        self.name = jobRow.name
    }

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension Int {
    var wmsJobRow: WMSJobRow {
        return WMSJobRow(id: self, name: "")
    }
}

extension DSWMS {
    public func deleteJob(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<Void> {
        return WMSJobRow.delete(value: id.wmsJobRow, req: on)
    }

    public func updateJob(job: WMSUpdateJobFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSJob> {
        return WMSJobRow.update(value: job.wmsJobRow, req: on).map(WMSJob.init)
    }

    public func createJob(job: WMSCreateJobFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSJob> {
        return WMSJobRow.create(value: job.wmsJobRow, req: on).map(WMSJob.init)
    }

    public func getJob(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<WMSJob> {
        return WMSJobRow.first(where: "id = \(id)", req: on).unwrap(or: Abort(.notFound)).map(WMSJob.init)
    }

    public func getAllJobs(on: DatabaseConnectable) -> EventLoopFuture<[WMSJob]> {
        return WMSJobRow.all(where: nil, req: on).map{ $0.map(WMSJob.init) }
    }

    public func getJobs(queryString: String, on: DatabaseConnectable) -> EventLoopFuture<[WMSJob]> {
        return WMSJobRow.all(where: "name LIKE '%\(queryString)%'", req: on).map{ $0.map(WMSJob.init) }
    }
}
