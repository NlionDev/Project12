//
//  SavedChecklistsDetailsViewController.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 03/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class SavedChecklistsDetailsViewController: UIViewController {
    
    //MARK: - Properties
    
    var checklistGeneral: ChecklistGeneral?
    
    //MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var visitDateLabel: UILabel!
    @IBOutlet weak var estateTypeLabel: UILabel!
    @IBOutlet weak var surfaceAreaLabel: UILabel!
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePage()
    }
    

    //MARK: - Methods
    
    private func configurePage() {
        if let checklistGeneral = checklistGeneral {
            nameLabel.text = checklistGeneral.name
            visitDateLabel.text = checklistGeneral.visitDate
            estateTypeLabel.text = checklistGeneral.estateType
            guard let surfaceArea = checklistGeneral.surfaceArea else {return}
            surfaceAreaLabel.text = surfaceArea + " m2"
        }
        
    }

}
