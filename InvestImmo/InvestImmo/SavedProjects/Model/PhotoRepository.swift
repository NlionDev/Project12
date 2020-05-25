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
    private var photo = Photo()
    let realm = AppDelegate.realm
    lazy var myPhotos: Results<Photo> = {
        realm?.objects(Photo.self)}()!
    
    
    //MARK: - Methods
    func savePhoto(name: String, identifier: String) {
        guard let realm = realm else {return}
        realm.safeWrite {
            photo.name = name
            photo.identifier = identifier
            realm.add(photo)
        }
    }
    
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
    
    func deletePhotoWithIdentifier(identifier: String, name: String) {
        guard let realm = realm else {return}
        let photoToDelete = realm.objects(Photo.self).filter("identifier = '\(identifier)' AND name = '\(name)'")
        realm.safeWrite {
            realm.delete(photoToDelete)
        }
    }
    
    func isUniquePhoto(name: String, identifier: String) -> Bool {
        var result = Bool()
        if let realm = realm {
            let photo = realm.objects(Photo.self).filter("name = '\(name)' AND identifier = '\(identifier)'")
            if photo.count == 0 {
                result = true
            } else {
                result = false
            }
        }
        return result
    }
}
