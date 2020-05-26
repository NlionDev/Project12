//
//  AddAdressToNewProjectVC.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 24/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for AddAdressToNewProjectVC
class AddAdressToNewProjectVC: UIViewController {
    
    //MARK: - Properties
    
    /// Instance of ErrorAlert
    private let errorAlert = ErrorAlert()
    
    /// Instance of ProjectRepository
    private let projectRepository = ProjectRepository()
    
    /// Instance of MapRepository
    private let mapRepository = MapRepository()
    
    /// Instance of Project
    private let project = Project()
    
    /// Instance of MapAdress
    private let mapAdress = MapAdress()
    
    /// Property for store adress past from viewcontroller who present the pop up
    var adress: String?
    
    /// Property for store latitude past from viewcontroller who present the pop up
    var latitude: String?
    
    /// Property for store longitude past from viewcontroller who present the pop up
    var longitude: String?
    
    //MARK: - Outlets
    @IBOutlet weak private var projectNameTextField: UITextField!
    
    //MARK: - Actions
    
    /// Action activated when tap on new project button for save map adress in new project
    @IBAction private func didTapOnCreatNewProjectButton(_ sender: Any) {
        guard let name = projectNameTextField.text else {return}
        if projectRepository.isMyProjectNameUnique(name: name) {
            save(name: name)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopUpNotification.dismissFisrtAlert.name), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PopUpNotification.configureMapView.name), object: nil)
            dismiss(animated: true)
        } else if projectNameTextField.text == nil {
            let alert = self.errorAlert.alert(message: PopUpAlertMessage.projectNameMissing.message)
            present(alert, animated: true)
        } else {
            let alert = errorAlert.alert(message: PopUpAlertMessage.projectAlreadyExist.message)
            present(alert, animated: true)
        }
    }
    
    /// Action activated when tap on cancel button for dismiss pop up
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    /// Action activated when tap on screen so that textfields resign first responder
    @IBAction private func didTapOnScreen(_ sender: UITapGestureRecognizer) {
        projectNameTextField.resignFirstResponder()
    }
    
    
    //MARK: - Methods

    /// Method for save map adress in new project
    private func save(name: String) {
        if let adress = adress,
            let latitude = latitude,
            let longitude = longitude {
            mapRepository.saveMapAdressWithNewProject(project: project, name: name, adress: adress, latitude: latitude, longitude: longitude)
        }
    }
}

//MARK: - Extension

/// Extension of AddAdressToNewProjectVC for tectfield delegate method
extension AddAdressToNewProjectVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        projectNameTextField.resignFirstResponder()
    }
}
