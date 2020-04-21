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
    private let creditCalculator = CreditCalculator()
    private var lastCreditCell = TextFieldWithoutSubtitleTableViewCell()
    let creditRepo = CreditRepository()
    private let errorAlert = ErrorAlert()
    
    //MARK: - Outlets
    @IBOutlet weak var creditSimulationTableView: UITableView!
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        creditSimulationTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToCreditResults" {
            guard let destination = segue.destination as? CreditResultsViewController else {return}
            destination.creditRepo = creditRepo
        }
    }
    
    //MARK: - Actions
    
    @IBAction func didTapOnCalculButton(_ sender: Any) {
        if let creditLastTextField = lastCreditCell.cellTextField {
            creditLastTextField.resignFirstResponder()
            getCreditResults()
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        for cell in creditRepo.creditStepperCells {
            cell.cellTextField.resignFirstResponder()
        }
        for cell in creditRepo.creditTextFieldCells {
            cell.cellTextField.resignFirstResponder()
        }
    }
    
    //MARK: - Methods
    
    private func nibRegister() {
        let nibNameForCellWithoutSubtitle = UINib(nibName: "TextFieldWithoutSubtitleTableViewCell", bundle: nil)
        creditSimulationTableView.register(nibNameForCellWithoutSubtitle, forCellReuseIdentifier: "TextFieldWithoutSubtitleCell")
        let nibNameForPickerCell = UINib(nibName: "PickerViewTableViewCell", bundle: nil)
        creditSimulationTableView.register(nibNameForPickerCell, forCellReuseIdentifier: "PickerCell")
        let nibNameForStepperCell = UINib(nibName: "StepperTableViewCell", bundle: nil)
        creditSimulationTableView.register(nibNameForStepperCell, forCellReuseIdentifier: "StepperCell")
    }
    
    private func getCreditResults() {
        creditCalculator.creditData = creditRepo.creditData
        do {
            let mensuality = try creditCalculator.getStringMensuality() + " €"
            let interestCost = try creditCalculator.getStringInterestCost() + " €"
            let insuranceCost = try creditCalculator.getStringInsuranceCost() + " €"
            let totalCost = try creditCalculator.getTotalCost() + " €"
            creditRepo.results.append(mensuality)
            creditRepo.results.append(interestCost)
            creditRepo.results.append(insuranceCost)
            creditRepo.results.append(totalCost)
            performSegue(withIdentifier: "goToSimulationResult", sender: self)
        } catch let error as CreditCalculator.CreditCalculatorError {
            displayCreditError(error)
        } catch {
            let alert = errorAlert.alert(message: "Une erreur inconnue s'est produite")
            present(alert, animated: true)
        }
        
    }
    
    private func getCorrectCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let item = creditRepo.cells[indexPath.row]
        switch item.cellType {
        case .textField:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithoutSubtitleCell", for: indexPath) as? TextFieldWithoutSubtitleTableViewCell else {return UITableViewCell()}
            cell.configure(title: item.titles, unit: item.unit)
            cell.delegate = self
            lastCreditCell = cell
            creditRepo.creditTextFieldCells.append(cell)
            return cell
        case .pickerView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as? PickerViewTableViewCell else {return UITableViewCell()}
            cell.configure(title: item.titles, subtitle: item.subtitles)
            creditRepo.creditData["Durée"] = String(creditRepo.creditDuration[cell.selectedPickerData])
            cell.delegate = self
            return cell
        case .stepper:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StepperCell", for: indexPath) as? StepperTableViewCell else {return UITableViewCell()}
            cell.configure(title: item.titles)
            creditRepo.creditStepperCells.append(cell)
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

//MARK: - Extensions

extension CreditSimulationViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditRepo.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCorrectCell(tableView: tableView, indexPath: indexPath)
    }
}

extension CreditSimulationViewController: PickerViewTableViewCellDelegate {
    func pickerViewTableViewCell(_ pickerViewTableViewCell: PickerViewTableViewCell, key: String, value: Int) {
        let stringValue = String(value)
        creditRepo.creditData[key] = stringValue
    }
}

extension CreditSimulationViewController: TextFieldTableViewCellDelegate {
    func textFieldTableViewCell(key: String, value: String) {
        creditRepo.creditData[key] = value
    }
}
