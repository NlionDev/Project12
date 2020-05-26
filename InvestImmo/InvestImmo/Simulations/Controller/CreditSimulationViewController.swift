//
//  CreditSimulationViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 21/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// ViewController for make a Credit Simulation
class CreditSimulationViewController: UIViewController {
    
    //MARK: - Properties
    
    /// Instance of ErrorAlert for present error
    private let errorAlert = ErrorAlert()
    
    /// Instance of CreditCalculator for calculation
    private let creditCalculator = CreditCalculator()
    
    /// Insrance of CreditRepository
    private let creditRepository = CreditRepository()
    
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
        if segue.identifier == SimulationsSegue.credit.identifier {
            guard let destination = segue.destination as? CreditResultsViewController else {return}
            destination.creditRepository = creditRepository
        }
    }
    
    deinit {
        removeKeyboardObserver()
    }
    
    //MARK: - Actions
    
    /// Action activated when tap on calcul button for get credit simulation results
    @IBAction private func didTapOnCalculButton(_ sender: Any) {
        getCreditResults()
    }
    
    /// Action activated when tap on screen so that all textfield resign first responder
    @IBAction private func dismissKeyboard(_ sender: Any) {
        for cell in creditRepository.creditStepperCells {
            cell.cellTextField.resignFirstResponder()
        }
        for cell in creditRepository.creditTextFieldCells {
            cell.cellTextField.resignFirstResponder()
        }
    }
    
    //MARK: - Methods
    
    /// Method for keyboard management and move up textfield when editing
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
    
    /// Method for register credit simulation cells
    private func nibRegister() {
        let nibNameForCellWithoutSubtitle = UINib(nibName: SimulationsCells.textFieldWithoutSubtitle.name, bundle: nil)
        creditSimulationTableView.register(nibNameForCellWithoutSubtitle, forCellReuseIdentifier: SimulationsCells.textFieldWithoutSubtitle.reuseIdentifier)
        let nibNameForPickerCell = UINib(nibName: SimulationsCells.pickerView.name, bundle: nil)
        creditSimulationTableView.register(nibNameForPickerCell, forCellReuseIdentifier: SimulationsCells.pickerView.reuseIdentifier)
        let nibNameForStepperCell = UINib(nibName: SimulationsCells.stepper.name, bundle: nil)
        creditSimulationTableView.register(nibNameForStepperCell, forCellReuseIdentifier: SimulationsCells.stepper.reuseIdentifier)
    }
    
    /// Method for get credit simulation results
    private func getCreditResults() {
        creditCalculator.creditData = creditRepository.creditData
        creditRepository.results.removeAll()
        do {
            let mensuality = try creditCalculator.getStringMensuality() + eurosUnit
            let interestCost = try creditCalculator.getStringInterestCost() + eurosUnit
            let insuranceCost = try creditCalculator.getStringInsuranceCost() + eurosUnit
            let totalCost = try creditCalculator.getTotalCost() + eurosUnit
            creditRepository.results.append(mensuality)
            creditRepository.results.append(interestCost)
            creditRepository.results.append(insuranceCost)
            creditRepository.results.append(totalCost)
            performSegue(withIdentifier: SimulationsSegue.credit.identifier, sender: self)
        } catch let error as CreditCalculator.CreditCalculatorError {
            displayCreditError(error)
        } catch {
            displayCreditError(.unknowError)
        }
        
    }
    
    /// Method for instantiate, configure and return correct cell
    private func getCorrectCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let item = creditRepository.cells[indexPath.row]
        switch item.cellType {
        case .textField:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimulationsCells.textFieldWithoutSubtitle.reuseIdentifier, for: indexPath) as? TextFieldWithoutSubtitleTableViewCell else {return UITableViewCell()}
            cell.configure(title: item.titles, unit: item.unit)
            cell.delegate = self
            creditRepository.creditTextFieldCells.append(cell)
            return cell
        case .pickerView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimulationsCells.pickerView.reuseIdentifier, for: indexPath) as? PickerViewTableViewCell else {return UITableViewCell()}
            cell.configure(title: item.titles, subtitle: item.subtitles)
            creditRepository.creditData[CreditItem.duration.titles] = String(creditRepository.creditDuration[cell.selectedPickerData])
            cell.delegate = self
            return cell
        case .stepper:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimulationsCells.stepper.reuseIdentifier, for: indexPath) as? StepperTableViewCell else {return UITableViewCell()}
            cell.configure(title: item.titles)
            creditRepository.creditStepperCells.append(cell)
            cell.delegate = self
            return cell
        }
    }
    
    /// Method for display a specific error
    private func displayCreditError(_ error: CreditCalculator.CreditCalculatorError) {
        switch error {
        case .amountToFinanceMissing:
            let alert = errorAlert.alert(message: error.message)
            present(alert, animated: true)
        case .rateMissing:
            let alert = errorAlert.alert(message: error.message)
            present(alert, animated: true)
        case .unknowError:
            let alert = errorAlert.alert(message: error.message)
            present(alert, animated: true)
        }
    }

}

//MARK: - Extension for TableView

/// Extension of CreditSimulationViewController for TableView Delegate and DataSource
extension CreditSimulationViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditRepository.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCorrectCell(tableView: tableView, indexPath: indexPath)
    }
}

//MARK: - PickerViewTableViewCellDelegate

/// Extension of CreditSimulationViewController for implement PickerViewTableViewCellDelegate methods
extension CreditSimulationViewController: PickerViewTableViewCellDelegate {
    func pickerViewTableViewCell(_ pickerViewTableViewCell: PickerViewTableViewCell, key: String, value: Int) {
        let stringValue = String(value)
        creditRepository.creditData[key] = stringValue
    }
}

//MARK: - TextFieldTableViewCellDelegate

/// Extension of CreditSimulationViewController for implement TextFieldTableViewCellDelegate methods
extension CreditSimulationViewController: TextFieldTableViewCellDelegate {
    func textFieldTableViewCell(key: String, value: String) {
        creditRepository.creditData[key] = value
    }
}
