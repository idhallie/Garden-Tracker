//
//  UIButtonExtension.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/20/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit

// Thanks to Mark Moeykens of Big Mountain Studio (YouTube video)

extension UIButton {
    func createFloatingActionButton(){
        layer.cornerRadius = 7
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 10)
    }
}
