//
//  ChecklistViewController.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 26/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class ChecklistViewController: UIViewController {
    
    //MARK: - Properties
    
    let customPickerView = CustomPickerView()
    var estateType = ["Studio", "T2", "T3", "T4", "T5", "Maison de village", "Villa", "Immeuble"]
    var quality = ["Trés mauvais", "Mauvais", "Bon", "Trés bon", "Non concerné"]
    var dpe = ["A", "B", "C", "D", "E", "F", "G"]
    var direction = ["Sud-Est", "Sud", "Sud-Ouest", "Ouest", "Nord-Ouest", "Nord", "Nord-Est", "Est"]
    var roomView = ["Rue", "Cour", "Non concerné"]
    var heatingSystem = ["Electrique", "A gaz", "Au fioul", "A bois", "Solaire"]
    
    //MARK: - Outlets
    
    @IBOutlet weak var estateTypePickerView: UIPickerView!
    @IBOutlet weak var surfaceAreaTextField: UITextField!
    @IBOutlet weak var problemTextView: UITextView!
    @IBOutlet weak var advantageTextView: UITextView!
    @IBOutlet weak var transportsTextView: UITextView!
    @IBOutlet weak var easyParkSegmentedControl: UISegmentedControl!
    @IBOutlet weak var yearOfConstructionTextField: UITextField!
    @IBOutlet weak var numberOfLotsTextField: UITextField!
    @IBOutlet weak var internetSegmentedControl: UISegmentedControl!
    @IBOutlet weak var syndicateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var facadePickerView: UIPickerView!
    @IBOutlet weak var roofPickerView: UIPickerView!
    @IBOutlet weak var communalAreasPickerView: UIPickerView!
    @IBOutlet weak var dpePickerView: UIPickerView!
    @IBOutlet weak var lightSegmentedControl: UISegmentedControl!
    @IBOutlet weak var dualAspectSegmentedControl: UISegmentedControl!
    @IBOutlet weak var vmcSegmentedControl: UISegmentedControl!
    @IBOutlet weak var humiditySegmentedControl: UISegmentedControl!
    @IBOutlet weak var heightUnderCeilingTextField: UITextField!
    @IBOutlet weak var planenessPickerView: UIPickerView!
    @IBOutlet weak var insulationPickerView: UIPickerView!
    @IBOutlet weak var soundInsulationPickerView: UIPickerView!
    @IBOutlet weak var directionPickerView: UIPickerView!
    @IBOutlet weak var bedroomPickerView: UIPickerView!
    @IBOutlet weak var liferoomPickerView: UIPickerView!
    @IBOutlet weak var heatingSystemPickerView: UIPickerView!
    @IBOutlet weak var heatingTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var electricitySegmentedControl: UISegmentedControl!
    @IBOutlet weak var electricityMetersSegmentedControl: UISegmentedControl!
    @IBOutlet weak var toiletSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bathroomSegmentedControl: UISegmentedControl!
    @IBOutlet weak var plumbingQualityPickerView: UIPickerView!
    @IBOutlet weak var groundQualityPickerView: UIPickerView!
    @IBOutlet weak var wallQualityPickerView: UIPickerView!
    @IBOutlet weak var shuttersPickerView: UIPickerView!
    @IBOutlet weak var doubleGlazingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var reconfigurationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var caveSegmentedControl: UISegmentedControl!
    @IBOutlet weak var caveSurfaceTextField: UITextField!
    @IBOutlet weak var parkingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var distinguishElementsTextView: UITextView!
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }



}

//MARK: - Extension

extension ChecklistViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var result = 0
        if pickerView == estateTypePickerView {
            result = estateType.count
        } else if pickerView == facadePickerView || pickerView == roofPickerView || pickerView == communalAreasPickerView || pickerView == planenessPickerView || pickerView == insulationPickerView || pickerView == soundInsulationPickerView || pickerView == plumbingQualityPickerView || pickerView == groundQualityPickerView || pickerView == wallQualityPickerView || pickerView == shuttersPickerView {
            result = quality.count
        } else if pickerView == dpePickerView {
            result = dpe.count
        } else if pickerView == directionPickerView {
            result = direction.count
        } else if pickerView == bedroomPickerView || pickerView == liferoomPickerView {
            result = roomView.count
        } else if pickerView == heatingSystemPickerView {
            result = heatingSystem.count
        }
        return result
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var result = ""
        if pickerView == estateTypePickerView {
            result = estateType[row]
        } else if pickerView == facadePickerView || pickerView == roofPickerView || pickerView == communalAreasPickerView || pickerView == planenessPickerView || pickerView == insulationPickerView || pickerView == soundInsulationPickerView || pickerView == plumbingQualityPickerView || pickerView == groundQualityPickerView || pickerView == wallQualityPickerView || pickerView == shuttersPickerView {
            result = quality[row]
        } else if pickerView == dpePickerView {
            result = dpe[row]
        } else if pickerView == directionPickerView {
            result = direction[row]
        } else if pickerView == bedroomPickerView || pickerView == liferoomPickerView {
            result = roomView[row]
        } else if pickerView == heatingSystemPickerView {
            result = heatingSystem[row]
        }
        return result
    }
}
