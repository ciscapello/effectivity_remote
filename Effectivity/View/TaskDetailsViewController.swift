//
//  TaskDetailsViewController.swift
//  Effectivity
//
//  Created by Владимир on 25.06.2023.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

class TaskDetailsViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var viewModel: TaskDetailsViewModel? {
        didSet {
            self.taskTitle.text = viewModel?.task.title
            self.taskText.text = viewModel?.task.text
            self.dateText.text = viewModel?.task.deadline.format()
            self.priorityView.backgroundColor = viewModel?.task.priorityColor()
            self.priorityText.text = viewModel?.task.priorityLabel()
            if viewModel?.task.priority.rawValue != 1 {
                self.priorityText.textColor = .white
            }
        }
    }
    
    let taskTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.HelveticaNeueBold.rawValue, size: 24)
        label.numberOfLines = -1
        return label
    }()
    
    let taskText: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.HelveticaNeueLight.rawValue, size: 16)
        label.numberOfLines = -1
        return label
    }()
    
    let dateText: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.HelveticaNeueLight.rawValue, size: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let priorityText: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.HelveticaNeueBold.rawValue, size: 18)
        return label
    }()
    
    let priorityView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    let commentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 215/255, alpha: 1.0)
        tableView.sizeToFit()
        return tableView
    }()
    
    let emptyCommentsLabel: UILabel = {
        let label = UILabel()
        label.text = "Тут будут комментарии к задаче"
        label.textColor = .secondaryLabel
        label.font = UIFont(name: Fonts.HelveticaNeueLight.rawValue, size: 14)
        return label
    }()
    
    let commentsTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.HelveticaNeueBold.rawValue, size: 16)
        label.text = "Комментарии"
        return label
    }()
    
    let commentField: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(red: 215/255, green: 245/255, blue: 203/255, alpha: 1.0)
        textView.font = UIFont(name: Fonts.HelveticaNeue.rawValue, size: 16)
        textView.layer.cornerRadius = 8
        return textView
    }()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Комментарий"
        label.font = UIFont(name: Fonts.HelveticaNeue.rawValue, size: 16)
        label.sizeToFit()
        label.textColor = .placeholderText
        return label
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 0/255, green: 35/255, blue: 102/255, alpha: 1.0)
        button.layer.cornerRadius = 8
        button.addTarget(nil, action: #selector(addComment), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 215/255, alpha: 1.0)
        title = "Задача"
        view.addSubview(taskTitle)
        view.addSubview(taskText)
        view.addSubview(dateText)
        view.addSubview(priorityView)
        priorityView.addSubview(priorityText)
        view.addSubview(commentsTitle)
        view.addSubview(commentField)
        view.addSubview(sendButton)
        view.addSubview(commentsTableView)
        view.addSubview(emptyCommentsLabel)
        commentField.addSubview(placeholderLabel)
        setupLabel()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(trashTapped))
        commentsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        setupTableView()
        setupTextView()
        self.hideKeyboardWhenTappedAround()
        commentField.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func setupLabel () {
        taskTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        taskText.snp.makeConstraints { make in
            make.top.equalTo(taskTitle.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        dateText.snp.makeConstraints { make in
            make.top.equalTo(taskText.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(15)
        }
        
        priorityView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(dateText.snp.centerY)
            make.width.equalTo(120)
            make.height.equalTo(25)
        }
        
        priorityText.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setupTableView () {
        commentsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "commentCell")
        
        viewModel?.comments.subscribe(onNext: { comments in
            if comments.count == 0 {
                self.commentsTableView.isHidden = true
                self.emptyCommentsLabel.isHidden = false
            } else {
                self.commentsTableView.isHidden = false
                self.emptyCommentsLabel.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        viewModel?.comments.bind(to: commentsTableView.rx.items(cellIdentifier: "commentCell", cellType: UITableViewCell.self)) { index, elem, cell in
            var content = cell.defaultContentConfiguration()
            content.text = elem.text
            content.secondaryText = elem.createdAt.format(withTime: true)
            cell.contentConfiguration = content
            cell.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 215/255, alpha: 1.0)
        }.disposed(by: disposeBag)
        
        commentsTableView.rx.itemDeleted
            .subscribe(onNext: { event in
                let id = self.viewModel?.comments.value.first(where: { comment in
                    comment.id == self.viewModel?.comments.value[event.row].id
                })?.id
                if let id {
                    self.deleteComment(id: id)
                }
            })
            .disposed(by: disposeBag)
        
        commentsTableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(commentField.snp.bottom).offset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        
        emptyCommentsLabel.snp.makeConstraints { make in
            make.top.equalTo(commentField.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        commentsTitle.snp.makeConstraints { make in
            make.top.equalTo(priorityView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(15)
        }
    }
    
    func setupTextView () {
        commentField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(50)
            make.top.equalTo(commentsTitle.snp.bottom).offset(15)
        }
        
        placeholderLabel.isHidden = !commentField.text.isEmpty
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (commentField.font?.pointSize)! / 2)
        
        sendButton.snp.makeConstraints { make in
            make.left.equalTo(commentField.snp.right).offset(10)
            make.height.equalTo(commentField.snp.height)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(40)
            make.centerY.equalTo(commentField.snp.centerY)
        }
        
        commentField.rx.text.subscribe { event in
            if let text = event.element {
                if text!.isEmpty {
                    self.hideButton()
                } else {
                    self.showButton()
                }
            }
        }.disposed(by: disposeBag)
        
        commentField.rx.text.orEmpty.bind(to: viewModel!.commentField).disposed(by: disposeBag)
    }
    
    func hideButton() {
        UIView.animate(withDuration: 0.3) {
            self.sendButton.snp.updateConstraints { make in
                make.width.equalTo(0)
            }
            self.sendButton.alpha = 0
            self.sendButton.layoutIfNeeded()
        }
    }
    
    func showButton() {
        UIView.animate(withDuration: 0.3) {
            self.sendButton.snp.updateConstraints { make in
                make.width.equalTo(40)
            }
            self.sendButton.alpha = 1
            self.sendButton.layoutIfNeeded()
        }
    }
    
    @objc func addComment () {
        viewModel?.sendComment()
        commentField.text = ""
        placeholderLabel.isHidden = false
    }
    
    @objc func deleteComment (id: String) {
        viewModel?.deleteComment(id: id)
    }
    
    @objc func trashTapped () {
        guard let navigationController else { return }
        viewModel?.deleteTask(navigationController: navigationController)
    }
}


extension TaskDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        nil
    }
}

extension TaskDetailsViewController: UITextViewDelegate {
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


