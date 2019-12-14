
import Vapor
import DSAuth
import Fluent
import FluentMySQL
import DSWorkshop

public class DSWMS {

    public init() { }

    public static func configure(migrations: inout MigrationConfig) {
        DSAuthMain.configure(migrations: &migrations)
        migrations.add(model: WMSUserRow.self, database: .mysql)
        try! DSWorkshopMain().workshopConfigure(migrations: &migrations)
    }
}

extension DSWMS: WMSDelegate {
    public func getUsers(queryString: String, on: DatabaseConnectable) -> EventLoopFuture<[WMSUser]> {
        return WMSUserRow.query(on: on).filter(\.email == queryString).all().map{ $0.map(WMSUser.init) }
    }


    public func updateVehicle(user: WMSUpdateVehicleFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSVehicle> {
        return user.workshopVehicleRow.save(on: on).map{ $0.wmsVehicle }
    }

    public func createVehicle(user: WMSCreateVehicleFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSVehicle> {
        return user.workshopVehicleRow.save(on: on).map{ $0.wmsVehicle }
    }

    public func getVehicle(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<WMSVehicle> {
        return VehicleRow.find(id, on: on).unwrap(or: Abort(.notFound)).map{ $0.wmsVehicle }
    }

    public func getAllVehicles(on: DatabaseConnectable) -> EventLoopFuture<[WMSVehicle]> {
        return VehicleRow.query(on: on).all().map{ $0.map{ $0.wmsVehicle } }
    }

    public func deleteVehicle(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<Void> {
        return VehicleRow.find(id, on: on).flatMap{ $0?.delete(on: on) ?? on.future(()) }
    }


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
