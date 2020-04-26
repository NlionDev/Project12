//
//  MapPopUp.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 24/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class MapNewProjectAlert {
    
    func alert(adress: String, latitude: String, longitude: String) -> AddAdressToNewProjectVC {
        let storyboard = UIStoryboard(name: "MapPopUpStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "MapNewProjectAlertVC") as! AddAdressToNewProjectVC
        alertVC.adress = adress
        alertVC.latitude = latitude
        alertVC.longitude = longitude
        return alertVC
    }
}

class MapExistantProjectAlert {
    
    func alert(adress: String, latitude: String, longitude: String) -> AddAdressToExistantProjectVC {
        let storyboard = UIStoryboard(name: "MapPopUpStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "MapExistantProjectAlertVC") as! AddAdressToExistantProjectVC
        alertVC.adress = adress
        alertVC.latitude = latitude
        alertVC.longitude = longitude
        return alertVC
    }
}

class MapSearchAdressAlert {
    
    func alert(delegate: MapViewController) -> SearchAdressPopUpVC {
        let storyboard = UIStoryboard(name: "MapPopUpStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "SearchAdressVC") as! SearchAdressPopUpVC
        alertVC.delegate = delegate
        return alertVC
    }
}
