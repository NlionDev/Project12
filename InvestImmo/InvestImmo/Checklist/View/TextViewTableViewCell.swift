//
//  TextViewTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

/// Protocol for TextViewTableViewCellDelegate
protocol TextViewTableViewCellDelegate: class {
    func textViewTableViewCell(_ textViewTableViewCell: TextViewTableViewCell, key: String, value: String, sectionKey: Int)
}

/// Class for TextViewTableViewCell
class TextViewTableViewCell: UITableViewCell, UITextViewDelegate {

    
    //MARK: - Properties
    
    /// Property for delegate
    weak var delegate: TextViewTableViewCellDelegate?
    
    /// Property for stock title of cell who will be the key in data dictionary
    private var key = String()
    
    /// Property for store selected section to store data in data dictionary
    private var section = Int()
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellTextView: UITextView!
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellTextView.delegate = self
    }
    
    //MARK: - Methods
    
    /// Method for configure cell with data
    func configure(title: String, sectionKey: Int) {
        key = title
        titleLabel.text = title
        section = sectionKey
    }
    
    /// Method called when textview should end editing
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if let text = cellTextView.text {
            delegate?.textViewTableViewCell(self, key: key, value: text, sectionKey: section)
        }
        return true
    }
    
}
