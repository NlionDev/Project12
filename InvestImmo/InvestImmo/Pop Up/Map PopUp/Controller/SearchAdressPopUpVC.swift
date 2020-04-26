//
//  SearchAdressVC.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 24/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

protocol SearchAdressPopUpVCDelegate: class {
    func searchAdressPopUpVC(_ searchAdressPopUpVC: SearchAdressPopUpVC, adress: String)
}

class SearchAdressPopUpVC: UIViewController {
    
    //MARK: - Properties
    private let errorAlert = ErrorAlert()
    weak var delegate: SearchAdressPopUpVCDelegate?
    
    //MARK: - Outlets
    
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    
    //MARK: - Actions

    @IBAction func didTapOnScreen(_ sender: UITapGestureRecognizer) {
        adressTextField.resignFirstResponder()
        postalCodeTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
    }
    
    @IBAction func didTapOnSearchAdress(_ sender: Any) {
        if adressTextField.text == nil {
            let alert = errorAlert.alert(message: "Vous n'avez pas rempli le champ 'Adresse'.")
            present(alert, animated: true)
        } else if postalCodeTextField.text == nil {
            let alert = errorAlert.alert(message: "Vous n'avez pas rempli le champ 'Code postal'.")
            present(alert, animated: true)
        } else if cityTextField.text == nil {
            let alert = errorAlert.alert(message: "Vous n'avez pas rempli le champ 'Ville'.")
            present(alert, animated: true)
        } else {
            if let adressText = adressTextField.text,
                let postalCodeText = postalCodeTextField.text,
                let cityText = cityTextField.text {
                 let adress = adressText + ", " + postalCodeText + ", " + cityText
                delegate?.searchAdressPopUpVC(self, adress: adress)
                dismiss(animated: true)
            }
        }
    }
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }

}

extension SearchAdressPopUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
