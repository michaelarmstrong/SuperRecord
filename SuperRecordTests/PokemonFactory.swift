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

    
    class func createType (_ managedObjectContext: NSManagedObjectContext, id : TypeID, name : TypeName) -> Type{
    
        let type = Type.findFirstOrCreateWithAttribute("id", value: id.rawValue, context: managedObjectContext, handler: nil) as! Type;
        type.name = name.rawValue;
        return type;
    }
    
    class func createPokemon (_ managedObjectContext: NSManagedObjectContext, id : PokemonID, name : PokemonName, level: Int, type : Type) -> Pokemon{
        let pokemon = Pokemon.findFirstOrCreateWithAttribute("id", value: id.rawValue.description, context: managedObjectContext, handler: nil) as! Pokemon;
        pokemon.id =  id.rawValue
        pokemon.name = name.rawValue
        pokemon.level = level;
        pokemon.type = type;
        
        return pokemon
    }
    
    class func populate(_ managedObjectContext: NSManagedObjectContext ){
    
        let fireType = PokemonFactory.createType(managedObjectContext, id: .fire, name: .Fire)
        let waterType = PokemonFactory.createType(managedObjectContext, id: .water, name: .Water)
        let grassType = PokemonFactory.createType(managedObjectContext, id: .grass, name: .Grass)
        
        PokemonFactory.createPokemon(managedObjectContext, id: .charmender, name: .Charmender, level: 1, type: fireType)
        PokemonFactory.createPokemon(managedObjectContext, id: .charmeleon, name: .Charmeleon, level: 16, type: fireType)
        PokemonFactory.createPokemon(managedObjectContext, id: .charizard, name: .Charizard, level: 36, type: fireType)
        
        PokemonFactory.createPokemon(managedObjectContext, id: .bulbasaur, name: .Bulbasaur, level: 1, type: grassType)
        PokemonFactory.createPokemon(managedObjectContext, id: .ivysaur, name: .Ivysaur, level: 16, type: grassType)
        PokemonFactory.createPokemon(managedObjectContext, id: .venusaur, name: .Venusaur, level: 36, type: grassType)
        
        PokemonFactory.createPokemon(managedObjectContext, id: .squirtle, name: .Squirtle, level: 1, type: waterType)
        PokemonFactory.createPokemon(managedObjectContext, id: .wartortle, name: .Wartortle, level: 16, type: waterType)
        PokemonFactory.createPokemon(managedObjectContext, id: .blastoise, name: .Blastoise, level: 36, type: waterType)
    }
}

enum PokemonID : Int {
    case bulbasaur = 1
    case ivysaur = 2
    case venusaur = 3
    case charmender =  4
    case charmeleon =  5
    case charizard =  6
    case squirtle = 7
    case wartortle = 8
    case blastoise = 9
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
    case fire
    case grass
    case water
}

enum TypeName : String {
    case Fire =  "Fire"
    case Grass = "Grass"
    case Water = "Water"
}
