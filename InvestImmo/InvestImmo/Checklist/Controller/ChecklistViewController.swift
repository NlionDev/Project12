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
    lazy var myProjects: Results<Project> = {
    self.realm.objects(Project.self)}()
    private let existantProjectAlert = ExistantProjectAlert()
    private let newProjectAlert = NewProjectAlert()
    private var simulation = RentabilityRepository()
    private let checklistRepo = ChecklistRepository()
    private var lastCell = TextViewTableViewCell()
    private let checklistGeneral = ChecklistGeneral()
    
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
        if myProjects.isEmpty {
            let alertVC = newProjectAlert.alert(checklist: checklistRepo, simulation: simulation)
            present(alertVC, animated: true)
        } else {
            let alertVC = existantProjectAlert.alert(checklist: checklistRepo, simulation: simulation)
            present(alertVC, animated: true)
        }

    }
    
    //MARK: - Methods
    
    private func saveChecklistGeneralItems() {
        checklistGeneral.visitDate = checklistRepo.checklistData[0]["Date de la visite"]
        
    }
    
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
    
    private func configureTableView(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let item = checklistRepo.sections[indexPath.section][indexPath.row]
        switch item.cellType {
        case .datePicker:
            guard let dateCell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath) as? DatePickerTableViewCell else {return UITableViewCell()}
            dateCell.configure(title: item.titles, sectionKey: indexPath.section)
            checklistRepo.checklistData[indexPath.section][item.titles] = dateCell.cellDatePicker.date.transformIntoString
            dateCell.delegate = self
            return dateCell
        case .textView:
            guard let textViewCell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as? TextViewTableViewCell else {return UITableViewCell()}
            textViewCell.configure(title: item.titles, sectionKey: indexPath.section)
            textViewCell.delegate = self
            lastCell = textViewCell
            return textViewCell
        case .pickerView:
            guard let pickerCell = tableView.dequeueReusableCell(withIdentifier: "ChecklistPickerCell", for: indexPath) as? ChecklistPickerTableViewCell else {return UITableViewCell()}
            pickerCell.configure(title: item.titles, sectionKey: indexPath.section)
            pickerCell.delegate = self
            checklistRepo.checklistData[indexPath.section][item.titles] = pickerCell.pickerData[pickerCell.cellPicker.selectedRow(inComponent: 0)]
            return pickerCell
        case .textField:
            guard let textFieldCell = tableView.dequeueReusableCell(withIdentifier: "ChecklistTextFieldCell", for: indexPath) as? ChecklistTextFieldTableViewCell else {return UITableViewCell()}
            textFieldCell.configure(title: item.titles, unit: item.unit, sectionKey: indexPath.section)
            textFieldCell.delegate = self
            return textFieldCell
        case .segment:
            guard let segmentCell = tableView.dequeueReusableCell(withIdentifier: "SegmentCell", for: indexPath) as? SegmentTableViewCell else {return UITableViewCell()}
            segmentCell.configure(title: item.titles, sectionKey: indexPath.section)
            segmentCell.delegate = self
            checklistRepo.checklistData[indexPath.section][item.titles] = segmentCell.segmentValue
            return segmentCell
        }
    }
}

//MARK: - Extension

extension ChecklistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistRepo.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureTableView(tableView: tableView, indexPath: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return checklistRepo.sections.count
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

extension ChecklistViewController: TextViewTableViewCellDelegate {
    
    func textViewTableViewCell(_ textViewTableViewCell: TextViewTableViewCell, key: String, value: String, sectionKey: Int) {
        checklistRepo.checklistData[sectionKey][key] = value
    }
}

extension ChecklistViewController: ChecklistTextFieldTableViewCellDelegate {
    
    func checklistTextFieldTableViewCell(_ checklistTextFieldTableViewCell: ChecklistTextFieldTableViewCell, key: String, value: String, sectionKey: Int) {
        checklistRepo.checklistData[sectionKey][key] = value
    }
}

extension ChecklistViewController: ChecklistPickerTableViewCellDelegate {
    func checklistPickerTableViewCell(_ checklistPickerTableViewCell: ChecklistPickerTableViewCell, key: String, value: String, sectionKey: Int) {
        checklistRepo.checklistData[sectionKey][key] = value
    }
}

extension ChecklistViewController: DatePickerTableViewCellDelegate {
    func datePickerTableViewCell(_ datePickerTableViewCell: DatePickerTableViewCell, key: String, value: String, sectionKey: Int) {
        checklistRepo.checklistData[sectionKey][key] = value
    }
}

extension ChecklistViewController: SegmentTableViewCellDelegate {
    func segmentTableViewCell(_ segmentTableViewCell: SegmentTableViewCell, key: String, value: String, sectionKey: Int) {
        checklistRepo.checklistData[sectionKey][key] = value
    }
}
