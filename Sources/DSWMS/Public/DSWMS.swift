
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
        return WMSUserRow.all(where: "email LIKE '%\(queryString)%'", req: on).map{ $0.map(WMSUser.init) }
    }

    public func updateVehicle(user: WMSUpdateVehicleFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSVehicle> {
        return VehicleRow.update(value: user.workshopVehicleRow, req: on).map{ $0.wmsVehicle }
    }

    public func createVehicle(user: WMSCreateVehicleFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSVehicle> {
        return VehicleRow.create(value: user.workshopVehicleRow, req: on).map{ $0.wmsVehicle }
    }

    public func getVehicle(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<WMSVehicle> {
        return VehicleRow.first(where: "id = \(id)", req: on).unwrap(or: Abort(.notFound)).map{ $0.wmsVehicle }
    }

    public func getAllVehicles(on: DatabaseConnectable) -> EventLoopFuture<[WMSVehicle]> {
        return VehicleRow.all(where: nil, req: on).map{ $0.map{ $0.wmsVehicle } }
    }

    public func getAllVehicles2(on: DatabaseConnectable) -> EventLoopFuture<[WMSVehicle]> {
        return VehicleRow.query(on: on).all().map{ $0.map{ $0.wmsVehicle } }
    }

    public func deleteVehicle(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<Void> {
        return VehicleRow.first(where: "id = \(id)", req: on).flatMap{ $0?.delete(on: on) ?? on.future(()) }
    }

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

    public func register(user: WMSRegisterFromRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSAccess> {
        return try DSAuthMain.registerAndLogin(user: user.authRegisterPost, on: on).map{ $0.wmsAccess }
    }

    public func login(user: WMSLoginFormRepresentable, on: DatabaseConnectable) throws -> EventLoopFuture<WMSAccess> {
        return try DSAuthMain.login(user: user.authLoginPost, on: on).map{ $0.wmsAccess }
    }
}
