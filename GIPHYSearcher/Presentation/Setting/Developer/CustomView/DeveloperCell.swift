//
//  DeveloperCell.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 5/23/24.
//

import Foundation
import UIKit
import SnapKit

class DeveloperCell: UITableViewCell {
    static let id = "DeveloperInfoCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .background
        
        self.detailTextLabel?.textColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
