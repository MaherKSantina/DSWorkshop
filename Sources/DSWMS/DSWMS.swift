
import Vapor
import DSAuth
import Fluent

public class DSWMS {

    public init() { }

    public static func configure(migrations: inout MigrationConfig) {
        DSAuthMain.configure(migrations: &migrations)
    }
}

extension DSWMS: WMSDelegate {

    public func deleteUser(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<Void> {
        return UserRow(id: id, email: "").delete(on: on)
    }

    public func updateUser(user: WMSUpdateUserFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSUserRepresentable> {
        return user.authUserRow.save(on: on).map{ $0 }
    }

    public func createUser(user: WMSCreateUserFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSUserRepresentable> {
        return user.authUserRow.save(on: on).map{ $0 } 
    }

    public func getUser(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<WMSUserRepresentable> {
        return UserRow.find(id, on: on).unwrap(or: Abort(.notFound)).map{ $0 }
    }

    public func getAllUsers(on: DatabaseConnectable) -> EventLoopFuture<[WMSUserRepresentable]> {
        return UserRow.query(on: on).all().map{ $0 }
    }

    public func register(user: WMSRegisterFromRepresentable, on: DatabaseConnectable, container: Container) throws -> EventLoopFuture<WMSAccessRepresentable> {
        return try DSAuthMain.registerAndLogin(user: user.authRegisterPost, on: on, container: container).map{ $0 }
    }

    public func login(user: WMSLoginFormRepresentable, on: Container) throws -> EventLoopFuture<WMSAccessRepresentable> {
        return try DSAuthMain.login(user: user.authLoginPost, on: on).map{ $0 }
    }
}
