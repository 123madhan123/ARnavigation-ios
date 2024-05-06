//
//  MessagePresenting.swift
//  AR Main Navigation
//
//  Created by Prasanth on 13/02/24.
//

import Foundation
import UIKit

protocol MessagePresenting {
    func presentMessage(title: String, message: String)
}

extension MessagePresenting where Self: UIViewController {
    func presentMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}
