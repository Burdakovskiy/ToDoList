//
//  MainListView.swift
//  SpeechToDoList
//
//  Created by Дмитрий on 19.08.2024.
//

import UIKit

final class MainListView: UIView {
    
//MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Properties
    private let taskTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
//MARK: - Functions
    
    private func setupViews() {
        addSubview(taskTableView)
    }
    
    func setTableView(delegate: UITableViewDelegate) {
        taskTableView.delegate = delegate
    }
    
    func setTableView(dataSource: UITableViewDataSource) {
        taskTableView.dataSource = dataSource
    }
    
    func updateTableViewIsEditingMode() {
        taskTableView.isEditing.toggle()
    }
    
    func reloadRow(at index: IndexPath) {
        taskTableView.reloadRows(at: [index], with: .automatic)
    }
    
    func reloadTableView() {
        taskTableView.reloadData()
    }
}

//MARK: - setConstraints
private extension MainListView {
    func setConstraints() {
        NSLayoutConstraint.activate([
            taskTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            taskTableView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            taskTableView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
