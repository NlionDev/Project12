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

class SavedPhotosViewController: UIViewController {
    
    //MARK: - Properties
    private let itemSpacing: CGFloat = 1
    private var identifiers = [String]()
    private var miniPhotos = [UIImage]()
    private var fullSizePhotos = [Int: UIImage]()
    private let photoRepository = PhotoRepository()
    private var selectedPhotoIndexPath = IndexPath()
    private let optionKey = "creationDate"
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
            destination.photos = fullSizePhotos
            destination.initialIndexPath = selectedPhotoIndexPath
            destination.identifiers = identifiers
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
    private func nibRegister() {
        let nibName = UINib(nibName: SavedProjectsCell.photo.name, bundle: nil)
        galleryCollectionView.register(nibName, forCellWithReuseIdentifier: SavedProjectsCell.photo.reuseIdentifier)
    }
    
    private func getIdentifiers() {
        identifiers.removeAll()
        if let name = selectedProject?.name {
            identifiers = photoRepository.getPhotosIdentifiersWithProjectName(name: name)
        }
        configurePage()
    }
    
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
    
    private func getImages() {
        miniPhotos.removeAll()
        fullSizePhotos.removeAll()
        galleryCollectionView.isHidden = true
        activityIndicator.isHidden = false
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: optionKey, ascending: true)]
        let results: PHFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: self.identifiers, options: options)
        let manager = PHImageManager.default()
        results.enumerateObjects { (thisAsset, index, _) in
            print("l'index est \(index) dans enumerateObjects")
            manager.requestImage(for: thisAsset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: .none, resultHandler: {(thisImage, info)  in
                let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
                guard let image = thisImage else {return}
                if isDegraded {
                    print("l'index est \(index) dans miniPhoto")
                    self.miniPhotos.insert(image, at: index)
                } else {
                    print("l'index est \(index) dans fullsizephotos")
                    self.fullSizePhotos[index] = image
                    if self.fullSizePhotos.count == self.miniPhotos.count {
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
extension SavedPhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fullSizePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedProjectsCell.photo.reuseIdentifier,for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        if fullSizePhotos.count != 0 {
            if let photo = fullSizePhotos[indexPath.row] {
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
