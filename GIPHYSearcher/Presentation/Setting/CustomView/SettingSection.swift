//
//  SettingSections.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 5/23/24.
//

import Foundation

enum SettingSection: Int, CaseIterable {
    case information
    
    var headerDescription: String {
        switch self {
        case .information:
            return "Info"
        }        
    }
    
    var footerDescription: String {
        switch self {
        case .information:
            return "Information related to app"
        }
    }
}

enum Information: Int, CaseIterable {
    case version, developer
    
    var desctiprion: String {
        switch self {
        case .version:
            return "App Version"
        case .developer:
            return "Developer Info"
        }
    }
    
    var icon: String {
        switch self {
        case .version:
            return "iphone.gen1"
        case .developer:
            return "person.circle.fill"
        }
    }
}
