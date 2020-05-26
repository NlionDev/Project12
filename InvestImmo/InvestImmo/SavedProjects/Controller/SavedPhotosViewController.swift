//
//  SavedPhotosViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 20/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

/// Class for SavedPhotosViewController
class SavedPhotosViewController: UIViewController {
    
    //MARK: - Properties
    
    /// Property for store collection view item spacing value
    private let itemSpacing: CGFloat = 1
    
    /// Array for store retrieved saved photo identifiers
    private var identifiers = [String]()
    
    /// Dictionary for store retrieved degraded photo with a specific key
    private var degradedPhotos = [Int: UIImage]()
    
    /// Dictionary for store retrieved high quality photo with a specific key
    private var photosDictionary = [Int: UIImage]()
    
    /// Dictionary for store retrieved photo identifiers with a specific key
    private var identifiersDictionary = [Int: String]()
    
    /// Instance of PhotoRepository
    private let photoRepository = PhotoRepository()
    
    /// Property for store selected photo indexpath
    private var selectedPhotoIndexPath = IndexPath()
    
    /// Property to store option key of PHFetchOptions
    private let optionKey = "creationDate"
    
    /// Property to store a selected Project past from SavedProjectsViewController
    var selectedProject: Project?

    //MARK: - Outlets
    @IBOutlet weak private var galleryCollectionView: UICollectionView!
    @IBOutlet weak private var noDataLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        getIdentifiers()
        getImages()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateChange), name: NSNotification.Name(rawValue: SavedProjectsNotification.photoCollectionView.name), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SavedProjectsNotification.photoCollectionView.name), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SavedProjectsSegue.photos.identifier {
            guard let destination = segue.destination as? SelectedPhotoViewController else {return}
            destination.project = selectedProject
            destination.photos = photosDictionary
            destination.initialIndexPath = selectedPhotoIndexPath
            destination.identifiers = identifiersDictionary
        }
    }
    
    //MARK: - Actions
    @objc private func updateChange() {
        getIdentifiers()
        getImages()
        configurePage()
        galleryCollectionView.reloadData()
    }
    
    //MARK: - Methods
    
    /// Method for register nib cells
    private func nibRegister() {
        let nibName = UINib(nibName: SavedProjectsCell.photo.name, bundle: nil)
        galleryCollectionView.register(nibName, forCellWithReuseIdentifier: SavedProjectsCell.photo.reuseIdentifier)
    }
    
    /// Method for retrieve saved identifiers with a specific project name
    private func getIdentifiers() {
        identifiers.removeAll()
        if let name = selectedProject?.name {
            identifiers = photoRepository.getPhotosIdentifiersWithProjectName(name: name)
        }
        configurePage()
    }
    
    /// Method for configure page and show or hide collectionview, label and activity indicator
    private func configurePage() {
        if identifiers.count != 0 {
            galleryCollectionView.isHidden = false
            noDataLabel.isHidden = true
            activityIndicator.isHidden = true
        } else {
            galleryCollectionView.isHidden = true
            noDataLabel.isHidden = false
            activityIndicator.isHidden = true
        }
        
    }
    
    /// Method for retrieve saved photos by using identifiers and store them in dictionaries
    private func getImages() {
        degradedPhotos.removeAll()
        photosDictionary.removeAll()
        var key = 0
        galleryCollectionView.isHidden = true
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: optionKey, ascending: true)]
        let results: PHFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: self.identifiers, options: options)
        let manager = PHImageManager.default()
        results.enumerateObjects { (thisAsset, index, _) in
            self.activityIndicator.isHidden = false
            manager.requestImage(for: thisAsset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: .none, resultHandler: {(thisImage, info)  in
                let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
                guard let image = thisImage else {return}
                if isDegraded {
                    self.degradedPhotos[index] = image
                } else {
                    self.photosDictionary[key] = image
                    self.identifiersDictionary[key] = thisAsset.localIdentifier
                    key += 1
                    if self.photosDictionary.count == self.degradedPhotos.count {
                        self.activityIndicator.isHidden = true
                        self.galleryCollectionView.isHidden = false
                        self.galleryCollectionView.reloadData()
                    }
                }
            })
        }
    }

}

//MARK: - Extension

/// Extension of SavedPhotosViewController for collectionView delegate and datasource methods
extension SavedPhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosDictionary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedProjectsCell.photo.reuseIdentifier,for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        if photosDictionary.count != 0 {
            if let photo = photosDictionary[indexPath.row] {
            cell.configure(photo: photo)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: galleryCollectionView.frame.width/3 - 1, height: galleryCollectionView.frame.width/3 - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPhotoIndexPath = indexPath
        performSegue(withIdentifier: SavedProjectsSegue.photos.identifier, sender: self)
    }
    
}
