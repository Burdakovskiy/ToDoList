//
//  DatePickerView.swift
//  SpeechToDoList
//
//  Created by Дмитрий on 19.08.2024.
//

import UIKit

//MARK: - DatePickerActionsProtocol
protocol DatePickerActionsProtocol: AnyObject {
    func doneButtonAction()
    func cancelButtonAction()
}

final class DatePickerView: UIView {

//MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
        setupActions()
        configurate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Properties
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .inline
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var datePickerActionDelegate: DatePickerActionsProtocol?
    
//MARK: - Functions
    
    private func configurate() {
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        isHidden = true
    }
    
    private func setupViews() {
        addSubview(datePicker)
        addSubview(doneButton)
        addSubview(cancelButton)
    }
    
    private func setupActions() {
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    func getSelectedDate() -> Date {
        let selectedDate = datePicker.date
//        let timeZoneOffset = TimeInterval(TimeZone.current.secondsFromGMT(for: selectedDate))
//        let selectedDateInLocalTimezone = selectedDate.addingTimeInterval(timeZoneOffset)
//        return selectedDateInLocalTimezone
        return selectedDate
    }
    
    @objc private func doneButtonTapped() {
        datePickerActionDelegate?.doneButtonAction()
    }
    
    @objc private func cancelButtonTapped() {
        datePickerActionDelegate?.cancelButtonAction()
    }
}

//MARK: - setConstraints
private extension DatePickerView {
    func setConstraints() {
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
    
            doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 2),
            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            doneButton.widthAnchor.constraint(equalToConstant: (datePicker.frame.width / 2) - 25),
            
            cancelButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 2),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            cancelButton.widthAnchor.constraint(equalToConstant: (datePicker.frame.width / 2) - 25),
        ])
    }
}
