//
//  ChecklistViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

/// Class for checklist ViewController
class ChecklistViewController: UIViewController {
    
    //MARK: - Properties
    
    /// Instance of ProjectRepository
    private let projectRepository = ProjectRepository()
    
    /// Instance of ExistantProjectPopUp for present pop up and save checklist in an existant project
    private let existantProjectPopUp = ChecklistExistantProjectPopUp()
    
    /// Instance of newProjectPopUp for present pop up and save checklist in new project
    private let newProjectPopUp = ChecklistNewProjectPopUp()
    
    /// Instance of ChecklistRepository
    private let checklistRepository = ChecklistRepository()
    
    //MARK: - Outlets
    @IBOutlet weak var checklistTableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        checklistTableView.reloadData()
        addKeyboardObservers(method: #selector(adjustViewForKeyboard(notification:)))
    }
    
    deinit {
        removeKeyboardObserver()
    }
    
    //MARK: - Actions
    
    /// Action activated when tap on save button for save checklist in a new or an existant project
    @IBAction func didTapOnSaveButton(_ sender: Any) {
        if projectRepository.myProjects.isEmpty {
            let alertVC = newProjectPopUp.alert(checklist: checklistRepository)
            present(alertVC, animated: true)
        } else {
            let alertVC = existantProjectPopUp.alert(checklist: checklistRepository)
            present(alertVC, animated: true)
        }
    }
    
    /// Action activated when tap on screen so that all textfield and textview resign first responder
    @IBAction func dismissKeyboard(_ sender: Any) {
        for cell in checklistRepository.textFieldCells {
            cell.cellTextField.resignFirstResponder()
        }
        for cell in checklistRepository.textViewCells {
            cell.cellTextView.resignFirstResponder()
        }
    }
    
    //MARK: - Methods
    
    /// Method for keyboard management and move up textfield and textview when editing
    @objc private func adjustViewForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            checklistTableView.contentInset = .zero
        } else {
            if #available(iOS 11.0, *) {
                checklistTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            } else {
                let keyboardSize = keyboardViewEndFrame.size
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                checklistTableView.contentInset = contentInsets
                checklistTableView.scrollIndicatorInsets = contentInsets
            }
        }
        checklistTableView.scrollIndicatorInsets = checklistTableView.contentInset
    }
    
    /// Method for register checklist cells
    private func nibRegister() {
        let nibNameForDatePickerCell = UINib(nibName: ChecklistCellType.datePicker.name, bundle: nil)
        checklistTableView.register(nibNameForDatePickerCell, forCellReuseIdentifier: ChecklistCellType.datePicker.reuseIdentifier)
        let nibNameForChecklistPickerCell = UINib(nibName: ChecklistCellType.pickerView.name, bundle: nil)
        checklistTableView.register(nibNameForChecklistPickerCell, forCellReuseIdentifier: ChecklistCellType.pickerView.reuseIdentifier)
        let nibNameSegmentCell = UINib(nibName: ChecklistCellType.segment.name, bundle: nil)
        checklistTableView.register(nibNameSegmentCell, forCellReuseIdentifier: ChecklistCellType.segment.reuseIdentifier)
        let nibNameForTextFieldCell = UINib(nibName: ChecklistCellType.textField.name, bundle: nil)
        checklistTableView.register(nibNameForTextFieldCell, forCellReuseIdentifier: ChecklistCellType.textField.reuseIdentifier)
        let nibNameForTextViewCell = UINib(nibName: ChecklistCellType.textView.name, bundle: nil)
        checklistTableView.register(nibNameForTextViewCell, forCellReuseIdentifier: ChecklistCellType.textView.reuseIdentifier)
    }
    
    /// Method for configure tableView header
    private func setupTableViewHeader() -> UILabel {
        let sectionTitle = UILabel()
        sectionTitle.backgroundColor = purple
        sectionTitle.font = UIFont(name: antipastoFont, size: sectionTitleFontSize)
        sectionTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sectionTitle.textAlignment = .center
        return sectionTitle
    }
    
    /// Method for configure checklist table view with correct cells
    private func configureTableView(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let item = checklistRepository.sections[indexPath.section][indexPath.row]
        switch item.cellType {
        case .datePicker:
            guard let dateCell = tableView.dequeueReusableCell(withIdentifier: ChecklistCellType.datePicker.reuseIdentifier, for: indexPath) as? DatePickerTableViewCell else {return UITableViewCell()}
            dateCell.configure(title: item.titles, sectionKey: indexPath.section)
            checklistRepository.checklistData[indexPath.section][item.titles] = dateCell.cellDatePicker.date.transformIntoString
            dateCell.delegate = self
            return dateCell
        case .textView:
            guard let textViewCell = tableView.dequeueReusableCell(withIdentifier: ChecklistCellType.textView.reuseIdentifier, for: indexPath) as? TextViewTableViewCell else {return UITableViewCell()}
            textViewCell.configure(title: item.titles, sectionKey: indexPath.section)
            textViewCell.delegate = self
            textViewCell.cellTextView.clear()
            checklistRepository.textViewCells.append(textViewCell)
            return textViewCell
        case .pickerView:
            guard let pickerCell = tableView.dequeueReusableCell(withIdentifier: ChecklistCellType.pickerView.reuseIdentifier, for: indexPath) as? ChecklistPickerTableViewCell else {return UITableViewCell()}
            pickerCell.configure(title: item.titles, sectionKey: indexPath.section)
            pickerCell.delegate = self
            checklistRepository.checklistData[indexPath.section][item.titles] = pickerCell.pickerData[pickerCell.cellPicker.selectedRow(inComponent: 0)]
            return pickerCell
        case .textField:
            guard let textFieldCell = tableView.dequeueReusableCell(withIdentifier: ChecklistCellType.textField.reuseIdentifier, for: indexPath) as? ChecklistTextFieldTableViewCell else {return UITableViewCell()}
            textFieldCell.configure(title: item.titles, unit: item.unit, sectionKey: indexPath.section)
            textFieldCell.delegate = self
            textFieldCell.cellTextField.clear()
            checklistRepository.textFieldCells.append(textFieldCell)
            return textFieldCell
        case .segment:
            guard let segmentCell = tableView.dequeueReusableCell(withIdentifier: ChecklistCellType.segment.reuseIdentifier, for: indexPath) as? SegmentTableViewCell else {return UITableViewCell()}
            segmentCell.configure(title: item.titles, sectionKey: indexPath.section)
            segmentCell.delegate = self
            checklistRepository.checklistData[indexPath.section][item.titles] = segmentCell.segmentValue
            segmentCell.cellSegment.clear()
            return segmentCell
        }
    }
}

