//
//  SegmentTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

protocol SegmentData: class {
    func getSegmentData(key: String, value: String, sectionKey: Int)
}

class SegmentTableViewCell: UITableViewCell {

    
    //MARK: - Properties
    
    weak var delegate: SegmentData?
    private var segmentId = Int()
    private var key = String()
    private var section = Int()
    private let allSegmentData = [
        [0: "Individuel", 1: "Collectif"],
        [0: "Bénévole", 1: "Pro"],
        [0: "Fibre", 1: "ADSL"],
        [0: "Oui", 1: "Non"]
    ]
    var segmentValue = String()
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellSegment: UISegmentedControl!
    
    //MARK: - Actions
    
    
    @IBAction func didChangeValue(_ sender: Any) {
        let index = cellSegment.selectedSegmentIndex
        if let newValue = index == 0 ? allSegmentData[segmentId][index] : allSegmentData[segmentId][index] {
            delegate?.getSegmentData(key: key, value: newValue, sectionKey: section)
        }
    }
    
    
    //MARK: - Methods
    
    private func configureHeatingTypeSegment() {
        cellSegment.setTitle("Individuel", forSegmentAt: 0)
        cellSegment.setTitle("Collectif", forSegmentAt: 1)
        segmentValue = "Individuel"
    }
    
    private func configureSyndicateSegment() {
        cellSegment.setTitle("Bénévole", forSegmentAt: 0)
        cellSegment.setTitle("Pro", forSegmentAt: 1)
        segmentValue = "Bénévole"
    }
    
    private func configureInternetSegment() {
        cellSegment.setTitle("Fibre", forSegmentAt: 0)
        cellSegment.setTitle("ADSL", forSegmentAt: 1)
        segmentValue = "Fibre"
    }
    
    private func configureYesNoSegment() {
        cellSegment.setTitle("Oui", forSegmentAt: 0)
        cellSegment.setTitle("Non", forSegmentAt: 1)
        segmentValue = "Oui"
    }
    
    private func configureCorrectSegment(key: String) {
        if key == "Internet" {
            configureInternetSegment()
            segmentId = 0
        } else if key == "Syndicat" {
            configureSyndicateSegment()
            segmentId = 1
        } else if key == "Type de chauffage" {
            configureHeatingTypeSegment()
            segmentId = 2
        } else {
            configureYesNoSegment()
            segmentId = 3
        }
    }
    
    func configure(title: String, sectionKey: Int) {
        section = sectionKey
        key = title
        titleLabel.text = title
        configureCorrectSegment(key: title)
    }
    
}
