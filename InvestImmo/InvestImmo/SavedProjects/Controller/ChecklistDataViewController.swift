//
//  ChecklistDataViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 20/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class ChecklistDataViewController: UIViewController {
    
    
    //MARK: - Properties
    private var titles = [
        [String](),
        [String](),
        [String](),
        [String]()
    ]
    private var results = [
        [String](),
        [String](),
        [String](),
        [String]()
    ]
    private var checklistRepository = ChecklistRepository()
    private var checklistGeneral = ChecklistGeneral()
    private var checklistDistrict = ChecklistDistrict()
    private var checklistApartmentBlock = ChecklistApartmentBlock()
    private var checklistApartment = ChecklistApartment()
    var selectedProject: Project?
    
    //MARK: - Outlets
    @IBOutlet weak private var checklistTableView: UITableView!
    @IBOutlet weak private var checklistLabel: UILabel!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        getTitles()
        getResults()
        configurePage()
    }
    

//MARK: - Methods
    private func nibRegister() {
        let nibNamForTextViewCell = UINib(nibName: "SavedTextViewTableViewCell", bundle: nil)
        checklistTableView.register(nibNamForTextViewCell, forCellReuseIdentifier: "SavedTextViewCell")
        let nibNameForDetailsSimulationCell = UINib(nibName: "DetailsSimulationTableViewCell", bundle: nil)
        checklistTableView.register(nibNameForDetailsSimulationCell, forCellReuseIdentifier: "DetailsSimulationCell")
    }
    
    private func configurePage() {
        if results[0].count == 0 {
            checklistTableView.isHidden = true
            checklistLabel.isHidden = false
        } else {
            checklistTableView.isHidden = false
            checklistLabel.isHidden = true
        }
    }
    
    private func setupTableViewHeader() -> UILabel {
        let sectionTitle = UILabel()
        sectionTitle.backgroundColor = UIColor(red: 91/255.0, green: 102/255.0, blue: 248/255.0, alpha: 1.0)
        sectionTitle.font = UIFont(name: "AntipastoPro", size: 50)
        sectionTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sectionTitle.textAlignment = .center
        return sectionTitle
    }
    
    private func getTitles() {
        titles = checklistRepository.allTitles
    }
    
    private func getResults() {
        if let projectName = selectedProject?.name {
        checklistGeneral = checklistRepository.getChecklistGeneralWithProjectName(name: projectName)
            checklistDistrict = checklistRepository.getChecklistDistrictWithProjectName(name: projectName)
            checklistApartmentBlock = checklistRepository.getChecklistApartmentBlocklWithProjectName(name: projectName)
            checklistApartment = checklistRepository.getChecklistApartmentWithProjectName(name: projectName)
        results = checklistRepository.getSavedChecklistData(general: checklistGeneral, district: checklistDistrict, block: checklistApartmentBlock, apartment: checklistApartment)
        }
    }
    
    private func configureTableView(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let item = checklistRepository.sections[indexPath.section][indexPath.row]
        var cell = UITableViewCell()
        switch item.cellType {
        case .textView:
            guard let cellTextView = tableView.dequeueReusableCell(withIdentifier: "SavedTextViewCell", for: indexPath) as? SavedTextViewTableViewCell else {return UITableViewCell()}
            cellTextView.configure(title: titles[indexPath.section][indexPath.row], result: results[indexPath.section][indexPath.row])
            cell = cellTextView
        default:
            guard let defaultCell = tableView.dequeueReusableCell(withIdentifier: "DetailsSimulationCell", for: indexPath) as? DetailsSimulationTableViewCell else {return UITableViewCell()}
            defaultCell.configure(title: titles[indexPath.section][indexPath.row], result: results[indexPath.section][indexPath.row])
            cell = defaultCell
        }
        return cell
    }
}

//MARK: - Extension
extension ChecklistDataViewController: UITableViewDataSource, UITableViewDelegate {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistRepository.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if results[0].count != 0 {
            return configureTableView(tableView: tableView, indexPath: indexPath)
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return checklistRepository.sections.count
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
