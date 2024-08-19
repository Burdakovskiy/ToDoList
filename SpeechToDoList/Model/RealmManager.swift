//
//  RealmManager.swift
//  SpeechToDoList
//
//  Created by Дмитрий on 19.08.2024.
//

import Foundation
import RealmSwift

final class DatabaseManager {
    
//MARK: - Initializers
    
    private init() {}

//MARK: - Properties
    
    static let shared = DatabaseManager()
    private let localRealm = try! Realm()
    
    
//MARK: - Functions
    
    func saveTask(description: String, priority: Priority, date: Date?) {
        let task = TaskObject()
        task.deskription = description
        task.priority = priority
        task.date = date
        do {
            try localRealm.write {
                localRealm.add(task)
            }
        } catch {
            print("Error while writting taskObject at DatabaseManager.saveTask(): \(error.localizedDescription)")
        }
    }
    
    func getAllTasks() -> Results<TaskObject> {
        return localRealm.objects(TaskObject.self)
    }
    
    func deleteTaskBy(id: ObjectId) {
        if let task = localRealm.object(ofType: TaskObject.self, forPrimaryKey: id) {
            do {
                try localRealm.write {
                    localRealm.delete(task)
                }
            } catch {
                print("Error while delete task at DatabaseManager.deleteTaskBy(): \(error.localizedDescription)")
            }
        }
    }
    
    func updateTask(id: ObjectId,
                           description: String?,
                           priority: Priority?,
                           isComplete: Bool?,
                           date: Date?) {
        if let task = localRealm.object(ofType: TaskObject.self, forPrimaryKey: id) {
            do {
                try localRealm.write {
                    if let description = description {
                        task.deskription = description
                    }
                    if let priority = priority {
                        task.priority = priority
                    }
                    if let isComplete = isComplete {
                        task.isComplete = isComplete
                    }
                    task.date = date
                }
            } catch {
                print("Error while updating task at DatabaseManager.updateTask(): \(error.localizedDescription)")
            }
        }
    }
}
