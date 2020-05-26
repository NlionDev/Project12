//
//  SegmentTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Protocol for SegmentTableViewCellDelegate
protocol SegmentTableViewCellDelegate: class {
    func segmentTableViewCell(_ segmentTableViewCell: SegmentTableViewCell, key: String, value: String, sectionKey: Int)
}

/// Class for SegmentTableViewCell
class SegmentTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    /// Property for delegate
    weak var delegate: SegmentTableViewCellDelegate?
    
    /// Property for store the segment ID that corresponds to allSegmentData sections
    private var segmentId = Int()
    
    /// Property for stock title of cell who will be the key in data dictionary
    private var key = String()
    
    /// Property for store selected section to store data in data dictionary
    private var section = Int()
    
    /// Dictionary for set correct data in segment depending of segment ID
    private let allSegmentData = [
        [0: "Individuel", 1: "Collectif"],
        [0: "Bénévole", 1: "Pro"],
        [0: "Fibre", 1: "ADSL"],
        [0: "Oui", 1: "Non"]
    ]
    
    /// Property to store the correct value to display in segment
    var segmentValue = String()
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellSegment: UISegmentedControl!
    
    //MARK: - Actions
    
    /// Actions activated when segment value change for get correct data
    @IBAction func didChangeValue(_ sender: Any) {
        let index = cellSegment.selectedSegmentIndex
        if let newValue = index == 0 ? allSegmentData[segmentId][index] : allSegmentData[segmentId][index] {
            delegate?.segmentTableViewCell(self, key: key, value: newValue, sectionKey: section)
        }
    }
    
    
    //MARK: - Methods
    
    /// Method for configure heating type segment with correct data
    private func configureHeatingTypeSegment() {
        cellSegment.setTitle("Individuel", forSegmentAt: 0)
        cellSegment.setTitle("Collectif", forSegmentAt: 1)
        segmentValue = "Individuel"
    }
    
    /// Method for configure syndicate segment with correct data
    private func configureSyndicateSegment() {
        cellSegment.setTitle("Bénévole", forSegmentAt: 0)
        cellSegment.setTitle("Pro", forSegmentAt: 1)
        segmentValue = "Bénévole"
    }
    
    /// Method for configure internet segment with correct data
    private func configureInternetSegment() {
        cellSegment.setTitle("Fibre", forSegmentAt: 0)
        cellSegment.setTitle("ADSL", forSegmentAt: 1)
        segmentValue = "Fibre"
    }
    
    /// Method for configure yes/no segment with correct data
    private func configureYesNoSegment() {
        cellSegment.setTitle("Oui", forSegmentAt: 0)
        cellSegment.setTitle("Non", forSegmentAt: 1)
        segmentValue = "Oui"
    }
    
    /// Method for setup correct segment
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
    
    /// Method for configure cell with data
    func configure(title: String, sectionKey: Int) {
        section = sectionKey
        key = title
        titleLabel.text = title
        configureCorrectSegment(key: title)
    }
    
}
