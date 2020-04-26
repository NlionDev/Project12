//
//  SavedPhotosViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 20/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import Photos

class SavedPhotosViewController: UIViewController {
    
    //MARK: - Properties
    private var identifiers = [String]()
    private var photosToDisplay = [UIImageView]()
    private let realmRepo = RealmRepository()
    var selectedProject: Project?

    //MARK: - Outlets
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        getIdentifiers()
        getImages()
        NotificationCenter.default.addObserver(self, selector: #selector(self.modifyLabel), name: NSNotification.Name(rawValue: "ReloadPhotoCollectionView"), object: nil)
    }
    

    //MARK: - Actions
    
    @objc private func modifyLabel() {
        galleryCollectionView.reloadData()
    }
    
    
    //MARK: - Methods
    
    private func nibRegister() {
        let nibName = UINib(nibName: "PhotoCollectionViewCell", bundle: nil)
        galleryCollectionView.register(nibName, forCellWithReuseIdentifier: "PhotoCell")
    }
    
    private func getIdentifiers() {
        if let name = selectedProject?.name {
            identifiers = realmRepo.getPhotosIdentifiersWithProjectName(name: name)
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
        
        let results = PHAsset.fetchAssets(withLocalIdentifiers: self.identifiers, options: nil)
        let manager = PHImageManager.default()
        
        results.enumerateObjects { (thisAsset, _, _) in
            
            manager.requestImage(for: thisAsset, targetSize: CGSize(width: 80.0, height: 80.0), contentMode: .aspectFit, options: nil, resultHandler: {(thisImage, _) in
                
                self.photosToDisplay.append(UIImageView(image: thisImage))
                
            })
        }
        self.galleryCollectionView.reloadData()
    }

}

//MARK: - Extension

extension SavedPhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell",for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        if photosToDisplay.count != 0 {
            cell.backgroundColor = UIColor.clear
            cell.configure(photo: photosToDisplay[indexPath.row])
        }
        return cell
    }
    
}
