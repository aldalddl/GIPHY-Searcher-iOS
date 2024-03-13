//
//  BookmarkButton.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 3/9/24.
//

import Foundation
import UIKit

class BookmarkButton: UIButton {
    var customTag: String = ""
    
    override init(frame: CGRect) {
        super .init(frame: .zero)
        
        self.setImage(UIImage(systemName: "bookmark"), for: .normal)
        self.tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
