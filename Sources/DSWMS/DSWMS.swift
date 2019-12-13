
import Vapor
import DSAuth
import Fluent

public class DSWMS {

    public init() { }

    public static func configure(migrations: inout MigrationConfig) {
        DSAuthMain.configure(migrations: &migrations)
        migrations.add(model: WMSUserRow.self, database: .mysql)
    }
}
