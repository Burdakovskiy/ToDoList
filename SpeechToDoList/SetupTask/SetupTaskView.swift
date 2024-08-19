//
//  SetupTaskView.swift
//  SpeechToDoList
//
//  Created by Дмитрий on 19.08.2024.
//

import UIKit

protocol SetupButtonActionsProtocol: AnyObject {
    func saveButtonAction()
    func timeStackAction()
    func microphoneButtonAction()
    func isOnDatePickerSwitcherAction()
}

final class SetupTaskView: UIView {
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Properties
    
    private let priorityPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let datePickerView: DatePickerView = {
        let picker = DatePickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let isOnDatePickerSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = false
        switcher.onTintColor = .systemBlue
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    private let microStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Listening..."
        label.font = .systemFont(ofSize: 18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitle("Add Task", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let microphoneButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "mic.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Set Schedule"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let spacer: UILabel = {
        let label = UILabel()
        label.text = " "
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeImageView: UIImageView = {
        let timeImageView = UIImageView()
        timeImageView.image = UIImage(systemName: "clock")
        timeImageView.tintColor = .black
        timeImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        timeImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        timeImageView.translatesAutoresizingMaskIntoConstraints = false
        return timeImageView
    }()
    
    private let timeStackView: UIStackView = {
        let timeStackView = UIStackView()
        timeStackView.translatesAutoresizingMaskIntoConstraints = false
        timeStackView.axis = .horizontal
        timeStackView.spacing = 2
        timeStackView.layer.cornerRadius = 15
        timeStackView.layer.borderWidth = 1
        timeStackView.layer.borderColor = UIColor.black.cgColor
        return timeStackView
    }()
    
    private let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tv.textColor = .darkGray
        tv.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 30, right: 15)
        tv.layer.cornerRadius = 10
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.layer.borderWidth = 1
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private var isMicroActive = false {
        didSet {
            if isMicroActive {
                microphoneButton.setBackgroundImage(UIImage(systemName: "waveform.badge.mic"), for: .normal)
                microStatusLabel.isHidden = false
            } else {
                microphoneButton.setBackgroundImage(UIImage(systemName: "mic.fill"), for: .normal)
                microStatusLabel.isHidden = true
            }
        }
    }
    
    weak var setupButtonActionsDelegate: SetupButtonActionsProtocol?
    
    //MARK: - Functions
    
    private func setupViews() {
        backgroundColor = .white
        addSubview(saveButton)
        addSubview(microphoneButton)
        addSubview(timeStackView)
        addSubview(descriptionTextView)
        addSubview(priorityPicker)
        addSubview(datePickerView)
        addSubview(backgroundView)
        addSubview(microStatusLabel)
        addSubview(isOnDatePickerSwitcher)
        
        timeStackView.addArrangedSubview(timeImageView)
        timeStackView.addArrangedSubview(timeLabel)
        timeStackView.addArrangedSubview(spacer)
    }
    
    private func addActions() {
        saveButton.addTarget(self,
                             action: #selector(saveButtonAction),
                             for: .touchUpInside)
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(timeStackAction))
        timeStackView.addGestureRecognizer(gestureRecognizer)
        microphoneButton.addTarget(self,
                                   action: #selector(microphoneButtonAction),
                                   for: .touchUpInside)
        isOnDatePickerSwitcher.addTarget(self,
                                         action: #selector(isOnDatePickerSwitcherAction),
                                         for: .valueChanged)
    }
    
    @objc private func saveButtonAction() {
        setupButtonActionsDelegate?.saveButtonAction()
    }
    
    @objc private func timeStackAction() {
        setupButtonActionsDelegate?.timeStackAction()
    }
    
    @objc private func microphoneButtonAction() {
        setupButtonActionsDelegate?.microphoneButtonAction()
    }
    
    @objc private func isOnDatePickerSwitcherAction() {
        setupButtonActionsDelegate?.isOnDatePickerSwitcherAction()
    }
    
    func showDateTimePicker() {
        showBackgroundView()
        bringSubviewToFront(datePickerView)
        datePickerView.isHidden = false
    }
    
    func hideBackgroundView() {
        backgroundView.isHidden = true
    }
    
    func showBackgroundView() {
        backgroundView.isHidden = false
    }
    
    func getPickerSelectedRow(in component: Int) -> Int {
        priorityPicker.selectedRow(inComponent: component)
    }
    
    func setTaskDescription(text: String) {
        descriptionTextView.text = text
    }
    
    func getTaskDescription() -> String? {
        descriptionTextView.text
    }
    
    func setTimeLable(text: String) {
        timeLabel.text = text
    }
    
    func setPriorityPicker(delegate: UIPickerViewDelegate) {
        priorityPicker.delegate = delegate
    }
    
    func setPriorityPicker(dataSource: UIPickerViewDataSource) {
        priorityPicker.dataSource = dataSource
    }
    
    func setDatePickerView(delegate: DatePickerActionsProtocol) {
        datePickerView.datePickerActionDelegate = delegate
    }
    
    func setIsDateSwitchAppearence(with state: Bool) {
        timeStackView.isUserInteractionEnabled = state
        timeStackView.backgroundColor = state ? .clear : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        isOnDatePickerSwitcher.isOn = state
    }
    
    func selectPriorityPicker(row: Int) {
        priorityPicker.selectRow(row, inComponent: 0, animated: true)
    }
    
    func updateMicrophoneButton(enabled: Bool) {
        microphoneButton.isEnabled = enabled
    }
    
    func updateDatePicker(hidden: Bool) {
        datePickerView.isHidden = hidden
    }
    
    func updateMicroButton(isActive: Bool) {
        isMicroActive = isActive
    }
    
    func getSelectedDate() -> Date {
        datePickerView.getSelectedDate()
    }
}

//MARK: - setConstraints
private extension SetupTaskView {
    func setConstraints() {
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            
            microphoneButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 90),
            microphoneButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            microphoneButton.widthAnchor.constraint(equalToConstant: 40),
            microphoneButton.heightAnchor.constraint(equalToConstant: 47),
            
            descriptionTextView.topAnchor.constraint(equalTo: microphoneButton.bottomAnchor, constant: 70),
            descriptionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            descriptionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            descriptionTextView.bottomAnchor.constraint(equalTo: isOnDatePickerSwitcher.topAnchor, constant: -16),
            
            isOnDatePickerSwitcher.bottomAnchor.constraint(equalTo: priorityPicker.topAnchor, constant: -8),
            isOnDatePickerSwitcher.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 48),
            
            timeStackView.centerYAnchor.constraint(equalTo: isOnDatePickerSwitcher.centerYAnchor),
            timeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -48),
            
            priorityPicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            priorityPicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            priorityPicker.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -70),
            priorityPicker.heightAnchor.constraint(equalToConstant: 120),
            
            datePickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            datePickerView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20),
            datePickerView.widthAnchor.constraint(equalToConstant: 300),
            datePickerView.heightAnchor.constraint(equalToConstant: 400),
            
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            microStatusLabel.topAnchor.constraint(equalTo: microphoneButton.bottomAnchor, constant: 12),
            microStatusLabel.centerXAnchor.constraint(equalTo: microphoneButton.centerXAnchor)
        ])
    }
}
