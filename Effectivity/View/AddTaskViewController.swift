//
//  AddTaskViewController.swift
//  Effectivity
//
//  Created by Владимир on 25.06.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RealmSwift

class AddTaskViewController: UIViewController {
    
    private let viewModel = AddTaskViewModel()
    
    let disposeBag = DisposeBag()    
    
    let titleField: UITextField = {
        let field = UITextField()
        field.placeholder = "Заголовок задачи"
        field.font = UIFont(name: Fonts.HelveticaNeue.rawValue, size: 16)
        field.backgroundColor = UIColor(red: 215/255, green: 245/255, blue: 203/255, alpha: 1.0)
        field.setLeftPaddingPoints(4)
        field.layer.cornerRadius = 8
        return field
    }()
    
    let textField: UITextView = {
        let field = UITextView()
        field.backgroundColor = UIColor(red: 215/255, green: 245/255, blue: 203/255, alpha: 1.0)
        field.font = UIFont(name: Fonts.HelveticaNeue.rawValue, size: 16)
        field.layer.cornerRadius = 8
        return field
    }()
    
    let placeholderLabel: UILabel = {
       let label = UILabel()
        label.text = "Описание задачи"
        label.font = UIFont(name: Fonts.HelveticaNeue.rawValue, size: 16)
        label.sizeToFit()
        label.textColor = .placeholderText
        return label
    }()
    
    let control: UISegmentedControl = {
        let items = ["Несрочная", "Обычная", "Срочная"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 1
        return control
    }()
    
    let dateField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Выберите дату и время"
        textField.font = UIFont(name: Fonts.HelveticaNeue.rawValue, size: 16)
        textField.layer.cornerRadius = 8
        textField.backgroundColor = UIColor(red: 215/255, green: 245/255, blue: 203/255, alpha: 1.0)
        textField.setLeftPaddingPoints(4)
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.minimumDate = Date()
        datePicker.minuteInterval = 5
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(nil, action: #selector(setDate), for: .valueChanged)
        return datePicker
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 120/255, green: 145/255, blue: 158/255, alpha: 1.0)
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.HelveticaNeueMedium.rawValue, size: 18)
        button.addTarget(nil, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 215/255, alpha: 1.0)
        title = "Добавить"
        view.addSubview(titleField)
        view.addSubview(textField)
        view.addSubview(control)
        view.addSubview(dateField)
        view.addSubview(saveButton)
        dateField.inputView = datePicker
        self.hideKeyboardWhenTappedAround()
        textField.addSubview(placeholderLabel)
        textField.rx.setDelegate(self).disposed(by: disposeBag)
        setupFields()
    }
    
    func setupFields () {
        titleField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.height.equalTo(40)
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(titleField.snp.bottom).offset(20)
            make.height.equalTo(100)
        }
        
        placeholderLabel.isHidden = !textField.text.isEmpty
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textField.font?.pointSize)! / 2)
        
        control.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        dateField.snp.makeConstraints { make in
            make.top.equalTo(control.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(dateField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        titleField.rx.text.orEmpty.bind(to: viewModel.titleField).disposed(by: disposeBag)
        textField.rx.text.orEmpty.bind(to: viewModel.textField).disposed(by: disposeBag)
        control.rx.value.bind(to: viewModel.priority).disposed(by: disposeBag)
        
        viewModel.isValid().bind(to: saveButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel.isValid().subscribe { event in
            guard let element = event.element else { return }
            if element {
                UIView.animate(withDuration: 0.3) {
                    self.saveButton.backgroundColor = UIColor(red: 0/255, green: 35/255, blue: 102/255, alpha: 1.0)
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.saveButton.backgroundColor = UIColor(red: 120/255, green: 145/255, blue: 158/255, alpha: 1.0)
                }
            }
        }.disposed(by: disposeBag)
    }
    
    @objc func setDate (sender: UIDatePicker) {
        dateField.text = datePicker.date.format()
        viewModel.date.accept(datePicker.date)
    }
    
    @objc func saveButtonPressed () {
        guard let navigationController else { return }
        viewModel.saveTask(navigationController: navigationController)
    }
}

extension AddTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
}
