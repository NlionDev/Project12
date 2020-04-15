//
//  RentabilityRepository.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 06/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class RentabilityRepository {
    
    //MARK: - Properties

    let resultTitles = ["Rendement Brut", "Rendement Net", "Cash-Flow Annuel", "Cash-Flow Mensuel"]
    let cells: RentabilityCells = [RentabilityItem.estatePrice, RentabilityItem.worksCost, RentabilityItem.notaryFees, RentabilityItem.monthlyRent, RentabilityItem.propertyTax, RentabilityItem.maintenanceFees, RentabilityItem.charges, RentabilityItem.managementFees, RentabilityItem.insurance, RentabilityItem.creditCost]
    var rentaTextFieldWithoutSubtitleCells = [TextFieldWithoutSubtitleTableViewCell]()
    var rentaTextFieldWithSubtitleCells = [TextFieldWithSubtitleTableViewCell]()
    var results = [String]()
    var resultsForPositiveCheck = [String]()
    var rentabilityData = ["Prix du bien": "", "Coût des travaux": "", "Frais de notaire": "", "Loyer mensuel": "", "Taxe foncière": "", "Frais d'entretien": "", "Charges de copropriété": "", "Frais de gérance": "", "Assurance loyers impayés": "", "Coût du crédit": ""]
    var rentabilityResultData = ["Rendement Brut": "", "Rendement Net": "", "Cash-Flow Annuel": "", "Cash-Flow Mensuel": ""]
}
