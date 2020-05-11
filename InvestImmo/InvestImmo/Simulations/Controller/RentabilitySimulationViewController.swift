//
//  RentabilitySimulationViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 21/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class RentabilitySimulationViewController: UIViewController {
    
    
    //MARK: - Properties
    private let rentabilityCalculator = RentabilityCalculator()
    private var lastRentaCell = TextFieldWithSubtitleTableViewCell()
    private let errorAlert = ErrorAlert()
    let rentabilityRepository = RentabilityRepository()
    
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
        if segue.identifier == "GoToRentabilityResults" {
            guard let destination = segue.destination as? RentabilityResultsViewController else {return}
            destination.rentabilityCalculator = rentabilityCalculator
            destination.rentabilityRepository = rentabilityRepository
        }
    }

    deinit {
        removeKeyboardObserver()
    }
    
    //MARK: - Actions
    
    @IBAction private func didTapOnCalculButton(_ sender: Any) {
        if let rentaLastTextField = lastRentaCell.cellTextField {
            rentaLastTextField.resignFirstResponder()
            getRentabilityResults()
        }
    }
    
    @IBAction private func dismissKeyboard(_ sender: Any) {
        for cell in rentabilityRepository.rentaTextFieldWithoutSubtitleCells {
            cell.cellTextField.resignFirstResponder()
        }
        for cell in rentabilityRepository.rentaTextFieldWithSubtitleCells {
            cell.cellTextField.resignFirstResponder()
        }
    }
    
    //MARK: - Methods
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
    
    private func nibRegister() {
        let nibNameForCellWithSubtitle = UINib(nibName: "TextFieldWithSubtitleTableViewCell", bundle: nil)
        rentabilityTableView.register(nibNameForCellWithSubtitle, forCellReuseIdentifier: "TextFieldWithSubtitleCell")
        let nibNameForCellWithoutSubtitle = UINib(nibName: "TextFieldWithoutSubtitleTableViewCell", bundle: nil)
        rentabilityTableView.register(nibNameForCellWithoutSubtitle, forCellReuseIdentifier: "TextFieldWithoutSubtitleCell")
    }
    
    private func getRentabilityResults() {
        rentabilityCalculator.rentabilityData = rentabilityRepository.rentabilityData
        rentabilityRepository.results.removeAll()
        do {
            let grossYield = try rentabilityCalculator.getGrossYield()
            let netYield = try rentabilityCalculator.getNetYield()
            let annualCashflow = try rentabilityCalculator.getAnnualCashflow()
            let mensualCashflow = try rentabilityCalculator.getMensualCashflow()
            rentabilityRepository.results.append(grossYield + " %")
            rentabilityRepository.resultsForPositiveCheck.append(grossYield)
            rentabilityRepository.results.append(netYield + " %")
            rentabilityRepository.resultsForPositiveCheck.append(netYield)
            rentabilityRepository.results.append(annualCashflow + " €")
            rentabilityRepository.resultsForPositiveCheck.append(annualCashflow)
            rentabilityRepository.results.append(mensualCashflow + " €")
            rentabilityRepository.resultsForPositiveCheck.append(mensualCashflow)
            performSegue(withIdentifier: "GoToRentabilityResults", sender: self)
        } catch let error as RentabilityCalculator.RentabilityCalculatorError {
            displayRentabilityError(error)
        } catch {
            let alert = errorAlert.alert(message: "Une erreur inconnue s'est produite")
            present(alert, animated: true)
        }
    }
    
    private func getCorrectCell(tableView: UITableView, indexPath : IndexPath) -> UITableViewCell {
        let item = rentabilityRepository.cells[indexPath.row]
        switch item.cellType {
        case .textFieldWithoutSubtitles:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithoutSubtitleCell", for: indexPath) as? TextFieldWithoutSubtitleTableViewCell else {return UITableViewCell()}
            cell.configure(title: item.titles, unit: item.unit)
            cell.delegate = self
            rentabilityRepository.rentaTextFieldWithoutSubtitleCells.append(cell)
            return cell
        case .textFieldWithSubtitles:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithSubtitleCell", for: indexPath) as? TextFieldWithSubtitleTableViewCell else {return UITableViewCell()}
            cell.configure(title: item.titles, subtitle: item.subtitles)
            lastRentaCell = cell
            rentabilityRepository.rentaTextFieldWithSubtitleCells.append(cell)
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

}

//MARK: - Extension for TableView
extension RentabilitySimulationViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rentabilityRepository.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCorrectCell(tableView: tableView, indexPath: indexPath)
    }
}

//MARK: - TextFieldTableViewCellDelegate
extension RentabilitySimulationViewController: TextFieldTableViewCellDelegate {
    func textFieldTableViewCell(key: String, value: String) {
        rentabilityRepository.rentabilityData[key] = value
    }
}
