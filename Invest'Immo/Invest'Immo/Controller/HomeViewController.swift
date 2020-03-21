//
//  homeViewController.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 19/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }

}
