//
//  File.swift
//  
//
//  Created by Maher Santina on 11/17/19.
//

import Foundation
import Vapor
import FluentMySQL

public class DSWorkshopMain {

    public init() { }

    public func workshopConfigure(migrations: inout MigrationConfig) throws {

        migrations.add(migration: EnableReferencesMigration.self, database: .mysql)
        migrations.add(model: WorkshopUserRow.self, database: .mysql)
        migrations.add(model: VehicleRow.self, database: .mysql)
        migrations.add(model: JobRow.self, database: .mysql)
        migrations.add(model: WorkOrderRow.self, database: .mysql)
    }
}
