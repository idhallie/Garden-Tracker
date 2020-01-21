//
//  KeyboardHideExtension.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/20/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit

extension UIViewController {
    func HideKeyboard() {
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))

        view.addGestureRecognizer(Tap)
    }

    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
}

