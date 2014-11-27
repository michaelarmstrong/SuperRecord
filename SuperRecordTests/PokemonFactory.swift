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

    class func createPokemon (managedObjectContext: NSManagedObjectContext, id : PokemonID, name : PokemonName, level: Int, type : PokemonType) -> Pokemon{
     
        let pokemonType = Type.findFirstOrCreateWithAttribute("name", value: type.rawValue, context: managedObjectContext, handler: nil) as Type;

        var pokemon = Pokemon.findFirstOrCreateWithAttribute("id", value: id.rawValue.description, context: managedObjectContext, handler: nil) as Pokemon;
        pokemon.name = name.rawValue
        pokemon.level = level;
        pokemon.type = pokemonType;
        
        return pokemon
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


enum PokemonType : String {
    case Fire =  "Fire"
    case Grass = "Grass"
    case Water = "Water"
}
