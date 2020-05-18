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
    @IBOutlet weak private var adressTextField: UITextField!
    @IBOutlet weak private var postalCodeTextField: UITextField!
    @IBOutlet weak private var cityTextField: UITextField!
    
    //MARK: - Actionn
    @IBAction private func didTapOnScreen(_ sender: UITapGestureRecognizer) {
        adressTextField.resignFirstResponder()
        postalCodeTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
    }
    
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
    
    @IBAction private func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }

}

extension SearchAdressPopUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
