//
//  ChecklistViewController.swift
//  Invest'Immo
//
//  Created by Nicolas Lion on 26/03/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit
import RealmSwift


class ChecklistViewController: UIViewController {
    
    //MARK: - Properties
    
    let realm = try! Realm()
    lazy var myProjects: Results<Project> = {
    self.realm.objects(Project.self)}()
    let existantProjectAlertService = ExistantProjectAlertService()
    let newProjectAlertService = NewProjectAlertService()
    var checklistData = ChecklistData()
    var simulation = RentabilitySimulation()
    var estateType = ["Studio", "T2", "T3", "T4", "T5", "Maison de village", "Villa", "Immeuble"]
    var quality = ["Trés mauvais", "Mauvais", "Bon", "Trés bon", "Non concerné"]
    var dpe = ["A", "B", "C", "D", "E", "F", "G"]
    var direction = ["Sud-Est", "Sud", "Sud-Ouest", "Ouest", "Nord-Ouest", "Nord", "Nord-Est", "Est"]
    var roomView = ["Rue", "Cour", "Non concerné"]
    var heatingSystem = ["Electrique", "A gaz", "Au fioul", "A bois", "Solaire"]
    
    //MARK: - Outlets
    
    @IBOutlet weak var visitDatePicker: UIDatePicker!
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
        setChecklistNavigationBarStyle()
        setupSaveButtonItem(action: #selector(didTapOnSaveButton))
    }

    //MARK: - Actions
    
