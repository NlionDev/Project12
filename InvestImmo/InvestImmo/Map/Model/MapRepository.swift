//
//  MapRepository.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 28/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

class MapRepository {
    
    
    //MARK: - Properties
    private var mapAdress = MapAdress()
    let realm = AppDelegate.realm
    lazy var myAdresses: Results<MapAdress> = {
        realm?.objects(MapAdress.self)}()!
    
    //MARK: - Methods
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
     
     func getMapAdressWithProjectName(name: String) -> MapAdress {
         var adressToReturn = MapAdress()
         for adress in myAdresses {
             if adress.name == name {
                 adressToReturn = adress
             }
         }
         return adressToReturn
     }
    
    func deleteProjectAdress(adressToDelete: Results<MapAdress>) {
        guard let realm = realm else {return}
        realm.safeWrite {
            realm.delete(adressToDelete)
        }
    }
}
