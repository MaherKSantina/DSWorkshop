//
//  File.swift
//  
//
//  Created by Maher Santina on 12/13/19.
//

import DSAuth
import Vapor

extension WMSRegisterFromRepresentable {
    var authRegisterPost: UserRow.Register {
        return .init(email: registerEmail, password: registerPassword, organizationID: nil)
    }
}

extension WMSLoginFormRepresentable {
    var authLoginPost: LoginRow.Post {
        return .init(email: loginEmail, password: loginPassword, organizationID: nil)
    }
}

extension AccessDto: WMSAccessRepresentable {
    public var accessAccessToken: String {
        return accessToken
    }
}

extension DSAuthMain {
    public static func registerAndLogin(user: UserRow.Register, on: DatabaseConnectable, container: Container) throws -> EventLoopFuture<AccessDto> {
        return DSAuthMain.register(user: user, on: on, container: container).flatMap{ try DSAuthMain.login(user: .init(email: $0.User_email, password: $0.Login_password, organizationID: $0.Login_organizationID), on: container) }
    }
}

extension UserRow: WMSUserRepresentable {
    public var userId: Int {
        return try! requireID()
    }

    public var userEmail: String {
        return email
    }
}

extension WMSCreateUserFormRepresentable {
    public var authUserRow: UserRow {
        return UserRow(id: nil, email: userCreateFormEmail)
    }
}

extension WMSUpdateUserFormRepresentable {
    public var authUserRow: UserRow {
        return UserRow(id: userUpdateFormId, email: userUpdateFormEmail)
    }
}
