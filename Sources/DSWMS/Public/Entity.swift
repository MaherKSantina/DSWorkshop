//
//  File.swift
//  
//
//  Created by Maher Santina on 12/31/19.
//

import DSCore
import Fluent
import Vapor

public protocol EntityPost {

}

public protocol EntityPut {

}

public protocol EntityDelete {

}

public protocol Publicable {
    associatedtype Public: Content

    var `public`: Public { get }
}

public protocol EntityControllable: DSModel, Publicable {
    static var primaryKeyString: String { get }
    init(id: Int)
}

extension EntityControllable {
    public static var primaryKeyString: String {
        return "id"
    }
}

public protocol EntityQueryable {
    static func whereString(queryString: String) -> String
}

extension EntityControllable {
    public static func getAll(on: DatabaseConnectable) -> EventLoopFuture<[Public]> {
        return all(where: nil, req: on).map{ $0.map{ $0.public } }
    }

    public static func get(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<Public> {
        return first(where: "\(primaryKeyString) = \(id)", req: on).unwrap(or: Abort(.notFound)).map{ $0.public }
    }

    public static func delete(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<Void> {
        return delete(value: Self.init(id: id), req: on)
    }
}

extension EntityControllable where Self: EntityQueryable {
    public static func getAll(queryString: String, on: DatabaseConnectable) -> EventLoopFuture<[Public]> {
        return all(where: whereString(queryString: queryString), req: on).map{ $0.map{ $0.public } }
    }
}

public protocol EntityRelated {
    associatedtype EntityType: EntityControllable
    var entity: EntityType { get }
}

extension EntityRelated {
    public static func getAll(on: DatabaseConnectable) -> EventLoopFuture<[EntityType.Public]> {
        return EntityType.getAll(on: on)
    }
    
    public static func get(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<EntityType.Public> {
        return try EntityType.get(id: id, on: on)
    }
}

extension EntityRelated where EntityType: EntityQueryable {
    public static func getAll(queryString: String, on: DatabaseConnectable) -> EventLoopFuture<[EntityType.Public]> {
        return EntityType.getAll(queryString: queryString, on: on)
    }
}

extension EntityRelated where Self: EntityPost {
    public func create(on: DatabaseConnectable) throws -> EventLoopFuture<EntityType.Public> {
        return EntityType.create(value: self.entity, req: on).map{ $0.public }
    }
}

extension EntityRelated where Self: EntityPut {
    public func update(on: DatabaseConnectable) throws -> EventLoopFuture<EntityType.Public> {
        return EntityType.update(value: self.entity, req: on).map{ $0.public }
    }
}

extension EntityRelated where Self: EntityDelete {
    public func delete(on: DatabaseConnectable) throws -> EventLoopFuture<Void> {
        return EntityType.delete(value: self.entity, req: on)
    }
}
