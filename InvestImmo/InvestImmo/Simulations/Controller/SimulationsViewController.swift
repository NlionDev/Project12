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
    let rentaRepo = RentabilityRepository()
    let creditRepo = CreditRepository()
    
    
    //MARK: - Outlets

    @IBOutlet weak var simulationTableView: UITableView!
    @IBOutlet weak var choiceSegmentedControl: UISegmentedControl!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        setSimulationNavigationBarStyle()
        nibRegister()
        simulationTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSimulationResult" {
        guard let destination = segue.destination as? SimulationResultViewController else {return}
            if creditRepo.creditData["Durée"] == "" {
                creditRepo.creditData["Durée"] = "20"
            }
            if let rentaLastTextField = lastRentaCell.cellTextField,
                let creditLastTextField = lastCreditCell.cellTextField {
                rentaLastTextField.resignFirstResponder()
                creditLastTextField.resignFirstResponder()
            }
            rentaCalculator.rentabilityData = rentaRepo.rentabilityData
            creditCalculator.creditData = creditRepo.creditData
            destination.creditCalculator = creditCalculator
            destination.rentaCalculator = rentaCalculator
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
        }
        simulationTableView.reloadData()
    }
    
    @IBAction func didTapOnCalculButton(_ sender: Any) {
        performSegue(withIdentifier: "goToSimulationResult", sender: self)
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
