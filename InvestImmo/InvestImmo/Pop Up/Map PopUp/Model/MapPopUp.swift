//
//  MapPopUp.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 24/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class MapNewProjectPopUp {
    
    func alert(adress: String, latitude: String, longitude: String) -> AddAdressToNewProjectVC {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.map.identifier, bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: MapVC.mapNewProject.identifier) as! AddAdressToNewProjectVC
        alertVC.adress = adress
        alertVC.latitude = latitude
        alertVC.longitude = longitude
        return alertVC
    }
}

class MapExistantProjectPopUp {
    
    func alert(adress: String, latitude: String, longitude: String) -> AddAdressToExistantProjectVC {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.map.identifier, bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: MapVC.mapExistantProject.identifier) as! AddAdressToExistantProjectVC
        alertVC.adress = adress
        alertVC.latitude = latitude
        alertVC.longitude = longitude
        return alertVC
    }
}

class MapSearchAdressPopUp {
    
    func alert(delegate: MapViewController) -> SearchAdressPopUpVC {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.map.identifier, bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: MapVC.mapSearchAdress.identifier) as! SearchAdressPopUpVC
        alertVC.delegate = delegate
        return alertVC
    }
}

class ReplaceProjectAdressPopUp {
    
    func alert(project: Project, adress: String, latitude: String, longitude: String) -> ReplaceAdressViewController {
        let storyboard = UIStoryboard(name: StoryboardIdentifier.map.identifier, bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: MapVC.mapReplaceProject.identifier) as! ReplaceAdressViewController
        alertVC.selectedProject = project
        alertVC.adress = adress
        alertVC.latitude = latitude
        alertVC.longitude = longitude
        return alertVC
    }
}
