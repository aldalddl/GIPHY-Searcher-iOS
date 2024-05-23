//
//  SettingDisclosureCell.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 5/23/24.
//

import Foundation
import UIKit
import SnapKit

class SettingDisclosureCell: UITableViewCell {
    static let id = "SettingDisclosureCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        if let superview = self.contentView.superview {
            superview.backgroundColor = .tertiarySystemBackground
        }
        
        self.imageView?.tintColor = .white
        
        self.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
