//
//  File.swift
//  
//
//  Created by Maher Santina on 12/13/19.
//

import Vapor
import DSAuth


extension DSWMS: WMSDelegate {

    public func deleteUser(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<Void> {
        return id.wmsUserRow.delete(on: on)
    }

    public func updateUser(user: WMSUpdateUserFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSUser> {
        return user.wmsUserRow.save(on: on).map(WMSUser.init)
    }

    public func createUser(user: WMSCreateUserFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSUser> {
        return user.wmsUserRow.save(on: on).map(WMSUser.init)
    }

    public func getUser(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<WMSUser> {
        return WMSUserRow.find(id, on: on).unwrap(or: Abort(.notFound)).map(WMSUser.init)
    }

    public func getAllUsers(on: DatabaseConnectable) -> EventLoopFuture<[WMSUser]> {
        return WMSUserRow.query(on: on).all().map{ $0.map(WMSUser.init) }
    }

    public func register(user: WMSRegisterFromRepresentable, on: DatabaseConnectable, container: Container) throws -> EventLoopFuture<WMSAccess> {
        return try DSAuthMain.registerAndLogin(user: user.authRegisterPost, on: on, container: container).map{ $0.wmsAccess }
    }

    public func login(user: WMSLoginFormRepresentable, on: Container) throws -> EventLoopFuture<WMSAccess> {
        return try DSAuthMain.login(user: user.authLoginPost, on: on).map{ $0.wmsAccess }
    }
}
