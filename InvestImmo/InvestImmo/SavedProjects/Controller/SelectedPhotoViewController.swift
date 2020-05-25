//
//  SelectedPhotoViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 13/05/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class SelectedPhotoViewController: UIViewController {

    //MARK: - Properties
    private var itemSpacing: CGFloat = 0
    private var isMenuBarDisplayed = false
    private var onceOnly = false
    private var currentIndex = Int()
    private let photoRepository = PhotoRepository()
    var project: Project?
    var photos: [Int: UIImage]?
    var initialIndexPath: IndexPath?
    var identifiers: [Int: String]?
    
    //MARK: - Outlets
    
    @IBOutlet weak var selectedPhotoCollectionView: UICollectionView!
    @IBOutlet weak var menuBar: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        setupMenuBar()
    }
    
    //MARK: - Actions
    
    @IBAction func didTapOnReturnButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnDeleteButton(_ sender: Any) {
        guard let identifiers = identifiers,
            let identifier = identifiers[currentIndex],
            let project = project,
            let name = project.name else {return}
        photoRepository.deletePhotoWithIdentifier(identifier: identifier, name: name)
        selectedPhotoCollectionView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SavedProjectsNotification.photoCollectionView.name), object: nil)
        dismiss(animated: true)
    }
    
    
    //MARK: - Methods
    private func nibRegister() {
        let nibName = UINib(nibName: SavedProjectsCell.photo.name, bundle: nil)
        selectedPhotoCollectionView.register(nibName, forCellWithReuseIdentifier: SavedProjectsCell.photo.reuseIdentifier)
    }

    private func setupMenuBar() {
        if isMenuBarDisplayed {
            menuBar.isHidden = false
            backButton.isHidden = false
        } else {
            menuBar.isHidden = true
            backButton.isHidden = true
        }
    }

}

//MARK: - Extension
extension SelectedPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photos = photos else {return 0}
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedProjectsCell.photo.reuseIdentifier,for: indexPath) as? PhotoCollectionViewCell,
            let photos = photos else {return UICollectionViewCell()}
        if photos.count != 0 {
            if let photo = photos[indexPath.row] {
                cell.configure(photo: photo)
            }
            cell.photoImageView.contentMode = .scaleAspectFit
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: selectedPhotoCollectionView.frame.width, height: selectedPhotoCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let initialIndexPath = initialIndexPath else {return}
        if !onceOnly {
            selectedPhotoCollectionView.scrollToItem(at: initialIndexPath, at: .centeredHorizontally, animated: false)
        }
        onceOnly = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isMenuBarDisplayed.toggle()
        setupMenuBar()
        currentIndex = indexPath.row
    }
    
}
