//
//  PokemonFactory.swift
//  SuperRecord
//
//  Created by Piergiuseppe Longo on 21/11/14.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import UIKit
import CoreData

class PokemonFactory {

    
    class func createType (managedObjectContext: NSManagedObjectContext, id : TypeID, name : TypeName) -> Type{
    
        let type = Type.findFirstOrCreateWithAttribute("id", value: id.rawValue, context: managedObjectContext, handler: nil) as! Type;
        type.name = name.rawValue;
        return type;
    }
    
    class func createPokemon (managedObjectContext: NSManagedObjectContext, id : PokemonID, name : PokemonName, level: Int, type : Type) -> Pokemon{
        let pokemon = Pokemon.findFirstOrCreateWithAttribute("id", value: id.rawValue.description, context: managedObjectContext, handler: nil) as! Pokemon;
        pokemon.id =  id.rawValue
        pokemon.name = name.rawValue
        pokemon.level = level;
        pokemon.type = type;
        
        return pokemon
    }
    
    class func populate(managedObjectContext: NSManagedObjectContext ){
    
        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)
        let waterType = PokemonFactory.createType(managedObjectContext, id: .Water, name: .Water)
        let grassType = PokemonFactory.createType(managedObjectContext, id: .Grass, name: .Grass)
        
        PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: fireType)
        PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: fireType)
        PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: fireType)
        
        PokemonFactory.createPokemon(managedObjectContext, id: .Bulbasaur, name: .Bulbasaur, level: 1, type: grassType)
        PokemonFactory.createPokemon(managedObjectContext, id: .Ivysaur, name: .Ivysaur, level: 16, type: grassType)
        PokemonFactory.createPokemon(managedObjectContext, id: .Venusaur, name: .Venusaur, level: 36, type: grassType)
        
        PokemonFactory.createPokemon(managedObjectContext, id: .Squirtle, name: .Squirtle, level: 1, type: waterType)
        PokemonFactory.createPokemon(managedObjectContext, id: .Wartortle, name: .Wartortle, level: 16, type: waterType)
        PokemonFactory.createPokemon(managedObjectContext, id: .Blastoise, name: .Blastoise, level: 36, type: waterType)
    }
}

enum PokemonID : Int {
    case Bulbasaur = 1
    case Ivysaur = 2
    case Venusaur = 3
    case Charmender =  4
    case Charmeleon =  5
    case Charizard =  6
    case Squirtle = 7
    case Wartortle = 8
    case Blastoise = 9
}


enum PokemonName : String {
    case Bulbasaur = "Bulbasaur"
    case Ivysaur = "Ivysaur"
    case Venusaur = "Venusaur"
    case Charmender =  "Charmender"
    case Charmeleon =  "Charmeleon"
    case Charizard =  "Charizard"
    case Squirtle = "Squirtle"
    case Wartortle = "Wartortle"
    case Blastoise = "Blastoise"
}

enum TypeID : Int {
    case Fire
    case Grass
    case Water
}

enum TypeName : String {
    case Fire =  "Fire"
    case Grass = "Grass"
    case Water = "Water"
}
