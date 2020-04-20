//
//  SimulationsViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 06/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

class SimulationsViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rentaCalculator = RentabilityCalculator()
    private let creditCalculator = CreditCalculator()
    private var lastCreditCell = TextFieldWithoutSubtitleTableViewCell()
    private var lastRentaCell = TextFieldWithSubtitleTableViewCell()
    private let errorAlert = ErrorAlert()
    let rentaRepo = RentabilityRepository()
    let creditRepo = CreditRepository()
    
    
    //MARK: - Outlets

    @IBOutlet weak var simulationTableView: UITableView!
    @IBOutlet weak var choiceSegmentedControl: UISegmentedControl!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        nibRegister()
        simulationTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSimulationResult" {
        guard let destination = segue.destination as? SimulationResultViewController else {return}
            destination.creditCalculator = creditCalculator
            destination.rentaCalculator = rentaCalculator
            destination.rentaRepo = rentaRepo
            destination.creditRepo = creditRepo
        }
    }
    
    //MARK: - Actions
    
    @IBAction func didChangeSegmentedControlValue(_ sender: Any) {
        if choiceSegmentedControl.selectedSegmentIndex == 0 {
            for cell in rentaRepo.rentaTextFieldWithoutSubtitleCells {
                cell.cellTextField.clear()
            }
            for cell in rentaRepo.rentaTextFieldWithSubtitleCells {
                cell.cellTextField.clear()
            }
        } else {
            for cell in creditRepo.creditTextFieldCells {
                cell.cellTextField.clear()
            }
            for cell in creditRepo.creditStepperCells {
                cell.cellTextField.clear()
            }
        }
        simulationTableView.reloadData()
    }
    
    @IBAction func didTapOnCalculButton(_ sender: Any) {
        if choiceSegmentedControl.selectedSegmentIndex == 0 {
            if let creditLastTextField = lastCreditCell.cellTextField {
                creditLastTextField.resignFirstResponder()
                getCreditResults()
            }
        } else {
            if let rentaLastTextField = lastRentaCell.cellTextField {
                rentaLastTextField.resignFirstResponder()
                getRentabilityResults()
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        if choiceSegmentedControl.selectedSegmentIndex == 1 {
            for cell in rentaRepo.rentaTextFieldWithoutSubtitleCells {
                cell.cellTextField.resignFirstResponder()
            }
            for cell in rentaRepo.rentaTextFieldWithSubtitleCells {
                cell.cellTextField.resignFirstResponder()
            }
        } else {
            for cell in creditRepo.creditStepperCells {
                cell.cellTextField.resignFirstResponder()
            }
            for cell in creditRepo.creditTextFieldCells {
                cell.cellTextField.resignFirstResponder()
            }
        }
    }
    
    //MARK: - Methods
    
    private func getRentabilityResults() {
        rentaCalculator.rentabilityData = rentaRepo.rentabilityData
        do {
            let grossYield = try rentaCalculator.getGrossYield()
            let netYield = try rentaCalculator.getNetYield()
            let annualCashflow = try rentaCalculator.getAnnualCashflow()
            let mensualCashflow = try rentaCalculator.getMensualCashflow()
            rentaRepo.results.append(grossYield + " %")
            rentaRepo.resultsForPositiveCheck.append(grossYield)
            rentaRepo.results.append(netYield + " %")
            rentaRepo.resultsForPositiveCheck.append(netYield)
            rentaRepo.results.append(annualCashflow + " €")
            rentaRepo.resultsForPositiveCheck.append(annualCashflow)
            rentaRepo.results.append(mensualCashflow + " €")
            rentaRepo.resultsForPositiveCheck.append(mensualCashflow)
            performSegue(withIdentifier: "goToSimulationResult", sender: self)
        } catch let error as RentabilityCalculator.RentabilityCalculatorError {
            displayRentabilityError(error)
        } catch {
            let alert = errorAlert.alert(message: "Une erreur inconnue s'est produite")
            present(alert, animated: true)
        }
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
    
    private func nibRegister() {
        let nibNameForCellWithSubtitle = UINib(nibName: "TextFieldWithSubtitleTableViewCell", bundle: nil)
        simulationTableView.register(nibNameForCellWithSubtitle, forCellReuseIdentifier: "TextFieldWithSubtitleCell")
        let nibNameForCellWithoutSubtitle = UINib(nibName: "TextFieldWithoutSubtitleTableViewCell", bundle: nil)
        simulationTableView.register(nibNameForCellWithoutSubtitle, forCellReuseIdentifier: "TextFieldWithoutSubtitleCell")
        let nibNameForPickerCell = UINib(nibName: "PickerViewTableViewCell", bundle: nil)
        simulationTableView.register(nibNameForPickerCell, forCellReuseIdentifier: "PickerCell")
        let nibNameForStepperCell = UINib(nibName: "StepperTableViewCell", bundle: nil)
        simulationTableView.register(nibNameForStepperCell, forCellReuseIdentifier: "StepperCell")
    }
    
    private func getCorrectCellForRentability(tableView: UITableView, indexPath : IndexPath) -> UITableViewCell {
        let item = rentaRepo.cells[indexPath.row]
        switch item.cellType {
        case .textFieldWithoutSubtitles:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithoutSubtitleCell", for: indexPath) as? TextFieldWithoutSubtitleTableViewCell else {return UITableViewCell()}
            cell.configure(title: item.titles, unit: item.unit)
            cell.delegate = self
            rentaRepo.rentaTextFieldWithoutSubtitleCells.append(cell)
            return cell
        case .textFieldWithSubtitles:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithSubtitleCell", for: indexPath) as? TextFieldWithSubtitleTableViewCell else {return UITableViewCell()}
            cell.configure(title: item.titles, subtitle: item.subtitles)
            lastRentaCell = cell
            rentaRepo.rentaTextFieldWithSubtitleCells.append(cell)
            cell.delegate = self
            return cell
        }
    }
    
    private func getCorrectCellForCredit(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
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
    
    private func displayRentabilityError(_ error: RentabilityCalculator.RentabilityCalculatorError) {
        switch error {
        case .estatePriceMissing:
            let alert = errorAlert.alert(message: "Le prix du bien n'est pas renseigné")
            present(alert, animated: true)
        case .monthlyRentMissing:
            let alert = errorAlert.alert(message: "Le loyer mensuel n'est pas renseigné")
            present(alert, animated: true)
        case .notaryFeesMissing:
           let alert = errorAlert.alert(message: "Les frais de notaire ne sont pas renseignés")
           present(alert, animated: true)
        case .propertyTaxMissing:
            let alert = errorAlert.alert(message: "La taxe foncière n'est pas renseignée")
            present(alert, animated: true)
        case .chargesMissing:
            let alert = errorAlert.alert(message: "Les charges de copropriété ne sont pas renseignées")
            present(alert, animated: true)
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

//MARK: - Extension

extension SimulationsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choiceSegmentedControl.selectedSegmentIndex == 0 ? creditRepo.cells.count : rentaRepo.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return choiceSegmentedControl.selectedSegmentIndex == 0 ? getCorrectCellForCredit(tableView: tableView, indexPath: indexPath) : getCorrectCellForRentability(tableView: tableView, indexPath: indexPath)
        
    }
}

extension SimulationsViewController: TextFieldTableViewCellDelegate {
    func textFieldTableViewCell(key: String, value: String) {
        rentaRepo.rentabilityData[key] = value
        creditRepo.creditData[key] = value
    }
}

extension SimulationsViewController: PickerViewTableViewCellDelegate {
    func pickerViewTableViewCell(_ pickerViewTableViewCell: PickerViewTableViewCell, key: String, value: Int) {
        let stringValue = String(value)
        creditRepo.creditData[key] = stringValue
    }
}
