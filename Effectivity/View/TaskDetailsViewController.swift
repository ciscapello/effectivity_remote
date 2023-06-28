//
//  TaskDetailsViewController.swift
//  Effectivity
//
//  Created by Владимир on 25.06.2023.
//

import UIKit

class TaskDetailsViewController: UIViewController {
    
    var viewModel: TaskDetailsViewModel? {
        didSet {
            self.taskTitle.text = viewModel?.task.title
            self.taskText.text = viewModel?.task.text
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 215/255, alpha: 1.0)
        title = "Задача"
        view.addSubview(taskTitle)
        view.addSubview(taskText)
        setupLabel()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(trashTapped))
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
    }
    
    @objc func trashTapped () {
        print("Asdasdsa")
    }
}
