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
    private var identifiers = [String]()
    private var photosToDisplay = [UIImage]()
    private let photoRepository = PhotoRepository()
    var selectedProject: Project?

    //MARK: - Outlets
    @IBOutlet weak private var galleryCollectionView: UICollectionView!
    @IBOutlet weak private var noDataLabel: UILabel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        getIdentifiers()
        getImages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateChange), name: NSNotification.Name(rawValue: "ReloadPhotoCollectionView"), object: nil)
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
        let nibName = UINib(nibName: "PhotoCollectionViewCell", bundle: nil)
        galleryCollectionView.register(nibName, forCellWithReuseIdentifier: "PhotoCell")
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
        } else {
            galleryCollectionView.isHidden = true
            noDataLabel.isHidden = false
        }
    }
    
    private func getImages() {
        photosToDisplay.removeAll()
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let results: PHFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: self.identifiers, options: options)
        let manager = PHImageManager.default()
        results.enumerateObjects { (thisAsset, _, _) in
            manager.requestImage(for: thisAsset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: .none, resultHandler: {(thisImage, _) in
                    if let image = thisImage {
                        self.photosToDisplay.append(image)
                        
                    }
            })
            
        }
        
        self.galleryCollectionView.reloadData()
        
    }

}

//MARK: - Extension
extension SavedPhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photosToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell",for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        
        if photosToDisplay.count != 0 {
            //cell.backgroundColor = UIColor.clear
            cell.configure(photo: photosToDisplay[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3, height: view.frame.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
    }
    
}
