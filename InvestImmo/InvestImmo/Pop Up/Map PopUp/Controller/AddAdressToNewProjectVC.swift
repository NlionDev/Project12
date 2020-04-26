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
    private let realmRepo = RealmRepository()
    private let project = Project()
    private let mapAdress = MapAdress()
    var adress: String?
    var latitude: String?
    var longitude: String?
    
    //MARK: - Outlets
    @IBOutlet weak var projectNameTextField: UITextField!
    
    
    //MARK: - Actions
    @IBAction func didTapOnCreatNewProjectButton(_ sender: Any) {
        guard let name = projectNameTextField.text else {return}
        if isMyProjectNameUnique(name: name, projects: realmRepo.myProjects) {
            save(name: name)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissFirstAlert"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConfigureMapView"), object: nil)
            dismiss(animated: true)
        } else if projectNameTextField.text == nil {
            let alert = self.errorAlert.alert(message: "Vous n'avez pas entré de nom pour ce projet.")
            present(alert, animated: true)
        } else {
            let alert = errorAlert.alert(message: "Un projet existant porte déjà ce nom.")
            present(alert, animated: true)
        }
    }
    
    @IBAction func didTapOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnScreen(_ sender: UITapGestureRecognizer) {
        projectNameTextField.resignFirstResponder()
    }
    
    
    //MARK: - Methods
    
    @objc private func hideAlertController() {
        self.dismiss(animated: true)
    }

    
    private func save(name: String) {
        project.name = name
        mapAdress.name = name
        mapAdress.adress = adress
        mapAdress.latitude = latitude
        mapAdress.longitude = longitude
        realmRepo.saveMapAdressWithNewProject(project: project, mapAdress: mapAdress)
    }
}

//MARK: - Extension

extension AddAdressToNewProjectVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        projectNameTextField.resignFirstResponder()
    }
}
