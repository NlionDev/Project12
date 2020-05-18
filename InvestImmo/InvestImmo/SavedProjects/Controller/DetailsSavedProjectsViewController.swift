//
//  DetailsChoiceViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 03/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

class DetailsSavedProjectsViewController: UIViewController {

    //MARK: - Properties
    private var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    private let menuBarItems = [UIImage(named: MenuBarItemsNames.euro.name), UIImage(named: MenuBarItemsNames.ratio.name), UIImage(named: MenuBarItemsNames.checklist.name), UIImage(named: MenuBarItemsNames.gallery.name), UIImage(named: MenuBarItemsNames.map.name)]
    private var pageViewController: UIPageViewController!
    private var viewControllers = [UIViewController]()
    private let errorAlert = ErrorAlert()
    private let photoRepository = PhotoRepository()
    private var currentIndex = 0
    private let imagePicker = UIImagePickerController()
    var selectedProject: Project?
    
    //MARK: - Outlets
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var menuBar: UIView!
    @IBOutlet weak private var menuBarCollectionView: UICollectionView!
    @IBOutlet weak private var containerView: UIView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let projectName = selectedProject?.name else {return}
        nameLabel.text = projectName
        imagePicker.delegate = self
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
    @objc private func didTapOnAddPhotoButton() {
        checkIfUserIsAllowToPickPhotoFromLibrary()
    }
    
    //MARK: - Methods
    private func getViewControllers() {
        let storyboard = UIStoryboard(name: savedProjectsStoryboardIdentifier, bundle: nil)
        let creditDataVC = storyboard.instantiateViewController(withIdentifier: SavedProjectsVC.credit.identifier) as! CreditDataViewController
        creditDataVC.selectedProject = selectedProject
        let rentabilityDataVC = storyboard.instantiateViewController(withIdentifier: SavedProjectsVC.rentability.identifier) as! RentabilityDataViewController
        rentabilityDataVC.selectedProject = selectedProject
        let checklistDataVC = storyboard.instantiateViewController(withIdentifier: SavedProjectsVC.checklist.identifier) as! ChecklistDataViewController
        checklistDataVC.selectedProject = selectedProject
        let savedPhotosVC = storyboard.instantiateViewController(withIdentifier: SavedProjectsVC.gallery.identifier) as! SavedPhotosViewController
        savedPhotosVC.selectedProject = selectedProject
        let mapVC = storyboard.instantiateViewController(withIdentifier: SavedProjectsVC.map.identifier) as! ProjectMapViewController
        mapVC.selectedProject = selectedProject
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
        configureNavBarRightButton()
    }
    
    private func getMenuBarCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        guard let menuBarCell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedProjectsCell.menuBar.reuseIdentifier, for: indexPath) as? MenuBarCollectionViewCell else {return UICollectionViewCell()}
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
    
    private func configureNavBarRightButton() {
        currentIndex == 3 ? setupNavBarRightButton(image: #imageLiteral(resourceName: "cameraIcon"), action: #selector(didTapOnAddPhotoButton)) : hideNavBarRightButton()
    }
    
    private func checkIfUserIsAllowToPickPhotoFromLibrary() {
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.denied || status == PHAuthorizationStatus.notDetermined) {
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.pickPhotoFromLibrary()
                } else {
                    let alert = self.errorAlert.alert(message: unauthorizeToPickPhotoMessageAlert)
                    self.present(alert, animated: true)
                }
            })
        } else if status == PHAuthorizationStatus.authorized {
            pickPhotoFromLibrary()
        }
    }
    
    private func pickPhotoFromLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
}
//MARK: - Extension for CollectionView
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

//MARK: - Extension for PageViewController
extension DetailsSavedProjectsViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
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
                currentIndex = index
                let indexPath = IndexPath(item: index, section: 0)
                menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                animateMenuBarSlide(index: index, duration: 0)
                configureNavBarRightButton()
            }
        }
    }
}

//MARK: - Extension for ImagePickerController
extension DetailsSavedProjectsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photo = Photo()
        if picker.sourceType == .photoLibrary {
            if let imageURL = info[.referenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                guard let asset = result.firstObject else {return}
                if let name = selectedProject?.name,
                    let realm = AppDelegate.realm {
                    realm.safeWrite {
                        photo.name = name
                        photo.identifier = asset.localIdentifier
                        realm.add(photo)
                    }
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SavedProjectsNotification.photoCollectionView.name), object: nil)
            self.dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
