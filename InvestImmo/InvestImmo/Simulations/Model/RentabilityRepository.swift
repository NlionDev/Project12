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
    
    let titles = ["Prix du bien", "Coût des travaux", "Frais de notaire", "Loyer mensuel", "Taxe foncière", "Frais d'entretien", "Charges de copropriété", "Frais de gérance", "Assurance loyers impayés", "Coût du crédit"]
    let subtitles = ["", "", "", "( Hors charges )", "( Annuelle )", "( Annuels )", "( Annuelles )", "", "( Mensuelle )", "( Mensuel )" ]
    let resultTitles = ["Rendement Brut", "Rendement Net", "Cash-Flow Annuel", "Cash-Flow Mensuel"]
    var results = [String]()
    var resultsForPositiveCheck = [String]()
    var rentabilityData = ["Prix du bien": "", "Coût des travaux": "", "Frais de notaire": "", "Loyer mensuel": "", "Taxe foncière": "", "Frais d'entretien": "", "Charges de copropriété": "", "Frais de gérance": "", "Assurance loyers impayés": "", "Coût du crédit": ""]
    var rentaTextFieldWithSubtitleCells = [TextFieldWithSubtitleTableViewCell]()
    var rentaTextFieldWithoutSubtitleCells = [TextFieldWithoutSubtitleTableViewCell]()
}
