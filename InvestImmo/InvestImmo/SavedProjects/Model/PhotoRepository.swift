//
//  PhotoRepository.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 28/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

/// Class for PhotoRepository
class PhotoRepository {
    
    
    //MARK: - Properties
    
    /// Instance of Photo
    private var photo = Photo()
    
    /// Instance of Realm
    let realm = AppDelegate.realm
    
    /// Property for store saved photos
    lazy var myPhotos: Results<Photo> = {
        realm?.objects(Photo.self)}()!
    
    
    //MARK: - Methods
    
    /// Method for save photos
    func savePhoto(name: String, identifier: String) {
        guard let realm = realm else {return}
        realm.safeWrite {
            photo.name = name
            photo.identifier = identifier
            realm.add(photo)
        }
    }
    
    /// Method for retrieve photos identifiers with project name
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
    
    /// Method for delete Photo with identifier and name
    func deletePhotoWithIdentifier(identifier: String, name: String) {
        guard let realm = realm else {return}
        let photoToDelete = realm.objects(Photo.self).filter("identifier = '\(identifier)' AND name = '\(name)'")
        realm.safeWrite {
            realm.delete(photoToDelete)
        }
    }
    
    /// Method for check if a specific photo is unique
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
