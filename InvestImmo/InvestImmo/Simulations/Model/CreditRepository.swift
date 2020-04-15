//
//  CreditRepository.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 06/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class CreditRepository {
    
    //MARK: - Properties
    
    let cells: CreditCells = [CreditItem.amountToFinance, CreditItem.duration, CreditItem.rate, CreditItem.insuranceRate, CreditItem.bookingFees]
    var creditTextFieldCells = [TextFieldWithoutSubtitleTableViewCell]()
    var creditStepperCells = [StepperTableViewCell]()
    let creditDuration = [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    let resultTitles = ["Mensualités", "Coût intérêts", "Coût assurance", "Coût total"]
    var results = [String]()
    var creditData = ["Montant à financer": "", "Durée": "", "Taux": "", "Taux assurance": "", "Frais de dossier": ""]
}
