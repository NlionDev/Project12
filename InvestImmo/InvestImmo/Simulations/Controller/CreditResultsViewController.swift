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
    private let realmRepo = RealmRepository()
    private let creditNewProjectAlert = CreditNewProjectAlert()
    private let creditExistantProjectAlert = CreditExistantProjectAlert()
    var creditRepo: CreditRepository?
    
    //MARK: - Outlets
    @IBOutlet weak var creditResultsTableView: UITableView!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        creditResultsTableView.reloadData()
      
    }
    
    
    //MARK: - Actions
    @IBAction func didTapOnSaveButton(_ sender: Any) {
        guard let creditRepo = creditRepo else {return}
        let alert = realmRepo.myProjects.isEmpty ? creditNewProjectAlert.alert(credit: creditRepo) : creditExistantProjectAlert.alert(credit: creditRepo)
        present(alert, animated: true)
    }
    
    
    //MARK: - Methods
    private func nibRegister() {
        let nibName = UINib(nibName: "ResultTableViewCell", bundle: nil)
        creditResultsTableView.register(nibName, forCellReuseIdentifier: "ResultCell")
    }

}

//MARK: - Extension

extension CreditResultsViewController: UITableViewDataSource, UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell else {return UITableViewCell()}
        if let creditRepo = creditRepo {
            cell.configureForCredit(title: creditRepo.resultTitles[indexPath.row], result: creditRepo.results[indexPath.row])
        }
        return cell
    }
    
}
