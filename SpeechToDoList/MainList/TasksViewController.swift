//
//  ViewController.swift
//  SpeechToDoList
//
//  Created by Дмитрий on 19.08.2024.
//

import UIKit
import RealmSwift

class TasksViewController: UIViewController {
    
//MARK: - Properties
    
    private let mainListView = MainListView(frame: .zero)
    private var tasks: Results<TaskObject>!
    
//MARK: - Functions
    
    private func setupNavController() {
        title = "To Do List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.prefersLargeTitles = true
        let addNewTaskButton = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonTapped))
        let deleteTasksButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                                target: self,
                                                action: #selector(deleteTaskButtonTapped))
        navigationItem.rightBarButtonItems = [deleteTasksButton, addNewTaskButton]
        
    }
    
    private func setDelegates() {
        mainListView.setTableView(delegate: self)
        mainListView.setTableView(dataSource: self)
    }
    
    private func isCompletionButtonActionHandler(indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let newStatus = !task.isComplete
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            mainListView.reloadRow(at: indexPath)
        }
        DatabaseManager.shared.updateTask(id: task.id,
                                          description: task.deskription,
                                          priority: task.priority,
                                          isComplete: newStatus,
                                          date: task.date)
    }
    
    @objc private func addButtonTapped() {
        let setupVC = SetupTaskViewController()
        present(setupVC, animated: true)
    }
    
    @objc private func deleteTaskButtonTapped() {
        mainListView.updateTableViewIsEditingMode()
    }
    
    @objc private func reloadTasks() {
        tasks = DatabaseManager.shared.getAllTasks()
        mainListView.reloadTableView()
    }
    
    override func loadView() {
        super.loadView()
        view = mainListView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasks = DatabaseManager.shared.getAllTasks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setupNavController()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTasks),
                                               name: .taskAdded,
                                               object: nil )
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTasks),
                                               name: .taskUpdated,
                                               object: nil )
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: .taskAdded,
                                                  object: nil)
    }
}

//MARK: - UITableViewDelegate
extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let setupVC = SetupTaskViewController()
        let chosenTask = tasks[indexPath.row]
        setupVC.task = chosenTask
        present(setupVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            DatabaseManager.shared.deleteTaskBy(id: task.id)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


//MARK: - UITableViewDataSource
extension TasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.cellId, for: indexPath) as? TaskTableViewCell {
            let currentTask = tasks[indexPath.row]
            cell.configure(withTask: currentTask)
            cell.isCompletionButtonAction = {[weak self] in
                guard let self else { return }
                self.isCompletionButtonActionHandler(indexPath: indexPath)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    //TODO: MoveRowAt
}
