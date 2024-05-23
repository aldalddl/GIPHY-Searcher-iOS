//
//  DeveloperSection.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 5/23/24.
//

import Foundation

enum DeveloperSection: Int, CaseIterable {
    case github, email
    
    var icon: String {
        switch self {
        case .github:
            return "github"
        case .email:
            return "email"
        }
    }
    
    var title: String {
        switch self {
        case .github:
            return "GitHub"
        case .email:
            return "Email"
        }
    }
    
    var desctiprion: String {
        switch self {
        case .github:
            return "Check out GitHub for more information"
        case .email:
            return "Any questions about the app, please let me know"
        }
    }
    
    var source: String {
        switch self {
        case .github:
            return "https://github.com/aldalddl"
        case .email:
            return "aldalddl2007@gmail.com"
        }
    }
}
