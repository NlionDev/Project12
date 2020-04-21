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
    
    private let newProjectAlert = EmptyNewProjectAlert()
    private let realmRepo = RealmRepository()
    private var selectedProject: Project?
    private var selectedSimulation: RentabilitySimulation?
    private var selectedChecklistGeneral: ChecklistGeneral?
    
    //MARK: - Outlets
    
    
    @IBOutlet weak var noProjectSavedLabel: UILabel!
    @IBOutlet weak var savedProjectsTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewProjectButton(action: #selector(didTapOnNewProjectButton))
        configureBackgroundImageForTableView(tableView: savedProjectsTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configurePage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToDetails" {
            guard let destination = segue.destination as? DetailsSavedProjectsViewController,
                let selectedProject = selectedProject else {return}
            destination.selectedProject = selectedProject
        }
    }
    
    //MARK: - Actions
    
    @objc private func didTapOnNewProjectButton() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.configurePage), name: NSNotification.Name(rawValue: "ReloadSavedProjectsData"), object: nil)
        let alert = newProjectAlert.alert()
        present(alert, animated: true)
    }
    
    //MARK: - Methods
    
    private func showNoDataLabel() {
        if realmRepo.myProjects.isEmpty {
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

//MARK: - Extensions

extension SavedProjectsViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmRepo.myProjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as? SavedProjectsTableViewCell else {
            
            return UITableViewCell()
        }
        if let projectName = realmRepo.myProjects[indexPath.row].name {
            cell.configure(projectName: projectName)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProject = realmRepo.myProjects[indexPath.row]
        performSegue(withIdentifier: "GoToDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let selectedProjectName = realmRepo.myProjects[indexPath.row].name {
                let simulationToDelete = realmRepo.realm.objects(RentabilitySimulation.self).filter("name = '\(selectedProjectName)'")
                let checklistGeneralToDelete = realmRepo.realm.objects(ChecklistGeneral.self).filter("name = '\(selectedProjectName)'")
                let projectToDelete = realmRepo.realm.objects(Project.self).filter("name = '\(selectedProjectName)'")
                try! realmRepo.realm.write {
                    realmRepo.realm.delete(projectToDelete)
                    realmRepo.realm.delete(simulationToDelete)
                    realmRepo.realm.delete(checklistGeneralToDelete)
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
                showNoDataLabel()
            }
        }
    }
}

