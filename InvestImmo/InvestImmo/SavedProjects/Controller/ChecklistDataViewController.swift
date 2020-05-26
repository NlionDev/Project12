//
//  ChecklistDataViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 20/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Class for ChecklistDataViewController
class ChecklistDataViewController: UIViewController {
    
    
    //MARK: - Properties
    
    /// Two dimensionnal array for store saved checklist titles to display
    private var titles = [
        [String](),
        [String](),
        [String](),
        [String]()
    ]
    
    /// Two dimensionnal array for store saved checklist results to display
    private var results = [
        [String](),
        [String](),
        [String](),
        [String]()
    ]
    
    /// Instance of ChecklistRepository
    private var checklistRepository = ChecklistRepository()
    
    /// Instance of ChecklistGeneral
    private var checklistGeneral = ChecklistGeneral()
    
    /// Instance of ChecklistDistrict
    private var checklistDistrict = ChecklistDistrict()
    
    /// Instance of ChecklistApartmentBlock
    private var checklistApartmentBlock = ChecklistApartmentBlock()
    
    /// Instance of ChecklistApartment
    private var checklistApartment = ChecklistApartment()
    
    /// Property to store a selected Project past from SavedProjectsViewController
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
    
    /// Method for register nib cells
    private func nibRegister() {
        let nibNamForTextViewCell = UINib(nibName: SavedProjectsCell.textView.name, bundle: nil)
        checklistTableView.register(nibNamForTextViewCell, forCellReuseIdentifier: SavedProjectsCell.textView.reuseIdentifier)
        let nibNameForDetailsSimulationCell = UINib(nibName: SavedProjectsCell.simulation.name, bundle: nil)
        checklistTableView.register(nibNameForDetailsSimulationCell, forCellReuseIdentifier: SavedProjectsCell.simulation.reuseIdentifier)
    }
    
    /// Method for configure page and show or hide checklist table view and label
    private func configurePage() {
        if results[0].count == 0 {
            checklistTableView.isHidden = true
            checklistLabel.isHidden = false
        } else {
            checklistTableView.isHidden = false
            checklistLabel.isHidden = true
        }
    }
    
    /// Method for configure checklist tableview header
    private func setupTableViewHeader() -> UILabel {
        let sectionTitle = UILabel()
        sectionTitle.backgroundColor = purple
        sectionTitle.font = UIFont(name: antipastoFont, size: sectionTitleFontSize)
        sectionTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sectionTitle.textAlignment = .center
        return sectionTitle
    }
    
    /// Method for retrieve checklist titles
    private func getTitles() {
        titles = checklistRepository.allTitles
    }
    
    /// Method for retrieve saved result from specific checklist with project name
    private func getResults() {
        if let projectName = selectedProject?.name {
        checklistGeneral = checklistRepository.getChecklistGeneralWithProjectName(name: projectName)
            checklistDistrict = checklistRepository.getChecklistDistrictWithProjectName(name: projectName)
            checklistApartmentBlock = checklistRepository.getChecklistApartmentBlocklWithProjectName(name: projectName)
            checklistApartment = checklistRepository.getChecklistApartmentWithProjectName(name: projectName)
        results = checklistRepository.getSavedChecklistData(general: checklistGeneral, district: checklistDistrict, block: checklistApartmentBlock, apartment: checklistApartment)
        }
    }
    
    /// Method for configure tableview with correct cells
    private func configureTableView(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let item = checklistRepository.sections[indexPath.section][indexPath.row]
        var cell = UITableViewCell()
        switch item.cellType {
        case .textView:
            guard let cellTextView = tableView.dequeueReusableCell(withIdentifier: SavedProjectsCell.textView.reuseIdentifier, for: indexPath) as? SavedTextViewTableViewCell else {return UITableViewCell()}
            cellTextView.configure(title: titles[indexPath.section][indexPath.row], result: results[indexPath.section][indexPath.row])
            cell = cellTextView
        default:
            guard let defaultCell = tableView.dequeueReusableCell(withIdentifier: SavedProjectsCell.simulation.reuseIdentifier, for: indexPath) as? DetailsSimulationTableViewCell else {return UITableViewCell()}
            defaultCell.configure(title: titles[indexPath.section][indexPath.row], result: results[indexPath.section][indexPath.row])
            cell = defaultCell
        }
        return cell
    }
}

//MARK: - Extension

/// Extension of ChecklistDataViewController for tableView delegate and datasource methods
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
