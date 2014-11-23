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

    class func createPokemon (managedObjectContext: NSManagedObjectContext, id : PokemonID, name : PokemonName, level: PokemonLevel, type : PokemonType) -> Pokemon{
     
        let pokemonType = Type.findFirstOrCreateWithAttribute("name", value: type.rawValue, context: managedObjectContext, handler: nil) as Type;

        var pokemon = Pokemon.findFirstOrCreateWithAttribute("id", value: id.rawValue.description, context: managedObjectContext, handler: nil) as Pokemon;
        pokemon.name = name.rawValue
        pokemon.level = level.rawValue;
        pokemon.type = pokemonType;
        
        return pokemon
    }
}

enum PokemonID : Int {
    case Charmender =  4
    case Charmeleon =  5
    case Charizard =  6
}


enum PokemonName : String {
    case Charmender =  "Charmender"
    case Charmeleon =  "Charmeleon"
    case Charizard =  "Charizard"
}

enum PokemonLevel : Int {
    case Charmender =  1
    case Charmeleon =  16
    case Charizard =  36
}


enum PokemonType : String {
    case Fire =  "Fire"
    case Grass = "Grass"
    case Water = "Water"
}
