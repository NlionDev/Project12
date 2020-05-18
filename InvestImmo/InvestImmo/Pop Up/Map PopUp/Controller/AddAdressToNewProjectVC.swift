//
//  AddAdressToNewProjectVC.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 24/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class AddAdressToNewProjectVC: UIViewController {
    
    //MARK: - Properties
    private let errorAlert = ErrorAlert()
    private let projectRepository = ProjectRepository()
    private let mapRepository = MapRepository()
    private let project = Project()
    private let mapAdress = MapAdress()
    var adress: String?
    var latitude: String?
    var longitude: String?
    
    //MARK: - Outlets
    @IBOutlet weak private var projectNameTextField: UITextField!
    
    //MARK: - Actions
    @IBAction private func didTapOnCreatNewProjectButton(_ sender: Any) {
        guard let name = projectNameTextField.text else {return}
        if isMyProjectNameUnique(name: name, projects: projectRepository.myProjects) {
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
    
    @IBAction private func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapOnScreen(_ sender: UITapGestureRecognizer) {
        projectNameTextField.resignFirstResponder()
    }
    
    
    //MARK: - Methods
    
    @objc private func hideAlertController() {
        self.dismiss(animated: true)
    }

    private func save(name: String) {
        if let adress = adress,
            let latitude = latitude,
            let longitude = longitude {
            mapRepository.saveMapAdressWithNewProject(project: project, name: name, adress: adress, latitude: latitude, longitude: longitude)
        }
    }
}

//MARK: - Extension
extension AddAdressToNewProjectVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        projectNameTextField.resignFirstResponder()
    }
}
