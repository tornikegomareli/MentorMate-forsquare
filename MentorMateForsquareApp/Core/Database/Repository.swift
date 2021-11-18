//
//  Repository.swift
//  MentorMateForsquareApp
//
//  Created by Tornike Gomareli on 18.11.21.
//

import Foundation

protocol Repository {
    associatedtype Entity
    func get() -> Result<[Entity], Error>
    func create() -> Result<Entity, Error>
    func delete(entity: Entity) -> Result<Bool, Error>
}
