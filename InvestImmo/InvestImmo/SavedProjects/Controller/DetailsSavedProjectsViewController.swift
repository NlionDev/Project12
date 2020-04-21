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
    private var pageViewController: UIPageViewController!
    private var viewControllers = [UIViewController]()
    private var realmRepo = RealmRepository()
    private let creditRepo = CreditRepository()
    private let rentaRepo = RentabilityRepository()
    private var selectedRentabilitySimulation: RentabilitySimulation?
    private var selectedCreditSimulation: CreditSimulation?
    private var selectedChecklistGeneral: ChecklistGeneral?
    private var currentIndex = 0
    var selectedProject: Project?
    
    //MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var menuBar: UIView!
    @IBOutlet weak var menuBarCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedProject = selectedProject {
            guard let projectName = selectedProject.name else {return}
            nameLabel.text = selectedProject.name
            selectedCreditSimulation = realmRepo.getCreditSimulationWithProjectName(name: projectName)
        }
        self.navigationItem.rightBarButtonItem = nil
        setupMenuBarCollectionView()
        setupHorizontalBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        getViewControllers()
        if let vc = segue.destination as? UIPageViewController {
            pageViewController = vc
            pageViewController.dataSource = self
            pageViewController.delegate = self
            pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: true, completion: nil)
        }
    }

    
    //MARK: - Actions
    

    
    //MARK: - Methods
 
    private func getViewControllers() {
        let storyboard = UIStoryboard(name: "SavedProjectsDataStoryboard", bundle: nil)
        let creditDataVC = storyboard.instantiateViewController(withIdentifier: "CreditData") as! CreditDataViewController
        creditDataVC.selectedProject = selectedProject
        let rentabilityDataVC = storyboard.instantiateViewController(withIdentifier: "RentabilityData") as! RentabilityDataViewController
        rentabilityDataVC.selectedProject = selectedProject
        let checklistDataVC = storyboard.instantiateViewController(withIdentifier: "ChecklistData")
        let savedPhotosVC = storyboard.instantiateViewController(withIdentifier: "SavedPhotos")
        let mapVC = storyboard.instantiateViewController(withIdentifier: "Map")
        viewControllers.append(creditDataVC)
        viewControllers.append(rentabilityDataVC)
        viewControllers.append(checklistDataVC)
        viewControllers.append(savedPhotosVC)
        viewControllers.append(mapVC)
    }
    
    private func setupMenuBarCollectionView() {
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        menuBarCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: [])
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
        let nextVC = viewControllers[menuIndex]
        currentIndex < menuIndex ? pageViewController.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil) : pageViewController.setViewControllers([nextVC], direction: .reverse, animated: true, completion: nil)
        currentIndex = menuIndex
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
    
    private func animateMenuBarSlide(index: Int, duration: TimeInterval) {
        let x = CGFloat(index) * menuBar.frame.width / 5
        horizontalBarLeftAnchorConstraint?.constant = x
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {self.menuBar.layoutIfNeeded()}, completion: nil)
    }
}

//MARK: - Extension for CollectionView delegate and datasource

extension DetailsSavedProjectsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuBarItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        cell = getMenuBarCollectionViewCell(collectionView: collectionView, indexPath: indexPath)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: menuBar.frame.width / 5, height: menuBar.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        animateMenuBarSlide(index: indexPath.item, duration: 0.3)
        scrollToMenuIndex(menuIndex: Int(indexPath.item))
    }
}

//MARK: - Extension for PageViewController delegate and datasource

extension DetailsSavedProjectsViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else {return nil}
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {return nil}
        guard viewControllers.count > previousIndex else {return nil}
        return viewControllers[previousIndex]
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else {return nil}
        let nextIndex = viewControllerIndex + 1
        let viewControllersCount = viewControllers.count
        guard viewControllersCount != nextIndex else {return nil}
        guard viewControllersCount > nextIndex else {return nil}
        return viewControllers[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return viewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (completed && finished) {
            if let currentVC = pageViewController.viewControllers?.last {
                if let index = viewControllers.firstIndex(of: currentVC) {
                    currentIndex = index
                    let indexPath = IndexPath(item: index, section: 0)
                    menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                    animateMenuBarSlide(index: index, duration: 0)
                }
            }
        }
    }
}
