import Vapor
import FluentMySQL
import Fluent

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first

//    try services.register(FluentProvider())
//    try services.register(MySQLProvider())
//
//    var commandConfig = CommandConfig.default()
//    commandConfig.useFluentCommands()
//    services.register(commandConfig)
//
//    var databases = DatabasesConfig()
//
//    let mysql = MySQLDatabase(config: MySQLDatabaseConfig(
//        hostname: "localhost",
//        port: 3306,
//        username: "root",
//        password: "root",
//        database: "auth-test"
//        )
//    )
//    databases.add(database: mysql, as: .mysql)
//    services.register(databases)
//
//    let auth = DSAuthMain()
//    var migrations = MigrationConfig()
//    auth.authConfigure(migrations: &migrations)
//    services.register(migrations)
}
