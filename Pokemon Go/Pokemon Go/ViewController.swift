//
//  ViewController.swift
//  Pokemon Go
//
//  Created by Rethink on 17/03/22.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var map: MKMapView!
    let localManager = CLLocationManager()
    var cont = 0
    var coreDataPokemon: PokemonCoreData!
    var pokemons: [Pokemon] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        localManager.delegate = self
        localManager.requestWhenInUseAuthorization()
        localManager.startUpdatingLocation()
        
        
        // Recupera os pokemons
        self.coreDataPokemon = PokemonCoreData()
        self.pokemons = self.coreDataPokemon.recoverPokemons()
        
        // mostra os pokemons como uma note
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [self] (timer) in
            //print("NOTE")
            
            if let coordinate = self.localManager.location?.coordinate{
                
                let pokemonCount = self.pokemons.count
                let indiceRandom = arc4random_uniform(UInt32(pokemonCount))
                let pokemonRandom = self.pokemons[Int(indiceRandom)]
                
                // print(pokemonRandom.name)
                let note = AnnotationPokemon(coordinate: coordinate,pokemon: pokemonRandom)

                
                let randomLat = (Double( arc4random_uniform(200) ) - 100.0) /  50000.0
                let randomLong = (Double( arc4random_uniform(200) ) - 100.0) / 50000.0

                
                
                note.coordinate.latitude += randomLat
                note.coordinate.longitude += randomLong
                
                
                
                self.map.addAnnotation(note)
            }
                
           
            
            
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let noteView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
       
        
        
        if annotation is MKUserLocation{
            noteView.image = UIImage(named: "pokemon-trainer")
        }else{
            let pokemon = (annotation as! AnnotationPokemon).pokemon
            
            noteView.image = UIImage(named: pokemon.imageName!)
                
        }
        
        var frame = noteView.frame
        frame.size.height = 50
        frame.size.width = 50
        
        noteView.frame = frame
        
        
        return noteView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let annotation = view.annotation
        let pokemon = (view.annotation as! AnnotationPokemon).pokemon
        mapView.deselectAnnotation(annotation, animated: true)
       
        
        if annotation is MKUserLocation{
            return
            
        }else if  let coordNote = annotation?.coordinate{
            
            
            let region = MKCoordinateRegion.init(center: coordNote, latitudinalMeters: 300, longitudinalMeters: 300)
            map.setRegion(region, animated: true)
        
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coordinates = self.localManager.location?.coordinate{
                
                let coordPoint = MKMapPoint(coordinates)
                
                if self.map.visibleMapRect.contains(coordPoint){
                    self.coreDataPokemon.savePokemons(pokemon: pokemon)
                    self.map.removeAnnotation(annotation!)
                    
                    let alertController = UIAlertController(title: "Parabéns treinador!!!", message: "Você capturou o pokémon: \(String(describing: pokemon.name!))", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok!", style: .default, handler: nil)
                    
                    alertController.addAction(ok)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                else{

                
                    let alertController = UIAlertController(title: "Sinto muito treinador!!!", message: "Você NÃO pode capturar o \(String(describing: pokemon.name!)) ele está muito distânte", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok!", style: .default, handler: nil)
                    
                    alertController.addAction(ok)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
        }
        
        
        
        
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if cont < 5 {
            
            centralizePlayer()
            cont += 1
        }
        else{
            localManager.stopUpdatingLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus

              if status != .authorizedWhenInUse && status != .authorizedAlways && status != .notDetermined{
                  let alertController = UIAlertController(title: "Pemissao para Localizacao",
                                                          message: "Para Capturar Pokemons é necessário a permissao para acesso â localizacao", preferredStyle: .alert)

                  
                  let actionCancell = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
                  let actionSettings = UIAlertAction(title: "Abrir Configuracoes", style: .default) { (actionSettings) in
                      if let acessSettings = NSURL(string: UIApplication.openSettingsURLString){
                          UIApplication.shared.open(acessSettings as URL)
                      }
                  }
                  alertController.addAction(actionSettings)
                  alertController.addAction(actionCancell)
                  present(alertController, animated: true, completion: nil)
              }
    }
    
    func centralizePlayer(){
        if let coordinates = localManager.location?.coordinate{
            
            let region = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: 300, longitudinalMeters: 300)
            map.setRegion(region, animated: true)
            
        }else{
            print("Nao há coordenadas")
        }
    }
    //BOTAO DE CENTRALIZAR
    @IBAction func centralCompass(_ sender: Any) {
       centralizePlayer()
    }
    @IBAction func pokedeskOpen(_ sender: Any) {
        
    }
}

