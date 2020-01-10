
import Vapor
import DSAuth
import Fluent
import FluentMySQL
import DSCore

public class DSWMS {

    public init() { }

    public static func configure(migrations: inout MigrationConfig) {
        DSAuthMain.configure(migrations: &migrations)
        migrations.add(model: WMSUserRow.self, database: .mysql)
        migrations.add(model: WMSVehicleRow.self, database: .mysql)
        migrations.add(model: WMSJobRow.self, database: .mysql)
        migrations.add(model: WMSWorkOrderRow.self, database: .mysql)
        migrations.add(migration: WMSVehicleUserRow.self, database: .mysql)
    }

    public func getAll<T: DSDatabaseReadOnlyInteractable>(type: T.Type, on: DatabaseConnectable) -> Future<[T]> {
        return T.all(where: nil, req: on)
    }
}
