//
//  Extensions.swift
//  My first app
//
//  Created by ios02 on 04.03.18.
//  Copyright © 2018 ios02. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    /// Custom alert
    func showDefaultAlert(title: String,
                          message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    /// Custom button.
    func buttonStyle(title: String, button: UIButton) {
        button.backgroundColor = UIColor(red: 51/255.0, green: 52/255.0, blue: 108/255.0, alpha: 1)
        button.setTitleColor(UIColor(red: 237/255.0, green: 237/255.0, blue: 239/255.0, alpha: 1), for: .normal)
        button.layer.cornerRadius = 10
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
    }

}
