//
//  BaseViewController.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 5/4/24.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    func showToast(message: String, offset: CGFloat) {
        let labelSize = calculateLabelSize(text: message, offset: offset)
        
        let toastLabel = UILabel(frame: labelSize)
        
        toastLabel.backgroundColor = .white.withAlphaComponent(0.8)
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        toastLabel.text = message
        toastLabel.textColor = .black
        toastLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        toastLabel.textAlignment = .center
        toastLabel.adjustsFontSizeToFitWidth = true
                
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 1.7, delay: 0.3, options: .curveEaseInOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { (_) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func calculateLabelSize(text: String, offset: CGFloat) -> CGRect {
        let label = UILabel()
        
        label.text = text
        
        let labelWidth = Int(label.intrinsicContentSize.width) + 10
        let labelHeight = Int(label.intrinsicContentSize.height) + 10
        
        let centerX = (Int(self.view.bounds.width) - labelWidth) / 2
        let positionY = Int(self.view.bounds.maxY) - Int(offset)
        
        let labelSize = CGRect(x: centerX, y: positionY, width: labelWidth, height: labelHeight)
        
        return labelSize
    }
}

