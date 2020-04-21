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
    private let rentaCalculator = RentabilityCalculator()
    private var lastRentaCell = TextFieldWithSubtitleTableViewCell()
    private let errorAlert = ErrorAlert()
    let rentaRepo = RentabilityRepository()
    
    //MARK: - Outlets
    @IBOutlet weak var rentabilityTableView: UITableView!
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        rentabilityTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToRentabilityResults" {
            guard let destination = segue.destination as? RentabilityResultsViewController else {return}
            destination.rentaCalculator = rentaCalculator
            destination.rentaRepo = rentaRepo
        }
    }

    //MARK: - Actions
    
    @IBAction func didTapOnCalculButton(_ sender: Any) {
        if let rentaLastTextField = lastRentaCell.cellTextField {
            rentaLastTextField.resignFirstResponder()
            getRentabilityResults()
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        for cell in rentaRepo.rentaTextFieldWithoutSubtitleCells {
            cell.cellTextField.resignFirstResponder()
        }
        for cell in rentaRepo.rentaTextFieldWithSubtitleCells {
            cell.cellTextField.resignFirstResponder()
        }
    }
    
    //MARK: - Methods
    
    private func nibRegister() {
        let nibNameForCellWithSubtitle = UINib(nibName: "TextFieldWithSubtitleTableViewCell", bundle: nil)
        rentabilityTableView.register(nibNameForCellWithSubtitle, forCellReuseIdentifier: "TextFieldWithSubtitleCell")
        let nibNameForCellWithoutSubtitle = UINib(nibName: "TextFieldWithoutSubtitleTableViewCell", bundle: nil)
        rentabilityTableView.register(nibNameForCellWithoutSubtitle, forCellReuseIdentifier: "TextFieldWithoutSubtitleCell")
    }
    
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
    
    private func getCorrectCell(tableView: UITableView, indexPath : IndexPath) -> UITableViewCell {
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

//MARK: - Extensions

extension RentabilitySimulationViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rentaRepo.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCorrectCell(tableView: tableView, indexPath: indexPath)
        
    }
}

extension RentabilitySimulationViewController: TextFieldTableViewCellDelegate {
    func textFieldTableViewCell(key: String, value: String) {
        rentaRepo.rentabilityData[key] = value
    }
}
