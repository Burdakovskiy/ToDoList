//
//  UITableViewCell+Extension.swift
//  SpeechToDoList
//
//  Created by Дмитрий on 19.08.2024.
//

import UIKit

extension UITableViewCell {
    static var cellId: String {
        return self.description()
    }
}
