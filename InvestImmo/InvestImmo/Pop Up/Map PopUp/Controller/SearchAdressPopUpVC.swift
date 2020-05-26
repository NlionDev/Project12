//
//  SearchAdressVC.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 24/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Protocol for SearchAdressPopUpVCDelegate
protocol SearchAdressPopUpVCDelegate: class {
    func searchAdressPopUpVC(_ searchAdressPopUpVC: SearchAdressPopUpVC, adress: String)
}

/// Class for SearchAdressPopUpVC
class SearchAdressPopUpVC: UIViewController {
    
    //MARK: - Properties
    
    /// Instance of ErrorAlert
    private let errorAlert = ErrorAlert()
    
    /// Property for delegate
    weak var delegate: SearchAdressPopUpVCDelegate?
    
    //MARK: - Outlets
    @IBOutlet weak private var adressTextField: UITextField!
    @IBOutlet weak private var postalCodeTextField: UITextField!
    @IBOutlet weak private var cityTextField: UITextField!
    
    //MARK: - Actionn
    
    /// Action activated when tap on screen so that all textfields resign first responder
    @IBAction private func didTapOnScreen(_ sender: UITapGestureRecognizer) {
        adressTextField.resignFirstResponder()
        postalCodeTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
    }
    
    /// Action activated when tap on search adress button for check if nothing is missing and search the correct adress in map
    @IBAction private func didTapOnSearchAdress(_ sender: Any) {
        if adressTextField.text == nil {
            let alert = errorAlert.alert(message: PopUpAlertMessage.adressMissing.message)
            present(alert, animated: true)
        } else if postalCodeTextField.text == nil {
            let alert = errorAlert.alert(message: PopUpAlertMessage.postalCodeMissing.message)
            present(alert, animated: true)
        } else if cityTextField.text == nil {
            let alert = errorAlert.alert(message: PopUpAlertMessage.cityMissing.message)
            present(alert, animated: true)
        } else {
            if let adressText = adressTextField.text,
                let postalCodeText = postalCodeTextField.text,
                let cityText = cityTextField.text {
                 let adress = adressText + commaString + postalCodeText + commaString + cityText
                delegate?.searchAdressPopUpVC(self, adress: adress)
                dismiss(animated: true)
            }
        }
    }
    
    /// Action activated when tap on cancel button for dismiss pop up
    @IBAction private func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }

}

//MARK: - Extension

/// Extension of SearchAdressPopUpVC for textfield delegate method
extension SearchAdressPopUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
