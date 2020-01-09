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

extension Int {
    var wmsJobRow: WMSJobRow {
        return WMSJobRow(id: self, name: "")
    }
}
