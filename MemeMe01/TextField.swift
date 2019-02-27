//
//  TextField.swift
//  MemeMe01
//
//  Created by nouf alharbi on 1/26/19.
//  Copyright © 2019 nouf alharbi. All rights reserved.
//

import Foundation
import UIKit

// MARK: - textField: NSObject, UITextFieldDelegate

class TextField : NSObject, UITextFieldDelegate {
    

    func textFieldDidBeginEditing(_ topField: UITextField) {
        if topField.text=="TOP" || topField.text=="BOTTOM" {
            topField.text = ""
        }
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}
