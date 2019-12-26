//
//  File.swift
//  
//
//  Created by Maher Santina on 12/26/19.
//

import Vapor

extension WMSUser: WMSUserRepresentable {
    public var wmsUserId: Int {
        return id
    }

    public var wmsUserEmail: String {
        return email
    }
}


extension DSWMS {

    public func deleteUser(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<Void> {
        return WMSUserRow.delete(value: id.wmsUserRow, req: on)
    }

    public func updateUser(user: WMSUpdateUserFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSUser> {
        return WMSUserRow.update(value: user.wmsUserRow, req: on).map(WMSUser.init)
    }

    public func createUser(user: WMSCreateUserFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSUser> {
        return WMSUserRow.create(value: user.wmsUserRow, req: on).map(WMSUser.init)
    }

    public func getUser(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<WMSUser> {
        return WMSUserRow.first(where: "id = \(id)", req: on).unwrap(or: Abort(.notFound)).map(WMSUser.init)
    }

    public func getAllUsers(on: DatabaseConnectable) -> EventLoopFuture<[WMSUser]> {
        return WMSUserRow.all(where: nil, req: on).map{ $0.map(WMSUser.init) }
    }

    public func getUsers(queryString: String, on: DatabaseConnectable) -> EventLoopFuture<[WMSUser]> {
        return WMSUserRow.all(where: "email LIKE '%\(queryString)%'", req: on).map{ $0.map(WMSUser.init) }
    }
}
