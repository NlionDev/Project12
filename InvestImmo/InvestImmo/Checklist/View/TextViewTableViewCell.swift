//
//  TextViewTableViewCell.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 07/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

protocol TextViewData: class {
    func getTextViewData(key: String, value: String, sectionKey: Int)
}

class TextViewTableViewCell: UITableViewCell, UITextViewDelegate {

    
    //MARK: - Properties
    
    weak var delegate: TextViewData?
    private var key = String()
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
    
    func configure(title: String, sectionKey: Int) {
        key = title
        titleLabel.text = title
        section = sectionKey
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if let text = cellTextView.text {
            delegate?.getTextViewData(key: key, value: text, sectionKey: section)
        }
        return true
    }
}
