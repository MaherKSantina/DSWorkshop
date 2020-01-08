//
//  File.swift
//  
//
//  Created by Maher Santina on 12/13/19.
//

import Foundation
import DSCore
import FluentMySQL
import Vapor

public struct WMSUserRow: DSModel {
    public var id: Int?
    public var email: String

    public static var entity: String = "WMSUser"
}

public struct WMSUser: Content {

    enum CodingKeys: String, CodingKey {
        case id
        case email
    }

    public struct Post: Content {

        enum CodingKeys: String, CodingKey {
            case email
        }

        public var email: String
    }

    public struct Put: Content {

        enum CodingKeys: String, CodingKey {
            case id
            case email
        }

        public var id: Int
        public var email: String
    }

    public struct Delete: Content {

        enum CodingKeys: String, CodingKey {
            case id
        }

        public var id: Int
    }

    public var id: Int
    public var email: String

    init(entity: WMSUserRow) {
        self.id = try! entity.requireID()
        self.email = entity.email
    }

    init(id: Int, email: String) {
        self.id = id
        self.email = email
    }
}

extension WMSUser: EntityRelated {
    typealias EntityType = WMSUserRow
    var entity: WMSUserRow {
        return WMSUserRow(id: id, email: email)
    }
}

extension WMSUser.Post: EntityRelated, EntityPost {
    typealias EntityType = WMSUserRow

    var entity: WMSUserRow {
        return WMSUserRow(id: nil, email: email)
    }
}

extension WMSUser.Put: EntityRelated, EntityPut {
    typealias EntityType = WMSUserRow

    var entity: WMSUserRow {
        return WMSUserRow(id: id, email: email)
    }
}
extension WMSUser.Delete: EntityRelated, EntityDelete {
    typealias EntityType = WMSUserRow

    var entity: WMSUserRow {
        return WMSUserRow(id: id, email: "")
    }
}

extension WMSUser: WMSUserRepresentable {
    public var wmsUserId: Int {
        return id
    }

    public var wmsUserEmail: String {
        return email
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

extension WMSUserRow: EntityControllable {
    init(id: Int) {
        self.id = id
        self.email = ""
    }

    typealias Public = WMSUser

    var `public`: WMSUser {
        return WMSUser(entity: self)
    }
}

extension WMSUserRow: EntityQueryable {
    static func whereString(queryString: String) -> String {
        return "email LIKE '%\(queryString)%'"
    }
}
