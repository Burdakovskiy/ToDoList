//
//  Notification+Extensions.swift
//  SpeechToDoList
//
//  Created by Дмитрий on 19.08.2024.
//

import Foundation
import UIKit

extension Notification.Name {
    static let taskAdded = Notification.Name("taskAdded")
    static let taskUpdated = Notification.Name("taskUpdated")
}

extension UIViewController {
    func errorAlert(title: String?, message: String?, handler: ((UIAlertAction) -> Void)?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        present(ac, animated: true)
    }
}
