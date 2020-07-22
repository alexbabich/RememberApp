//
//  Extension.swift
//  RememberApp
//
//  Created by alex-babich on 22.07.2020.
//  Copyright © 2020 alex-babich. All rights reserved.
//

import Foundation
import Swift
import SwiftUI


extension UINavigationController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.init(named: "navi")
        
        navigationBar.standardAppearance = appearance
    }
}
