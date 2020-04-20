//
//  DetailsChoiceViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 03/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class DetailsSavedProjectsViewController: UIViewController {

    //MARK: - Properties
   
    private var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    private let menuBarItems = [UIImage(named: "bankIcon"), UIImage(named: "ratioIcon"), UIImage(named: "checklistIcon"), UIImage(named: "galleryIcon"), UIImage(named: "mapIcon")]
    private var realmRepo = RealmRepository()
    private let creditRepo = CreditRepository()
    private let rentaRepo = RentabilityRepository()
    private var selectedRentabilitySimulation: RentabilitySimulation?
    private var selectedCreditSimulation: CreditSimulation?
    private var selectedChecklistGeneral: ChecklistGeneral?
    var selectedProject: Project?
    
    //MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var menuBar: UIView!
    @IBOutlet weak var menuBarCollectionView: UICollectionView!
    @IBOutlet weak var detailsItemCollectionView: UICollectionView!
    @IBOutlet weak var detailsView: UIView!
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedProject = selectedProject {
            guard let projectName = selectedProject.name else {return}
            nameLabel.text = selectedProject.name
            selectedCreditSimulation = realmRepo.getCreditSimulationWithProjectName(name: projectName)
        }
        setupMenuBarCollectionView()
        setupDetailsCollectionView()
        setupHorizontalBar()
        nibRegister()
    }
        

    
    //MARK: - Actions
    

    
    //MARK: - Methods
    
    private func nibRegister() {
        let nibNameForTableViewCollectionCell = UINib(nibName: "TableViewCollectionViewCell", bundle: nil)
        detailsItemCollectionView.register(nibNameForTableViewCollectionCell, forCellWithReuseIdentifier: "TableViewCollectionCell")
        let nibNameForNoDataCell = UINib(nibName: "NoDataCollectionViewCell", bundle: nil)
        detailsItemCollectionView.register(nibNameForNoDataCell, forCellWithReuseIdentifier: "NoDataCell")
        let nibNameForGalleryCell = UINib(nibName: "GalleryCollectionViewCell", bundle: nil)
        detailsItemCollectionView.register(nibNameForGalleryCell, forCellWithReuseIdentifier: "GalleryCell")
    }
    
    private func getCreditCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        guard let tableView = collectionView.dequeueReusableCell(withReuseIdentifier: "TableViewCollectionCell", for: indexPath) as? TableViewCollectionViewCell else {return UICollectionViewCell()}
        guard let noDataCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoDataCell", for: indexPath) as? NoDataCollectionViewCell else {return UICollectionViewCell()}
        if selectedCreditSimulation == nil {
            noDataCell.configure(message: "Aucune simulation de crédit n'est sauvegardé pour le moment.")
            cell = noDataCell
        } else {
            if let creditSimulation = selectedCreditSimulation {
                let results = realmRepo.getSavedCreditSimulationResultsData(simulation: creditSimulation)
                let titles = creditRepo.allTitles
                tableView.configure(titles: titles, results: results)
                cell = tableView
            }
        }
        return cell
    }
    
    private func getRentabilityCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        guard let tableView = collectionView.dequeueReusableCell(withReuseIdentifier: "TableViewCollectionCell", for: indexPath) as? TableViewCollectionViewCell else {return UICollectionViewCell()}
        guard let noDataCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoDataCell", for: indexPath) as? NoDataCollectionViewCell else {return UICollectionViewCell()}
        if selectedRentabilitySimulation == nil {
            
            noDataCell.configure(message: "Aucune simulation de rentabilité n'est sauvegardé pour le moment.")
            cell = noDataCell
            
        } else {
            if let rentaSimulation = selectedRentabilitySimulation {
                let results = realmRepo.getSavedRentabilitySimulationResultsData(simulation: rentaSimulation)
                let titles = rentaRepo.allTitles
                tableView.configure(titles: titles, results: results)
                cell = tableView
            }
        }
        return cell
    }
    
    private func setupMenuBarCollectionView() {
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        menuBarCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: [])
    }
    
    private func setupDetailsCollectionView() {
        detailsItemCollectionView.isPagingEnabled = true
    }
    
    private func setupHorizontalBar() {
        let horizontalBar = UIView()
        horizontalBar.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        horizontalBar.layer.cornerRadius = 1
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.addSubview(horizontalBar)
        horizontalBarLeftAnchorConstraint = horizontalBar.leftAnchor.constraint(equalTo: menuBar.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBar.bottomAnchor.constraint(equalTo: menuBar.bottomAnchor).isActive = true
        horizontalBar.widthAnchor.constraint(equalTo: menuBar.widthAnchor, multiplier:  1/5).isActive = true
        horizontalBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    private func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        detailsItemCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    private func getMenuBarCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        guard let menuBarCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuBarCell", for: indexPath) as? MenuBarCollectionViewCell else {return UICollectionViewCell()}
        if let item = menuBarItems[indexPath.row] {
            menuBarCell.configure(image: item)
            cell = menuBarCell
        }
        return cell
    }
}

//MARK: - Extension

extension DetailsSavedProjectsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuBarItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        guard let noDataCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoDataCell", for: indexPath) as? NoDataCollectionViewCell else {return UICollectionViewCell()}
        if collectionView == menuBarCollectionView {
            cell = getMenuBarCollectionViewCell(collectionView: collectionView, indexPath: indexPath)
        } else if collectionView == detailsItemCollectionView {
            if indexPath.item == 0 {
                cell = getCreditCell(collectionView: collectionView, indexPath: indexPath)
            } else if indexPath.item == 1 {
                
                cell = getRentabilityCell(collectionView: collectionView, indexPath: indexPath)
            } else if indexPath.item == 2 {
                
                noDataCell.configure(message: "Aucune check-list")
                cell = noDataCell
            } else if indexPath.item == 3 {
                noDataCell.configure(message: "Aucune photos")
                cell = noDataCell
            } else if indexPath.item == 4 {
                noDataCell.configure(message: "Aucune map")
                cell = noDataCell
            }
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        if collectionView == menuBarCollectionView {
            size = CGSize(width: menuBar.frame.width / 5, height: menuBar.frame.height)
        } else if collectionView == detailsItemCollectionView {
            size = CGSize(width: detailsView.frame.width, height: detailsView.frame.height)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollToMenuIndex(menuIndex: Int(indexPath.item))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 5
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / detailsView.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}
