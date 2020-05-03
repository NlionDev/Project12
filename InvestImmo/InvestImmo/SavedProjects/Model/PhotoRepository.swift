//
//  PhotoRepository.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 28/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

class PhotoRepository {
    
    
    //MARK: - Properties
    let realm = Realm.safeInit()
    lazy var myPhotos: Results<Photo> = {
        realm?.objects(Photo.self)}()!
    
    
    //MARK: - Methods
    func getPhotosIdentifiersWithProjectName(name: String) -> [String] {
        var identifiers = [String]()
        for photo in myPhotos {
            if photo.name == name {
                if let identifier = photo.identifier {
                    identifiers.append(identifier)
                }
            }
        }
        return identifiers
    }
    
}
