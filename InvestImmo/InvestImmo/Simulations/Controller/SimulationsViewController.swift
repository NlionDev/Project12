//
//  SimulationsViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 06/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift

/// ViewController who contain the PageViewController
class SimulationsViewController: UIViewController {
    
    //MARK: - Properties
    
    /// Left anchor constraint of horizontal bar in menu bar
    private var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    ///Titles display in Menu bar
    private let menuBarItems = [MenuBarItems.credit.titles, MenuBarItems.rentability.titles]
    
    /// The PageViewController
    private var pageViewController: UIPageViewController!
    
    /// Array of ViewControllers contained in PageViewController
    private var viewControllers = [UIViewController]()

    
    //MARK: - Outlets
    @IBOutlet weak private var menuBar: UIView!
    @IBOutlet weak private var menuBarCollectionView: UICollectionView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    //MARK: - Methods

    /// Method for instanciate ViewControllers contained in PageViewController and append them in 'viewControllers' property
    private func getViewControllers() {
        let storyboard = UIStoryboard(name: SimulationsStoryboard.storyboard.identifiers, bundle: nil)
        let creditVC = storyboard.instantiateViewController(withIdentifier: SimulationsStoryboard.creditVC.identifiers) as! CreditSimulationViewController
        let rentabilityVC = storyboard.instantiateViewController(withIdentifier: SimulationsStoryboard.rentabilityVC.identifiers) as! RentabilitySimulationViewController
        viewControllers.append(creditVC)
        viewControllers.append(rentabilityVC)
    }
    
    /// Method for configure menu bar and select first item
    private func setupMenuBarCollectionView() {
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        menuBarCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: [])
    }

    /// Method for configure horizontal bar in menu bar
    private func setupHorizontalBar() {
        let horizontalBar = UIView()
        horizontalBar.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        horizontalBar.layer.cornerRadius = 1
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.addSubview(horizontalBar)
        horizontalBarLeftAnchorConstraint = horizontalBar.leftAnchor.constraint(equalTo: menuBar.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBar.bottomAnchor.constraint(equalTo: menuBar.bottomAnchor).isActive = true
        horizontalBar.widthAnchor.constraint(equalTo: menuBar.widthAnchor, multiplier:  1/2).isActive = true
        horizontalBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    /// Method for instanciate, configure and return MenuBar cell
    private func getMenuBarCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        guard let menuBarCell = collectionView.dequeueReusableCell(withReuseIdentifier: SimulationsCells.menuBar.reuseIdentifier, for: indexPath) as? MenuBarSimulationCollectionViewCell else {return UICollectionViewCell()}
        let item = menuBarItems[indexPath.row]
        menuBarCell.configure(title: item)
        cell = menuBarCell
        return cell
    }
    
    /// Method for scroll PageViewController to a selected index
    private func scrollToMenuIndex(menuIndex: Int) {
        let nextVC = viewControllers[menuIndex]
        menuIndex == 0 ? pageViewController.setViewControllers([nextVC], direction: .reverse, animated: true, completion: nil) : pageViewController.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
    }
    
    /// Method for animate horizontal bar in Menu bar
    private func animateMenuBarSlide(index: Int, duration: TimeInterval) {
         let x = CGFloat(index) * menuBar.frame.width / 2
         horizontalBarLeftAnchorConstraint?.constant = x
         UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {self.menuBar.layoutIfNeeded()}, completion: nil)
     }

}

//MARK: - Extension for CollectionView

/// Extension of SimulationsViewController for CollectionView Delegate and DataSource
extension SimulationsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuBarItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        cell = getMenuBarCollectionViewCell(collectionView: collectionView, indexPath: indexPath)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: menuBar.frame.width / 2, height: menuBar.frame.height)
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

//MARK: - Extension for PageViewController 

/// Extension of SimulationsViewController for PageViewController Delegate and DataSource
extension SimulationsViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else {return nil}
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0,
            viewControllers.count > previousIndex else {return nil}
        return viewControllers[previousIndex]
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else {return nil}
        let nextIndex = viewControllerIndex + 1
        let viewControllersCount = viewControllers.count
        guard viewControllersCount != nextIndex,
            viewControllersCount > nextIndex else {return nil}
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
            if let currentVC = pageViewController.viewControllers?.last,
                let index = viewControllers.firstIndex(of: currentVC) {
                let indexPath = IndexPath(item: index, section: 0)
                self.menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                self.animateMenuBarSlide(index: index, duration: 0)
            }
        }
    }
}

