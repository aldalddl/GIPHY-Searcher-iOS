//
//  Constants.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 5/23/24.
//

import Foundation
import UIKit

struct Developer {
    static let name = "Minji Kang"
    static let description = "github.com/aldalddl"
}

struct App {
    static let currentVersion: String = {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "Undefined" }
        return version
    }()
}
