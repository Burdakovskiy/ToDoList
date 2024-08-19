//
//  Task.swift
//  SpeechToDoList
//
//  Created by Дмитрий on 19.08.2024.
//

import RealmSwift
import UIKit

final class TaskObject: Object {

//MARK: - Properties
    
    @Persisted(primaryKey: true) var id: ObjectId = ObjectId.generate()
    @Persisted var isComplete: Bool = false
    @Persisted var priorityType: String = Priority.normal.rawValue
    @Persisted var date: Date? = nil
    @Persisted var deskription: String = ""
    
    var priority: Priority {
        get {
            return Priority(rawValue: priorityType) ?? .normal
        }
        set {
            priorityType = newValue.rawValue
        }
    }

//MARK: - Functions
    
    public func getTaskColor(from priority: Priority) -> UIColor {
        switch priority {
        case .low:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .normal:
            return #colorLiteral(red: 0.872953869, green: 1, blue: 1, alpha: 1)
        case .high:
            return #colorLiteral(red: 0.7762420607, green: 1, blue: 1, alpha: 1)
        case .absolute:
            return #colorLiteral(red: 0.6182066612, green: 1, blue: 1, alpha: 1)
        }
    }
}

//MARK: - Priority Enum

enum Priority: String, CaseIterable {
    case low
    case normal
    case high
    case absolute
    
    static var getAllCases: [String] {
        allCases.map {
            $0.rawValue.capitalized
        }
    }
}
