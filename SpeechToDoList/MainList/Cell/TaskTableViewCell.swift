//
//  TaskTableViewCell.swift
//  SpeechToDoList
//
//  Created by Дмитрий on 19.08.2024.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    
//MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        setupViews()
        setConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - Properties

    private var originalTaskDescription: String?

    private let taskDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let isCompletionButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var isCompletionButtonAction: (() -> Void)?
    
//MARK: - Functions
    
    private func strikeText(strike : String) -> NSMutableAttributedString {
        
        let attributeString = NSMutableAttributedString(string: strike)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
    
    private func setupActions() {
        isCompletionButton.addTarget(self, action: #selector(isCompletionButtonTapped), for: .touchUpInside)
    }
    
    private func setupViews() {
        contentView.addSubview(taskDescriptionLabel)
        contentView.addSubview(isCompletionButton)
        contentView.addSubview(dateLabel)
    }
    
    @objc private func isCompletionButtonTapped() {
        isCompletionButtonAction?()
    }
    
    func configure(withTask task: TaskObject) {
        originalTaskDescription = task.deskription
        check(status: task.isComplete)
        self.backgroundColor = task.getTaskColor(from: task.priority)
    }
    
    func check(status: Bool = false) {
        if status {
            isCompletionButton.tintColor = .systemGreen
            taskDescriptionLabel.attributedText = strikeText(strike: originalTaskDescription ?? "")
            isCompletionButton.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        } else {
            isCompletionButton.tintColor = .black
            isCompletionButton.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
            taskDescriptionLabel.attributedText = NSAttributedString(string: originalTaskDescription ?? "")
        }
    }
}

//MARK: - setConstraints
private extension TaskTableViewCell {
    func setConstraints() {
        NSLayoutConstraint.activate([
            isCompletionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            isCompletionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            isCompletionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            isCompletionButton.widthAnchor.constraint(equalToConstant: 50),
            
            taskDescriptionLabel.leadingAnchor.constraint(equalTo: isCompletionButton.trailingAnchor, constant: 12),
            taskDescriptionLabel.centerYAnchor.constraint(equalTo: isCompletionButton.centerYAnchor),
            taskDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
        ])
    }
}
