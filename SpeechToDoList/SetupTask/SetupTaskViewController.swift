//
//  SetupTaskViewController.swift
//  SpeechToDoList
//
//  Created by Дмитрий on 19.08.2024.
//

import UIKit
import UserNotifications
import Speech

final class SetupTaskViewController: UIViewController {
    
    //MARK: - Properties
    
    private let setupTaskView = SetupTaskView()
    private let priorityTypes = Priority.getAllCases
    private var taskDescription = ""
    private var taskDateAndTime: Date?
    private var taskPriority = Priority.low
    private var isDateSwitchOn = false {
        didSet {
            setupTaskView.setIsDateSwitchAppearence(with: isDateSwitchOn)
        }
    }
    
    var task: TaskObject?
    
    //MARK: - Functions
    
    private func getSelectedPriority() -> Priority {
        let selectedRowIndex = setupTaskView.getPickerSelectedRow(in: 0)
        switch selectedRowIndex {
        case 0: taskPriority = Priority.low
        case 1: taskPriority = Priority.normal
        case 2: taskPriority = Priority.high
        case 3: taskPriority = Priority.absolute
        default:
            taskPriority = Priority.normal
        }
        return taskPriority
    }
    
    private func getTimeStringFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    private func checkDatePickerStatus() {
        if let task, task.date != nil {
            isDateSwitchOn = true
        } else {
            isDateSwitchOn = false
        }
    }
    
    private func configurateController(with task: TaskObject) {
        setupTaskView.setTaskDescription(text: task.deskription)
        taskDateAndTime = task.date
        taskPriority = task.priority
        var row = 0
        switch taskPriority {
        case .low:
            row = 0
        case .normal:
            row = 1
        case .high:
            row = 2
        case .absolute:
            row = 3
        }
        setupTaskView.selectPriorityPicker(row: row)
        
        if let date = task.date {
            taskDateAndTime = task.date
            setupTaskView.setTimeLable(text: getTimeStringFrom(date: date))
        }
    }
    
    private func getTaskDescription() -> String? {
        guard let text = setupTaskView.getTaskDescription(),
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorAlert(title: nil, message: "Task description cannot be empty.", handler: nil)
            return nil
        }
        guard text.count >= 3 else {
            errorAlert(title: nil, message: "Task description cannot be less than 3 symbols.", handler: nil)
            return nil
        }
        return text
    }
    
    private func setDelegates() {
        setupTaskView.setPriorityPicker(delegate: self)
        setupTaskView.setPriorityPicker(dataSource: self)
        setupTaskView.setDatePickerView(delegate: self)
        setupTaskView.setupButtonActionsDelegate = self
    }
    
    private func getUserPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {granted, error in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                if granted {
                    setupTaskView.showDateTimePicker()
                } else {
                    print("Nope")
                }
            }
        }
    }
    
    private func requestSpeechAuthorization() {
        SpeechRecognizerManager.shared.requestSpeechAuthorization { [weak self] isAuthorized in
            guard let self else { return }
            setupTaskView.updateMicrophoneButton(enabled: isAuthorized)
        }
    }
    
    private func startRecording() {
        SpeechRecognizerManager.shared.startRecording {[weak self] text in
            guard let self else { return }
            setupTaskView.setTaskDescription(text: text)
        }
    }
    
    private func stopRecording() {
        SpeechRecognizerManager.shared.stopRecording()
    }
    
    
    @objc private func saveButtonTapped() {
        guard let description = getTaskDescription() else { return }
        let priority = getSelectedPriority()
        var dateTime: Date? {
            return isDateSwitchOn ? taskDateAndTime : nil
        }
        if task == nil {
            DatabaseManager.shared.saveTask(description: description,
                                            priority: priority,
                                            date: dateTime)
            NotificationCenter.default.post(name: .taskAdded, object: nil)
            errorAlert(title: nil, message: "Task successfuly saved.") {[weak self] _ in
                guard let self else { return }
                self.dismiss(animated: true)
            }
            if taskDateAndTime != nil && isDateSwitchOn == true {
                NotificationManager.scheduleNotification(at: taskDateAndTime!, with: description)
            }
        } else if let task {
            DatabaseManager.shared.updateTask(id: task.id,
                                              description: description,
                                              priority: priority,
                                              isComplete: task.isComplete,
                                              date: dateTime)
            NotificationCenter.default.post(name: .taskUpdated, object: nil)
            errorAlert(title: nil, message: "Task successfuly updated.") {[weak self] _ in
                guard let self else { return }
                self.dismiss(animated: true)
            }
            if taskDateAndTime != nil && isDateSwitchOn == true{
                NotificationManager.scheduleNotification(at: taskDateAndTime!, with: description)
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        view = setupTaskView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        if let task = task {
            configurateController(with: task)
        }
        checkDatePickerStatus()
        requestSpeechAuthorization()
    }
}

//MARK: - SetupButtonActionsProtocol
extension SetupTaskViewController: SetupButtonActionsProtocol {
    func saveButtonAction() {
        saveButtonTapped()
    }
    
    func timeStackAction() {
        getUserPermission()
    }
    
    func microphoneButtonAction() {
        if SpeechRecognizerManager.shared.isRecording() {
            stopRecording()
            setupTaskView.updateMicroButton(isActive: false)
        } else {
            startRecording()
            setupTaskView.updateMicroButton(isActive: true)
        }
    }
    
    func isOnDatePickerSwitcherAction() {
        isDateSwitchOn.toggle()
    }
}

//MARK: - UIPickerViewDelegate
extension SetupTaskViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priorityTypes[row]
    }
}

//MARK: - UIPickerViewDataSource
extension SetupTaskViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorityTypes.count
    }
}

//MARK: - DatePickerActionsProtocol
extension SetupTaskViewController: DatePickerActionsProtocol {
    func doneButtonAction() {
        setupTaskView.updateDatePicker(hidden: true)
        setupTaskView.hideBackgroundView()
        taskDateAndTime = setupTaskView.getSelectedDate()
        if let taskDateAndTime {
            setupTaskView.setTimeLable(text: getTimeStringFrom(date: taskDateAndTime))
        }
    }
    
    func cancelButtonAction() {
        setupTaskView.updateDatePicker(hidden: true)
        setupTaskView.hideBackgroundView()
    }
}
