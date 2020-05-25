//
//  CreditResultsViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 21/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class CreditResultsViewController: UIViewController {

    
    //MARK: - Properties
    private let projectRepository = ProjectRepository()
    private let creditNewProjectPopUp = CreditNewProjectPopUp()
    private let creditExistantProjectPopUp = CreditExistantProjectPopUp()
    var creditRepository: CreditRepository?
    
    //MARK: - Outlets
    @IBOutlet weak private var creditResultsTableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        creditResultsTableView.reloadData()
    }
    
    //MARK: - Actions
    @IBAction private func didTapOnSaveButton(_ sender: Any) {
        guard let creditRepository = creditRepository else {return}
        let alert = projectRepository.myProjects.isEmpty ? creditNewProjectPopUp.alert(credit: creditRepository) : creditExistantProjectPopUp.alert(credit: creditRepository)
        present(alert, animated: true)
    }
    
    
    //MARK: - Methods
    private func nibRegister() {
        let nibName = UINib(nibName: SimulationsCells.result.name, bundle: nil)
        creditResultsTableView.register(nibName, forCellReuseIdentifier: SimulationsCells.result.reuseIdentifier)
    }

}

//MARK: - Extension

extension CreditResultsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfTitles = Int()
        if let creditRepository = creditRepository {
            numberOfTitles = creditRepository.resultTitles.count
        }
       return numberOfTitles
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SimulationsCells.result.reuseIdentifier, for: indexPath) as? ResultTableViewCell else {return UITableViewCell()}
        if let creditRepository = creditRepository {
            cell.configureForCredit(title: creditRepository.resultTitles[indexPath.row], result: creditRepository.results[indexPath.row])
        }
        return cell
    }
    
}
