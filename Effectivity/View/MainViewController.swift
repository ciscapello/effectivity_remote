//
//  ViewController.swift
//  Effectivity
//
//  Created by Владимир on 23.06.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxRelay
import RealmSwift

class MainViewController: UIViewController {
    
    let tableView = UITableView()
        
    let disposeBag = DisposeBag()
    
    private let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        title = "Список задач"
        tableView.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 215/255, alpha: 1.0)
        setupTableView()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить", style: .plain, target: self, action: #selector(navBarButtonTapped(sender:)))
        let realm = try! Realm()
        let dog = Dog()
        dog.name = "Шабакус"
        dog.age = 10
        try! realm.write {
            realm.add(dog)
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let dogs = realm.objects(Dog.self)
        let puppies = dogs.where {
            $0.age < 6
        }
        print(puppies)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.deselectSelectedRow(animated: true)
    }
    
    func setupTableView() {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        tableView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        viewModel.tasks.bind(to: tableView.rx.items(cellIdentifier: "tableViewCell", cellType: TableViewCell.self)) { index, element, cell in
            cell.viewModel = TableViewCellViewModel(task: self.viewModel.tasks.value[index])
        }.disposed(by: disposeBag)
    }
    
    @objc func navBarButtonTapped (sender: UIBarButtonItem) {
        guard let navigationController else { return }
        viewModel.navigateToAddTask(navigationController: navigationController)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navigationController else { return }

        viewModel.navigateToTaskDetails(navigationController: navigationController, with: indexPath)
    }
}
