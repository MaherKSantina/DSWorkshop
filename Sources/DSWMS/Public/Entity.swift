//
//  File.swift
//  
//
//  Created by Maher Santina on 12/31/19.
//

import DSCore
import Fluent
import Vapor

protocol EntityPost {

}

protocol EntityPut {

}

protocol EntityDelete {

}

protocol Publicable {
    associatedtype Public: Content

    var `public`: Public { get }
}

protocol EntityControllable: DSModel, Publicable {
    static var primaryKeyString: String { get }
    init(id: Int)
}

extension EntityControllable {
    static var primaryKeyString: String {
        return "id"
    }
}

protocol EntityQueryable {
    static func whereString(queryString: String) -> String
}

public protocol RowConvertible {
    associatedtype RowType
    var row: RowType { get }
}

extension EntityControllable {
    static func getAll(on: DatabaseConnectable) -> EventLoopFuture<[Public]> {
        return all(where: nil, req: on).map{ $0.map{ $0.public } }
    }

    static func get(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<Public> {
        return first(where: "\(primaryKeyString) = \(id)", req: on).unwrap(or: Abort(.notFound)).map{ $0.public }
    }

    static func delete(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<Void> {
        return delete(value: Self.init(id: id), req: on)
    }
}

extension EntityControllable where Self: EntityQueryable {
    static func getAll(queryString: String, on: DatabaseConnectable) -> EventLoopFuture<[Public]> {
        return all(where: whereString(queryString: queryString), req: on).map{ $0.map{ $0.public } }
    }
}

//extension EntityControllable where Self: RowConvertible, Self.RowType == Self {
//    static func create(value: Self, on: DatabaseConnectable) throws -> EventLoopFuture<Self.Public> {
//        return create(value: value.row, req: on).map{ $0.public }
//    }
//
//    static func update(value: Self, on: DatabaseConnectable) throws -> EventLoopFuture<Self.Public> {
//        return update(value: value.row, req: on).map{ $0.public }
//    }
//}

protocol EntityRelated {
    associatedtype EntityType: EntityControllable
    var entity: EntityType { get }
}

extension EntityRelated {
    static func getAll(on: DatabaseConnectable) -> EventLoopFuture<[EntityType.Public]> {
        return EntityType.getAll(on: on)
    }
    
    static func get(id: Int, on: DatabaseConnectable) throws -> EventLoopFuture<EntityType.Public> {
        return try EntityType.get(id: id, on: on)
    }
}

extension EntityRelated where EntityType: EntityQueryable {
    static func getAll(queryString: String, on: DatabaseConnectable) -> EventLoopFuture<[EntityType.Public]> {
        return EntityType.getAll(queryString: queryString, on: on)
    }
}

extension EntityRelated where Self: EntityPost {
    func create(on: DatabaseConnectable) throws -> EventLoopFuture<EntityType.Public> {
        return EntityType.create(value: self.entity, req: on).map{ $0.public }
    }
}

extension EntityRelated where Self: EntityPut {
    func update(on: DatabaseConnectable) throws -> EventLoopFuture<EntityType.Public> {
        return EntityType.update(value: self.entity, req: on).map{ $0.public }
    }
}

extension EntityRelated where Self: EntityDelete {
    func delete(on: DatabaseConnectable) throws -> EventLoopFuture<Void> {
        return EntityType.delete(value: self.entity, req: on)
    }
}
