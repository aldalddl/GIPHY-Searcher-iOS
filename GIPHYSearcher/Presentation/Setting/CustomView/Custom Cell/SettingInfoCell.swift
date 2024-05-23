//
//  SettingInfoCell.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 5/23/24.
//

import Foundation
import UIKit
import SnapKit

class SettingInfoCell: UITableViewCell {
    static let id = "SettingInfoCell"
    
    var subLabel: UILabel = {
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        if let superview = self.contentView.superview {
            superview.backgroundColor = .tertiarySystemBackground
        }
        
        self.imageView?.tintColor = .white
        
        self.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        self.accessoryView = subLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
