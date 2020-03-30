//
//  homeViewController.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 19/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .lightContent
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setHomeNavigationBarStyle()
    }

    

}