    @objc private func didTapOnSaveButton() {
        saveData()
        if myProjects.isEmpty {
            if #available(iOS 13.0, *) {
                let alertVC = newProjectAlertService.alert(checklist: checklistData, simulation: simulation)
                present(alertVC, animated: true)
            } else {
            }
        } else {
            if #available(iOS 13.0, *) {
                let alertVC = existantProjectAlertService.alert(checklist: checklistData, simulation: simulation)
                present(alertVC, animated: true)
            } else {
            }
        }
    }
    
    
    //MARK: - Methods
    
    private func getSelectedFromPickerView(picker: UIPickerView, array: [String]) -> String {
        let index = picker.selectedRow(inComponent: 0)
        let selected = array[index]
        return selected
    }
    
    private func getSelectedYesOrNoFromSegmentedControl(segment: UISegmentedControl) -> String {
        if segment.selectedSegmentIndex == 0 {
            return "Oui"
        } else {
            return "Non"
        }
    }
    
    private func getInternetChoiceFromSegmentedControl() -> String {
        if internetSegmentedControl.selectedSegmentIndex == 0 {
            return "Fibre"
        } else {
            return "ADSL"
        }
    }
    
    private func getSyndicateChoiceFromSegmentedControl() -> String {
        if syndicateSegmentedControl.selectedSegmentIndex == 0 {
            return "Bénévole"
        } else {
            return "Professionnel"
        }
    }
    
    private func getHeatingTypeChoiceFromSegmentedControl() -> String {
        if heatingTypeSegmentedControl.selectedSegmentIndex == 0 {
            return "Individuel"
        } else {
            return "Collectif"
        }
    }
    
    private func saveChecklistGeneralData() {
        checklistData.visitDate = visitDatePicker.date.transformIntoString
        checklistData.estateType = getSelectedFromPickerView(picker: estateTypePickerView, array: estateType)
        guard let surfaceArea = surfaceAreaTextField.text else {return}
        checklistData.surfaceArea = surfaceArea
    }
    
    private func saveChecklistNeighborhoodData() {
        guard let problem = problemTextView.text else {return}
        checklistData.problem = problem
        guard let advantage = advantageTextView.text else {return}
        checklistData.advantage = advantage
        guard let transports = transportsTextView.text else {return}
        checklistData.transports = transports
        checklistData.easyPark = getSelectedYesOrNoFromSegmentedControl(segment: easyParkSegmentedControl)
    }
    
    private func saveChecklistApartmentBlockData() {
        guard let yearOfConstruction = yearOfConstructionTextField.text else {return}
        checklistData.yearOfConstruction = yearOfConstruction
        guard let numberOfLots = numberOfLotsTextField.text else {return}
        checklistData.numberOfLots = numberOfLots
        checklistData.internet = getInternetChoiceFromSegmentedControl()
        checklistData.syndicate = getSyndicateChoiceFromSegmentedControl()
        checklistData.facade = getSelectedFromPickerView(picker: facadePickerView, array: quality)
        checklistData.roof = getSelectedFromPickerView(picker: roofPickerView, array: quality)
        checklistData.communalAreas = getSelectedFromPickerView(picker: communalAreasPickerView, array: quality)
    }
    
    private func saveChecklistApartmentData() {
        checklistData.dpe = getSelectedFromPickerView(picker: dpePickerView, array: dpe)
        checklistData.light = getSelectedYesOrNoFromSegmentedControl(segment: lightSegmentedControl)
        checklistData.dualAspect = getSelectedYesOrNoFromSegmentedControl(segment: dualAspectSegmentedControl)
        checklistData.vmc = getSelectedYesOrNoFromSegmentedControl(segment: vmcSegmentedControl)
        checklistData.humidity = getSelectedYesOrNoFromSegmentedControl(segment: humiditySegmentedControl)
        guard let heightUnderCeiling = heightUnderCeilingTextField.text else {return}
        checklistData.heightUnderCeiling = heightUnderCeiling
        checklistData.planeness = getSelectedFromPickerView(picker: planenessPickerView, array: quality)
        checklistData.insulation = getSelectedFromPickerView(picker: insulationPickerView, array: quality)
        checklistData.soundInsulation = getSelectedFromPickerView(picker: soundInsulationPickerView, array: quality)
        checklistData.direction = getSelectedFromPickerView(picker: directionPickerView, array: direction)
        checklistData.bedroom = getSelectedFromPickerView(picker: bedroomPickerView, array: roomView)
        checklistData.liferoom = getSelectedFromPickerView(picker: liferoomPickerView, array: roomView)
        checklistData.heatingSystem = getSelectedFromPickerView(picker: heatingSystemPickerView, array: heatingSystem)
        checklistData.heatingType = getHeatingTypeChoiceFromSegmentedControl()
        checklistData.electricity = getSelectedYesOrNoFromSegmentedControl(segment: electricitySegmentedControl)
        checklistData.electricityMeters = getSelectedYesOrNoFromSegmentedControl(segment: electricityMetersSegmentedControl)
        checklistData.toilet = getSelectedYesOrNoFromSegmentedControl(segment: toiletSegmentedControl)
        checklistData.bathroom = getSelectedYesOrNoFromSegmentedControl(segment: bathroomSegmentedControl)
        checklistData.plumbingQuality = getSelectedFromPickerView(picker: plumbingQualityPickerView, array: quality)
        checklistData.groundQuality = getSelectedFromPickerView(picker: groundQualityPickerView, array: quality)
        checklistData.wallQuality = getSelectedFromPickerView(picker: wallQualityPickerView, array: quality)
        checklistData.shutters = getSelectedFromPickerView(picker: shuttersPickerView, array: quality)
        checklistData.doubleGlazing = getSelectedYesOrNoFromSegmentedControl(segment: doubleGlazingSegmentedControl)
        checklistData.reconfiguration = getSelectedYesOrNoFromSegmentedControl(segment: reconfigurationSegmentedControl)
        checklistData.cave = getSelectedYesOrNoFromSegmentedControl(segment: caveSegmentedControl)
        guard let caveSurface = caveSurfaceTextField.text else {return}
        checklistData.caveSurface = caveSurface
        checklistData.parking = getSelectedYesOrNoFromSegmentedControl(segment: parkingSegmentedControl)
        guard let distinguishElements = distinguishElementsTextView.text else {return}
        checklistData.distinguishElements = distinguishElements
      }
    
    private func saveData() {
        saveChecklistGeneralData()
        saveChecklistNeighborhoodData()
        saveChecklistApartmentBlockData()
        saveChecklistApartmentData()
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
