//
//  MapRepository.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 28/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

/// Class for MapRepository
class MapRepository {
    
    
    //MARK: - Properties
    
    /// Instance of MapAdress
    private var mapAdress = MapAdress()
    
    /// Instance of Realm
    let realm = AppDelegate.realm
    
    /// Property to store saved map adress
    lazy var myAdresses: Results<MapAdress> = {
        realm?.objects(MapAdress.self)}()!
    
    //MARK: - Methods
    
    /// Method for save map adress in a new project
    func saveMapAdressWithNewProject(project: Project, name: String, adress: String, latitude: String, longitude: String) {
        guard let realm = realm else {return}
        project.name = name
        mapAdress.name = name
        mapAdress.adress = adress
        mapAdress.latitude = latitude
        mapAdress.longitude = longitude
         realm.safeWrite {
             realm.add(project)
             realm.add(mapAdress)
         }
     }
     
    /// Method for save map adress in an existant project
     func saveMapAdressInExistantProject(name: String, adress: String, latitude: String, longitude: String) {
        guard let realm = realm else {return}
         mapAdress.name = name
         mapAdress.adress = adress
         mapAdress.latitude = latitude
         mapAdress.longitude = longitude
         realm.safeWrite {
             realm.add(mapAdress)
         }
     }
     
    /// Method for retrieve map adress with a project name
     func getMapAdressWithProjectName(name: String) -> MapAdress {
         var adressToReturn = MapAdress()
         for adress in myAdresses {
             if adress.name == name {
                 adressToReturn = adress
             }
         }
         return adressToReturn
     }
    
    /// Method for delete a specific map adress 
    func deleteProjectAdress(adressToDelete: Results<MapAdress>) {
        guard let realm = realm else {return}
        realm.safeWrite {
            realm.delete(adressToDelete)
        }
    }
}
