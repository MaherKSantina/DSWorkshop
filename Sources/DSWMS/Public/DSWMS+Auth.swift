//
//  File.swift
//  
//
//  Created by Maher Santina on 12/26/19.
//

import Vapor
import DSAuth

extension DSWMS {
    public func register(user: WMSRegisterFromRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSAccess> {
        return try DSAuthMain.registerAndLogin(user: user.authRegisterPost, on: on).map{ $0.wmsAccess }
    }

    public func login(user: WMSLoginFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSAccess> {
        return try DSAuthMain.login(user: user.authLoginPost, on: on).map{ $0.wmsAccess }
    }
}
