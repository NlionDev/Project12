//
//  ChecklistViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

class ChecklistViewController: UIViewController {
    
    //MARK: - Properties
    
    let realm = try! Realm()
    private let checklistRepo = ChecklistRepository()
    private var lastCell = TextViewTableViewCell()
    private var checklist = Checklist()
    private var checklistGeneral = ChecklistGeneral()
    
    //MARK: - Enum
    
    enum CellType {
        case dateCell
        case textViewCell
        case textFieldCell
        case pickerCell
        case segmentCell
    }

    //MARK: - Outlets
    
    @IBOutlet weak var checklistTableView: UITableView!
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        checklistTableView.reloadData()
    }
    
    
    //MARK: - Actions
    
    @IBAction func didTapOnSaveButton(_ sender: Any) {
        if let lastTextView = lastCell.cellTextView {
            lastTextView.resignFirstResponder()
        }
        try! realm.write {
            for (key, value) in checklistRepo.checklistData[0] {
            checklistGeneral.key = key
            checklistGeneral.value = value
            realm.add(checklistGeneral)
        }
        checklist.name = "Studio Montpellier"
            checklist.checklistGeneral.append(checklistGeneral)
            realm.add(checklist)
        }
        
        
    }
    
    //MARK: - Methods
    
    private func nibRegister() {
        let nibNameForDatePickerCell = UINib(nibName: "DatePickerTableViewCell", bundle: nil)
        checklistTableView.register(nibNameForDatePickerCell, forCellReuseIdentifier: "DatePickerCell")
        let nibNameForChecklistPickerCell = UINib(nibName: "ChecklistPickerTableViewCell", bundle: nil)
        checklistTableView.register(nibNameForChecklistPickerCell, forCellReuseIdentifier: "ChecklistPickerCell")
        let nibNameSegmentCell = UINib(nibName: "SegmentTableViewCell", bundle: nil)
        checklistTableView.register(nibNameSegmentCell, forCellReuseIdentifier: "SegmentCell")
        let nibNameForTextFieldCell = UINib(nibName: "ChecklistTextFieldTableViewCell", bundle: nil)
        checklistTableView.register(nibNameForTextFieldCell, forCellReuseIdentifier: "ChecklistTextFieldCell")
        let nibNameForTextViewCell = UINib(nibName: "TextViewTableViewCell", bundle: nil)
               checklistTableView.register(nibNameForTextViewCell, forCellReuseIdentifier: "TextViewCell")
    }
    
    private func setupTableViewHeader() -> UILabel {
        
        let sectionTitle = UILabel()
        sectionTitle.backgroundColor = UIColor(red: 91/255.0, green: 102/255.0, blue: 248/255.0, alpha: 1.0)
        sectionTitle.font = UIFont(name: "AntipastoPro", size: 50)
        sectionTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sectionTitle.textAlignment = .center
        return sectionTitle
    }
    
    private func getDateCell(tableView: UITableView, indexPath: IndexPath, title: String) -> UITableViewCell {
        guard let dateCell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath) as? DatePickerTableViewCell else {return UITableViewCell()}
        dateCell.configure(title: title, sectionKey: indexPath.section)
        dateCell.delegate = self
        checklistRepo.checklistData[indexPath.section][title] = dateCell.cellDatePicker.date.transformIntoString
        return dateCell
    }
    
    private func getPickerCell(tableView: UITableView, indexPath: IndexPath, title: String) -> UITableViewCell {
        guard let pickerCell = tableView.dequeueReusableCell(withIdentifier: "ChecklistPickerCell", for: indexPath) as? ChecklistPickerTableViewCell else {return UITableViewCell()}
        pickerCell.configure(title: title, sectionKey: indexPath.section)
        pickerCell.delegate = self
        checklistRepo.checklistData[indexPath.section][title] = pickerCell.pickerData[pickerCell.cellPicker.selectedRow(inComponent: 0)]
        return pickerCell
    }
    
    private func getTextViewCell(tableView: UITableView, indexPath: IndexPath, title: String) -> UITableViewCell {
        guard let textViewCell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as? TextViewTableViewCell else {return UITableViewCell()}
        textViewCell.configure(title: title, sectionKey: indexPath.section)
        textViewCell.delegate = self
        lastCell = textViewCell
        return textViewCell
    }
    
    private func getTextFieldCell(tableView: UITableView, indexPath: IndexPath, title: String) -> UITableViewCell {
        guard let textFieldCell = tableView.dequeueReusableCell(withIdentifier: "ChecklistTextFieldCell", for: indexPath) as? ChecklistTextFieldTableViewCell else {return UITableViewCell()}
        if title == "Superficie" || title == "Surface cave" {
            textFieldCell.configure(title: title, unit: " m2", sectionKey: indexPath.section)
        } else if title == "Hauteur sous plafond" {
            textFieldCell.configure(title: title, unit: " cm", sectionKey: indexPath.section)
        } else {
            textFieldCell.configure(title: title, unit: "", sectionKey: indexPath.section)
        }
        textFieldCell.delegate = self
        return textFieldCell
    }
    
    private func getSegmentCell(tableView: UITableView, indexPath: IndexPath, title: String) -> UITableViewCell {
        guard let segmentCell = tableView.dequeueReusableCell(withIdentifier: "SegmentCell", for: indexPath) as? SegmentTableViewCell else {return UITableViewCell()}
        segmentCell.configure(title: title, sectionKey: indexPath.section)
        segmentCell.delegate = self
        checklistRepo.checklistData[indexPath.section][title] = segmentCell.segmentValue
        return segmentCell
    }
    
    private func getCorrectCell(tableView: UITableView, indexPath: IndexPath, cellType: CellType, title: String) -> UITableViewCell {
        switch cellType {
        case .dateCell:
            return getDateCell(tableView: tableView, indexPath: indexPath, title: title)
        case .pickerCell:
            return getPickerCell(tableView: tableView, indexPath: indexPath, title: title)
        case .textViewCell:
            return getTextViewCell(tableView: tableView, indexPath: indexPath, title: title)
        case .textFieldCell:
            return getTextFieldCell(tableView: tableView, indexPath: indexPath, title: title)
        case .segmentCell:
            return getSegmentCell(tableView: tableView, indexPath: indexPath, title: title)
        }
    }
    
    private func getId(tableView: UITableView, indexPath: IndexPath, title: String) -> Int {
        var goodId = Int()
        for (newTitle, id) in checklistRepo.checklistTwoDimensionnalDictionnary[indexPath.section] {
            if title == newTitle {
                goodId = id
            }
        }
        return goodId
    }
    
    private func configureTableView(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let title = checklistRepo.checklistTwoDimensionnalArray[indexPath.section][indexPath.row]
        let id = getId(tableView: tableView, indexPath: indexPath, title: title)
        if id == 1 {
            cell = getCorrectCell(tableView: tableView, indexPath: indexPath, cellType: .dateCell, title: title)
        } else if id == 2 {
            cell = getCorrectCell(tableView: tableView, indexPath: indexPath, cellType: .pickerCell, title: title)
        } else if id == 3 {
            cell = getCorrectCell(tableView: tableView, indexPath: indexPath, cellType: .textFieldCell, title: title)
        } else if id == 4 {
            cell = getCorrectCell(tableView: tableView, indexPath: indexPath, cellType: .textViewCell, title: title)
        } else if id == 5 {
            cell = getCorrectCell(tableView: tableView, indexPath: indexPath, cellType: .segmentCell, title: title)
        }
       return cell
    }
}

