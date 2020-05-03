//
//  CreditSimulationViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 21/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class CreditSimulationViewController: UIViewController {
    
    //MARK: - Properties
    private let errorAlert = ErrorAlert()
    private let creditCalculator = CreditCalculator()
    private var lastCreditCell = TextFieldWithoutSubtitleTableViewCell()
    private var activeTextField: UITextField?
    let creditRepository = CreditRepository()
    
    //MARK: - Outlets
    @IBOutlet weak private var creditSimulationTableView: UITableView!
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        creditSimulationTableView.reloadData()
        addKeyboardObservers(method: #selector(adjustViewForKeyboard(notification:)))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToCreditResults" {
            guard let destination = segue.destination as? CreditResultsViewController else {return}
            destination.creditRepository = creditRepository
        }
    }
    
    deinit {
        removeKeyboardObserver()
    }
    
    //MARK: - Actions
    
    @IBAction private func didTapOnCalculButton(_ sender: Any) {
        if let creditLastTextField = lastCreditCell.cellTextField {
            creditLastTextField.resignFirstResponder()
            getCreditResults()
        }
    }
    
    @IBAction private func dismissKeyboard(_ sender: Any) {
        for cell in creditRepository.creditStepperCells {
            cell.cellTextField.resignFirstResponder()
        }
        for cell in creditRepository.creditTextFieldCells {
            cell.cellTextField.resignFirstResponder()
        }
    }
    
    //MARK: - Methods
    @objc private func adjustViewForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            creditSimulationTableView.contentInset = .zero
        } else {
            if #available(iOS 11.0, *) {
                creditSimulationTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            } else {
                let keyboardSize = keyboardScreenEndFrame.size
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                creditSimulationTableView.contentInset = contentInsets
                creditSimulationTableView.scrollIndicatorInsets = contentInsets
            }
        }
        creditSimulationTableView.scrollIndicatorInsets = creditSimulationTableView.contentInset
    }
    
    private func nibRegister() {
        let nibNameForCellWithoutSubtitle = UINib(nibName: "TextFieldWithoutSubtitleTableViewCell", bundle: nil)
        creditSimulationTableView.register(nibNameForCellWithoutSubtitle, forCellReuseIdentifier: "TextFieldWithoutSubtitleCell")
        let nibNameForPickerCell = UINib(nibName: "PickerViewTableViewCell", bundle: nil)
        creditSimulationTableView.register(nibNameForPickerCell, forCellReuseIdentifier: "PickerCell")
        let nibNameForStepperCell = UINib(nibName: "StepperTableViewCell", bundle: nil)
        creditSimulationTableView.register(nibNameForStepperCell, forCellReuseIdentifier: "StepperCell")
    }
    
    private func getCreditResults() {
        creditCalculator.creditData = creditRepository.creditData
        do {
            let mensuality = try creditCalculator.getStringMensuality() + " €"
            let interestCost = try creditCalculator.getStringInterestCost() + " €"
            let insuranceCost = try creditCalculator.getStringInsuranceCost() + " €"
            let totalCost = try creditCalculator.getTotalCost() + " €"
            creditRepository.results.append(mensuality)
            creditRepository.results.append(interestCost)
            creditRepository.results.append(insuranceCost)
            creditRepository.results.append(totalCost)
            performSegue(withIdentifier: "GoToCreditResults", sender: self)
        } catch let error as CreditCalculator.CreditCalculatorError {
            displayCreditError(error)
        } catch {
            let alert = errorAlert.alert(message: "Une erreur inconnue s'est produite")
            present(alert, animated: true)
        }
        
    }
    
    private func getCorrectCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let item = creditRepository.cells[indexPath.row]
        switch item.cellType {
        case .textField:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithoutSubtitleCell", for: indexPath) as? TextFieldWithoutSubtitleTableViewCell else {return UITableViewCell()}
            cell.configure(title: item.titles, unit: item.unit)
            cell.delegate = self
            lastCreditCell = cell
            creditRepository.creditTextFieldCells.append(cell)
            return cell
        case .pickerView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as? PickerViewTableViewCell else {return UITableViewCell()}
            cell.configure(title: item.titles, subtitle: item.subtitles)
            creditRepository.creditData["Durée"] = String(creditRepository.creditDuration[cell.selectedPickerData])
            cell.delegate = self
            return cell
        case .stepper:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StepperCell", for: indexPath) as? StepperTableViewCell else {return UITableViewCell()}
            cell.configure(title: item.titles)
            creditRepository.creditStepperCells.append(cell)
            cell.delegate = self
            return cell
        }
    }
    
    private func displayCreditError(_ error: CreditCalculator.CreditCalculatorError) {
        switch error {
        case .amountToFinanceMissing:
            let alert = errorAlert.alert(message: "Le montant à financer n'est pas renseigné")
            present(alert, animated: true)
        case .rateMissing:
            let alert = errorAlert.alert(message: "Le taux n'est pas renseigné")
            present(alert, animated: true)
        }
    }

}

//MARK: - Extension for TableView
extension CreditSimulationViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditRepository.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCorrectCell(tableView: tableView, indexPath: indexPath)
    }
}

//MARK: - PickerViewTableViewCellDelegate
extension CreditSimulationViewController: PickerViewTableViewCellDelegate {
    func pickerViewTableViewCell(_ pickerViewTableViewCell: PickerViewTableViewCell, key: String, value: Int) {
        let stringValue = String(value)
        creditRepository.creditData[key] = stringValue
    }
}

//MARK: - TextFieldTableViewCellDelegate
extension CreditSimulationViewController: TextFieldTableViewCellDelegate {
    func textFieldTableViewCell(key: String, value: String) {
        creditRepository.creditData[key] = value
    }
}
