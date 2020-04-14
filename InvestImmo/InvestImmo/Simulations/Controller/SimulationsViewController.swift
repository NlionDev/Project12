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
    
    private func getCorrectTextFieldWithoutSubtitleCell(tableView: UITableView, indexPath : IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithoutSubtitleCell", for: indexPath) as? TextFieldWithoutSubtitleTableViewCell else {return UITableViewCell()}
        if rentaRepo.titles[indexPath.row] == "Frais de gérance" {
            cell.configure(title: rentaRepo.titles[indexPath.row], unit: "%")
        } else {
            cell.configure(title: rentaRepo.titles[indexPath.row], unit: "€")
        }
        cell.delegate = self
        rentaRepo.rentaTextFieldWithoutSubtitleCells.append(cell)
        return cell
    }
    
    private func getTextFieldCellForCredit(tableView: UITableView, indexPath : IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithoutSubtitleCell", for: indexPath) as? TextFieldWithoutSubtitleTableViewCell else {return UITableViewCell()}
        cell.configure(title: creditRepo.titles[indexPath.row], unit: "€")
        cell.delegate = self
        lastCreditCell = cell
        creditRepo.creditTextFieldCells.append(cell)
        return cell
    }
    
    private func getTextFieldWithSubtitleCell(tableView: UITableView, indexPath : IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithSubtitleCell", for: indexPath) as? TextFieldWithSubtitleTableViewCell else {return UITableViewCell()}
        cell.configure(title: rentaRepo.titles[indexPath.row], subtitle: rentaRepo.subtitles[indexPath.row])
        cell.delegate = self
        lastRentaCell = cell
        rentaRepo.rentaTextFieldWithSubtitleCells.append(cell)
        return cell
    }
    
    private func getPickerCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let pickerCell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath) as? PickerViewTableViewCell else {return UITableViewCell()}
        pickerCell.configure(title: creditRepo.titles[indexPath.row], subtitle: creditRepo.subtitles[indexPath.row])
        pickerCell.delegate = self
        return pickerCell
    }
    
    private func getStepperCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let stepperCell = tableView.dequeueReusableCell(withIdentifier: "StepperCell", for: indexPath) as? StepperTableViewCell else {return UITableViewCell()}
        stepperCell.configure(title: creditRepo.titles[indexPath.row])
        stepperCell.delegate = self
        return stepperCell
    }
    
    private func getCorrectRentabilityCell(tableView: UITableView, indexPath : IndexPath) -> UITableViewCell {
        if rentaRepo.subtitles[indexPath.row] == "" {
            return getCorrectTextFieldWithoutSubtitleCell(tableView: tableView, indexPath: indexPath)
        } else {
            return getTextFieldWithSubtitleCell(tableView: tableView, indexPath: indexPath)
        }
    }
    
    private func getCorrectCreditCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if creditRepo.subtitles[indexPath.row] == "" {
            return getTextFieldCellForCredit(tableView: tableView, indexPath: indexPath)
        } else {
            var cell = UITableViewCell()
            if creditRepo.titles[indexPath.row] == "Durée" {
                cell = getPickerCell(tableView: tableView, indexPath: indexPath)
            } else {
                cell = getStepperCell(tableView: tableView, indexPath: indexPath)
            }
            return cell
        }
    }


}

//MARK: - Extension

extension SimulationsViewController: UITableViewDataSource, UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choiceSegmentedControl.selectedSegmentIndex == 0 ? creditRepo.titles.count : rentaRepo.titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return choiceSegmentedControl.selectedSegmentIndex == 0 ? getCorrectCreditCell(tableView: tableView, indexPath: indexPath) : getCorrectRentabilityCell(tableView: tableView, indexPath: indexPath)
        
    }
}

extension SimulationsViewController: TextFieldData, PickerData {
    func getTextFieldData(key: String, value: String) {
        rentaRepo.rentabilityData[key] = value
        creditRepo.creditData[key] = value
        
    }
    
    func getPickerData(key: String, value: Int) {
        let stringValue = String(value)
        creditRepo.creditData[key] = stringValue
    }
}
