//
//  SavedProjectsViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

class SavedProjectsViewController: UIViewController {

    //MARK: - Properties
    private let newProjectPopUp = EmptyNewProjectPopUp()
    private let projectRepository = ProjectRepository()
    private var selectedProject: Project?
    
    //MARK: - Outlets
    @IBOutlet weak private var noProjectSavedLabel: UILabel!
    @IBOutlet weak private var savedProjectsTableView: UITableView!
    @IBOutlet weak private var backgroundView: UIView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarRightButton(image: #imageLiteral(resourceName: "addIcon"), action: #selector(didTapOnNewProjectButton))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configurePage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToDetails" {
            hideNavBarBackItemTitle()
            guard let destination = segue.destination as? DetailsSavedProjectsViewController,
                let selectedProject = selectedProject else {return}
            destination.selectedProject = selectedProject
        }
    }
    
    //MARK: - Actions
    @objc private func didTapOnNewProjectButton() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.configurePage), name: NSNotification.Name(rawValue: "ReloadSavedProjectsData"), object: nil)
        let alert = newProjectPopUp.alert()
        present(alert, animated: true)
    }
    
    //MARK: - Methods
    private func showNoDataLabel() {
        if projectRepository.myProjects.isEmpty {
            savedProjectsTableView.isHidden = true
            noProjectSavedLabel.isHidden = false
        } else {
            noProjectSavedLabel.isHidden = true
            savedProjectsTableView.isHidden = false
        }
    }
    
    @objc private func configurePage() {
        savedProjectsTableView.reloadData()
        showNoDataLabel()
    }
    
}

//MARK: - Extension for TableView
extension SavedProjectsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectRepository.myProjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as? SavedProjectsTableViewCell else {
            
            return UITableViewCell()
        }
        if let projectName = projectRepository.myProjects[indexPath.row].name {
            cell.configure(projectName: projectName)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProject = projectRepository.myProjects[indexPath.row]
        performSegue(withIdentifier: "GoToDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let selectedProjectName = projectRepository.myProjects[indexPath.row].name,
                let realm = projectRepository.realm {
                let rentabilityToDelete = realm.objects(RentabilitySimulation.self).filter("name = '\(selectedProjectName)'")
                let creditToDelete = realm.objects(CreditSimulation.self).filter("name = '\(selectedProjectName)'")
                let checklistGeneralToDelete = realm.objects(ChecklistGeneral.self).filter("name = '\(selectedProjectName)'")
                let checklistDistrictToDelete = realm.objects(ChecklistDistrict.self).filter("name = '\(selectedProjectName)'")
                let checklistApartmentBlockToDelete = realm.objects(ChecklistApartmentBlock.self).filter("name = '\(selectedProjectName)'")
                let checklistApartmentToDelete = realm.objects(ChecklistApartment.self).filter("name = '\(selectedProjectName)'")
                let photoToDelete = realm.objects(Photo.self).filter("name = '\(selectedProjectName)'")
                let mapToDelete = realm.objects(MapAdress.self).filter("name = '\(selectedProjectName)'")
                let projectToDelete = realm.objects(Project.self).filter("name = '\(selectedProjectName)'")
                realm.safeWrite {
                    realm.delete(projectToDelete)
                    realm.delete(rentabilityToDelete)
                    realm.delete(checklistGeneralToDelete)
                    realm.delete(checklistDistrictToDelete)
                    realm.delete(checklistApartmentBlockToDelete)
                    realm.delete(checklistApartmentToDelete)
                    realm.delete(creditToDelete)
                    realm.delete(photoToDelete)
                    realm.delete(mapToDelete)
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
                showNoDataLabel()
            }
        }
    }
}

