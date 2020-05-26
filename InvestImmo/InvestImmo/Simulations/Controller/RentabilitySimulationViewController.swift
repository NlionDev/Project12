//
//  RentabilitySimulationViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 21/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// ViewController for make a rentability simulation
class RentabilitySimulationViewController: UIViewController {
    
    //MARK: - Properties
    
    /// Instance of RentabilityCalculator for calculation
    private let rentabilityCalculator = RentabilityCalculator()
    
    /// Instance of ErrorAlert for present error
    private let errorAlert = ErrorAlert()
    
    /// Instance of RentabilityRepository
    private let rentabilityRepository = RentabilityRepository()
    
    //MARK: - Outlets
    @IBOutlet weak private var rentabilityTableView: UITableView!
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        rentabilityTableView.reloadData()
        addKeyboardObservers(method: #selector(adjustViewForKeyboard(notification:)))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SimulationsSegue.rentability.identifier {
            guard let destination = segue.destination as? RentabilityResultsViewController else {return}
            destination.rentabilityCalculator = rentabilityCalculator
            destination.rentabilityRepository = rentabilityRepository
        }
    }

    deinit {
        removeKeyboardObserver()
    }
    
    //MARK: - Actions
    
    /// Action activated when tap on calculate button and get rentability simulation results
    @IBAction private func didTapOnCalculButton(_ sender: Any) {
        getRentabilityResults()
    }
    
    /// Action activated when tap on screen so that all textfield resign first responder
    @IBAction private func dismissKeyboard(_ sender: Any) {
        for cell in rentabilityRepository.rentaTextFieldWithoutSubtitleCells {
            cell.cellTextField.resignFirstResponder()
        }
        for cell in rentabilityRepository.rentaTextFieldWithSubtitleCells {
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
            rentabilityTableView.contentInset = .zero
        } else {
            if #available(iOS 11.0, *) {
                rentabilityTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            } else {
                let keyboardSize = keyboardViewEndFrame.size
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                rentabilityTableView.contentInset = contentInsets
                rentabilityTableView.scrollIndicatorInsets = contentInsets
            }
        }
        rentabilityTableView.scrollIndicatorInsets =  rentabilityTableView.contentInset
    }
    
    /// Method for register rentability simulation cell
    private func nibRegister() {
        let nibNameForCellWithSubtitle = UINib(nibName: SimulationsCells.textFieldWithSubtitle.name, bundle: nil)
        rentabilityTableView.register(nibNameForCellWithSubtitle, forCellReuseIdentifier: SimulationsCells.textFieldWithSubtitle.reuseIdentifier)
        let nibNameForCellWithoutSubtitle = UINib(nibName: SimulationsCells.textFieldWithoutSubtitle.name, bundle: nil)
        rentabilityTableView.register(nibNameForCellWithoutSubtitle, forCellReuseIdentifier: SimulationsCells.textFieldWithoutSubtitle.reuseIdentifier)
    }
    
    /// Method for get rentability simulation results
    private func getRentabilityResults() {
        rentabilityCalculator.rentabilityData = rentabilityRepository.rentabilityData
        rentabilityRepository.results.removeAll()
        do {
            let grossYield = try rentabilityCalculator.getGrossYield()
            let netYield = try rentabilityCalculator.getNetYield()
            let annualCashflow = try rentabilityCalculator.getAnnualCashflow()
            let mensualCashflow = try rentabilityCalculator.getMensualCashflow()
            rentabilityRepository.results.append(grossYield + percentUnit)
            rentabilityRepository.resultsForPositiveCheck.append(grossYield)
            rentabilityRepository.results.append(netYield + percentUnit)
            rentabilityRepository.resultsForPositiveCheck.append(netYield)
            rentabilityRepository.results.append(annualCashflow + eurosUnit)
            rentabilityRepository.resultsForPositiveCheck.append(annualCashflow)
            rentabilityRepository.results.append(mensualCashflow + eurosUnit)
            rentabilityRepository.resultsForPositiveCheck.append(mensualCashflow)
            performSegue(withIdentifier: SimulationsSegue.rentability.identifier, sender: self)
        } catch let error as RentabilityCalculator.RentabilityCalculatorError {
            displayRentabilityError(error)
        } catch {
            displayRentabilityError(.unknowError)
        }
    }
    
    /// Method for instantiate, configure and return correct cell
    private func getCorrectCell(tableView: UITableView, indexPath : IndexPath) -> UITableViewCell {
        let item = rentabilityRepository.cells[indexPath.row]
        switch item.cellType {
        case .textFieldWithoutSubtitles:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimulationsCells.textFieldWithoutSubtitle.reuseIdentifier, for: indexPath) as? TextFieldWithoutSubtitleTableViewCell else {return UITableViewCell()}
            cell.configure(title: item.titles, unit: item.unit)
            cell.delegate = self
            rentabilityRepository.rentaTextFieldWithoutSubtitleCells.append(cell)
            return cell
        case .textFieldWithSubtitles:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimulationsCells.textFieldWithSubtitle.reuseIdentifier, for: indexPath) as? TextFieldWithSubtitleTableViewCell else {return UITableViewCell()}
            cell.configure(title: item.titles, subtitle: item.subtitles)
            rentabilityRepository.rentaTextFieldWithSubtitleCells.append(cell)
            cell.delegate = self
            return cell
        }
    }
    
    /// Method for display a specific error
    private func displayRentabilityError(_ error: RentabilityCalculator.RentabilityCalculatorError) {
        switch error {
        case .estatePriceMissing:
            let alert = errorAlert.alert(message: error.message)
            present(alert, animated: true)
        case .monthlyRentMissing:
            let alert = errorAlert.alert(message: error.message)
            present(alert, animated: true)
        case .notaryFeesMissing:
           let alert = errorAlert.alert(message: error.message)
           present(alert, animated: true)
        case .propertyTaxMissing:
            let alert = errorAlert.alert(message: error.message)
            present(alert, animated: true)
        case .chargesMissing:
            let alert = errorAlert.alert(message: error.message)
            present(alert, animated: true)
        case .unknowError:
            let alert = errorAlert.alert(message: error.message)
            present(alert, animated: true)
        }
    }

}

//MARK: - Extension for TableView

/// Extension of RentabilitySimulationViewController for TableView Delegate and DataSource
extension RentabilitySimulationViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rentabilityRepository.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCorrectCell(tableView: tableView, indexPath: indexPath)
    }
}

//MARK: - TextFieldTableViewCellDelegate

/// Extension of RentabilitySimulationViewController for implement TextFieldTableViewCellDelegate methods
extension RentabilitySimulationViewController: TextFieldTableViewCellDelegate {
    func textFieldTableViewCell(key: String, value: String) {
        rentabilityRepository.rentabilityData[key] = value
    }
}
