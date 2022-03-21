//
//  PokemonCoreData.swift
//  Pokemon Go
//
//  Created by Rethink on 18/03/22.
//

import UIKit
import CoreData

class PokemonCoreData{
    
    //Recuperar o context
    
    func getContext() -> NSManagedObjectContext{
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        return context
    }
    
    // Recuperar pokemons capturados
    func  recoverCapture(isCatched: Bool) -> [Pokemon]{
        
        let context = self.getContext()
        
        let request = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        
        
        if isCatched == true{
            request.predicate = NSPredicate(format: "capturado = %d", true)
        }
        else{
            request.predicate = NSPredicate(format: "capturado = %d", false)
        }
        
        
        do {
            let pokemons = try context.fetch(request) as [Pokemon]
            return pokemons
        } catch  {
            
        }
        
        return []
    }
    // Recuperar pokemons já existentes
    
    func recoverPokemons() -> [Pokemon]{
        
        let context = getContext()
        
        do {
            let pokemons = try context.fetch(Pokemon.fetchRequest()) as [Pokemon]
            
            if pokemons.count  == 0 {
                self.addPokemon()
                return self.recoverPokemons()
            }
            return pokemons
        } catch  {
            
        }
        return []
    }
    
    //Salvar pokemon
    
    func savePokemons(pokemon: Pokemon){
        let context = getContext()
        
        pokemon.capturado = true
        
        do {
            try context.save()
        } catch  {
            print("Deu erro")
        }
    }
    // Add todos os pokemons
    
    func addPokemon(){
       
        let context = getContext()
        
        pokemonMaker(name: "Mew", imageName: "mew", capturado: false)
        pokemonMaker(name: "Bellsprout", imageName: "bellsprout", capturado: true)
        pokemonMaker(name: "Bullbasaur", imageName: "bullbasaur", capturado: false)
        pokemonMaker(name: "Caterpie", imageName: "caterpie", capturado: false)
        pokemonMaker(name: "Charmander", imageName: "charmander", capturado: false)
        pokemonMaker(name: "Meowth", imageName: "meowth", capturado: false)
        pokemonMaker(name: "Pikachu", imageName: "pikachu", capturado: false)
        pokemonMaker(name: "Psyduck", imageName: "psyduck", capturado: false)
        pokemonMaker(name: "Rattata", imageName: "rattata", capturado: true)
        pokemonMaker(name: "Snorlax", imageName: "snorlax", capturado: false)
        pokemonMaker(name: "Squirtle", imageName: "squirtle", capturado: false)
        pokemonMaker(name: "Zubat", imageName: "zubat", capturado: false)
        pokemonMaker(name: "Giordano", imageName: "giordano", capturado: true)
        pokemonMaker(name: "Nankran", imageName: "nankran", capturado: false)
        pokemonMaker(name: "Dedé", imageName: "dede", capturado: true)
        pokemonMaker(name: "Fred", imageName: "fred", capturado: true)
        pokemonMaker(name: "Heringer", imageName: "heringer", capturado: false)
        //pokemonMaker(name: "Ricardo", imageName: "ricardo", capturado: true)
        pokemonMaker(name: "Filipe", imageName: "filipe", capturado: true)
       
        do {
            try context.save()
        } catch  {
            print("Deu erro")
        }
        
        
    }
    
    //criar os pokemons
    
    func pokemonMaker(name: String, imageName: String, capturado: Bool){
        let context = getContext()
        let pokemon = Pokemon(context: context)
        pokemon.name = name
        pokemon.imageName = imageName
        pokemon.capturado = capturado
    }
    
   
}