//MARK: - Extension

extension ChecklistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistRepo.checklistTwoDimensionnalArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return configureTableView(tableView: tableView, indexPath: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return checklistRepo.checklistTwoDimensionnalArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = setupTableViewHeader()
        if section == 0 {
            title.text = "Général"
        } else if section == 1 {
            title.text = "Quartier"
        } else if section == 2 {
            title.text = "Immeuble"
        } else if section == 3 {
            title.text = "Appartement"
        }
        return title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension ChecklistViewController: TextViewData, ChecklistTextFieldData, ChecklistPickerData, DatePickerData, SegmentData {
    func getTextViewData(key: String, value: String, sectionKey: Int) {
        checklistRepo.checklistData[sectionKey][key] = value
    }
    
    func getChecklistTextFieldData(key: String, value: String, sectionKey: Int) {
        checklistRepo.checklistData[sectionKey][key] = value
    }
    
    func getChecklistPickerData(key: String, value: String, sectionKey: Int) {
        checklistRepo.checklistData[sectionKey][key] = value
    }
    
    func getDatePickerData(key: String, value: String, sectionKey: Int) {
        checklistRepo.checklistData[sectionKey][key] = value
    }
    
    func getSegmentData(key: String, value: String, sectionKey: Int) {
        checklistRepo.checklistData[sectionKey][key] = value
    }

}
