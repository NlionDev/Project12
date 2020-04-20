//
//  TableViewCollectionViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 19/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class TableViewCollectionViewCell: UICollectionViewCell {

    //MARK: - Properties
    
    private var cellTitles = [String]()
    private var cellResults = [String]()

    //MARK: - Outlets
    
    @IBOutlet weak var detailsTableView: UITableView!
    
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        nibRegister()
    }
    
    //MARK: - Methods
    
    private func nibRegister() {
        let nibNameForDetailsSimulationCell = UINib(nibName: "DetailsSimulationTableViewCell", bundle: nil)
        detailsTableView.register(nibNameForDetailsSimulationCell, forCellReuseIdentifier: "DetailsSimulationCell")
    }
    
    func configure(titles: [String], results: [String]) {
        cellTitles = titles
        cellResults = results
    }
    
    
    
}

//MARK: - Extension

extension TableViewCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = detailsTableView.dequeueReusableCell(withIdentifier: "DetailsSimulationCell", for: indexPath) as? DetailsSimulationTableViewCell else {return UITableViewCell()}
        cell.configure(title: cellTitles[indexPath.row], result: cellResults[indexPath.row])
        return cell
    }
    
}