//MARK: - Extensions for TableView

/// Extension of ChecklistViewController for tableview delegate and datasource
extension ChecklistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistRepository.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureTableView(tableView: tableView, indexPath: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return checklistRepository.sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = setupTableViewHeader()
        if section == 0 {
            title.text = ChecklistSections.general.title
        } else if section == 1 {
            title.text = ChecklistSections.district.title
        } else if section == 2 {
            title.text = ChecklistSections.apartmentBlock.title
        } else if section == 3 {
            title.text = ChecklistSections.apartment.title
        }
        return title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
}

//MARK: - TextViewTableViewCellDelegate

/// Extension of ChecklistViewController for implement methods of TextViewTableViewCellDelegate
extension ChecklistViewController: TextViewTableViewCellDelegate {
    
    func textViewTableViewCell(_ textViewTableViewCell: TextViewTableViewCell, key: String, value: String, sectionKey: Int) {
        checklistRepository.checklistData[sectionKey][key] = value
    }
}

//MARK: - ChecklistTextFieldTableViewCellDelegate

/// Extension of ChecklistViewController for implement methods of ChecklistTextFieldTableViewCellDelegate
extension ChecklistViewController: ChecklistTextFieldTableViewCellDelegate {
    
    func checklistTextFieldTableViewCell(_ checklistTextFieldTableViewCell: ChecklistTextFieldTableViewCell, key: String, value: String, sectionKey: Int) {
        checklistRepository.checklistData[sectionKey][key] = value
    }
}

//MARK: - ChecklistPickerTableViewCellDelegate

/// Extension of ChecklistViewController for implement methods of ChecklistPickerTableViewCellDelegate
extension ChecklistViewController: ChecklistPickerTableViewCellDelegate {
    func checklistPickerTableViewCell(_ checklistPickerTableViewCell: ChecklistPickerTableViewCell, key: String, value: String, sectionKey: Int) {
        checklistRepository.checklistData[sectionKey][key] = value
    }
}

//MARK: - DatePickerTableViewCellDelegate

/// Extension of ChecklistViewController for implement methods of DatePickerTableViewCellDelegate
extension ChecklistViewController: DatePickerTableViewCellDelegate {
    func datePickerTableViewCell(_ datePickerTableViewCell: DatePickerTableViewCell, key: String, value: String, sectionKey: Int) {
        checklistRepository.checklistData[sectionKey][key] = value
    }
}

//MARK: - SegmentTableViewCellDelegate

/// Extension of ChecklistViewController for implement methods of SegmentTableViewCellDelegate
extension ChecklistViewController: SegmentTableViewCellDelegate {
    func segmentTableViewCell(_ segmentTableViewCell: SegmentTableViewCell, key: String, value: String, sectionKey: Int) {
        checklistRepository.checklistData[sectionKey][key] = value
    }
}
