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

public struct WMSJobRow {

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
    }

    public var id: Int?
    public var name: String

    public init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

extension WMSJobRow: DSModel {
    public static var entity: String = "WMSJob"
}

extension WMSJobRow: Hashable {

    public static func == (lhs: WMSJobRow, rhs: WMSJobRow) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
