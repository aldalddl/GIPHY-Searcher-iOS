//
//  SettingTableViewSectionFooterView.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 5/23/24.
//

import Foundation
import UIKit
import SnapKit

func SettingSectionFooterView(description: String) -> UIView {
    let view = UIView()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .gray
        label.text = description
        return label
    }()
    
    view.addSubview(label)
    
    label.snp.makeConstraints { make in
        make.left.right.equalToSuperview().inset(5)
        make.top.equalToSuperview().inset(10)
    }
    
    return view
}
