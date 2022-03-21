//
//  PokeDeskViewController.swift
//  Pokemon Go
//
//  Created by Rethink on 18/03/22.
//

import UIKit

class PokeDeskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
   

    var capturePokemon: [Pokemon] = []
    var freePokemon: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let coreDataPokemon = PokemonCoreData()
        
        self.capturePokemon = coreDataPokemon.recoverCapture(isCatched: true)
        self.freePokemon = coreDataPokemon.recoverCapture(isCatched: false)
    
        print(String(self.capturePokemon.count))
    }
    
    @IBAction func mapBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.capturePokemon.count
        }else{
            return self.freePokemon.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        var pokemon: Pokemon
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "reuseIdentifier")
        
        
        if indexPath.section == 0{
            pokemon = capturePokemon[indexPath.row]
        }else{
            pokemon = freePokemon[indexPath.row]
        }
        cell.textLabel?.text = pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.imageName!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Captured"
        }else{
            return "Not captured"
        }
    }
    
}
