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
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Сначала новые", handler: { (_) in
            }),
            UIAction(title: "Сначала старые", handler: { (_) in
            }),
            UIAction(title: "Сначала срочные", handler: { (_) in
            }),
        ]
    }
    
    var showMenu: UIMenu {
        return UIMenu(title: "Сортировать", image: nil, identifier: nil, options: [], children: menuItems)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        title = "Список задач"
        tableView.backgroundColor = UIColor(red: 255/255, green: 250/255, blue: 215/255, alpha: 1.0)
        setupTableView()
        setupMenu()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
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
    
    func setupMenu() {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(navBarButtonTapped(sender:)))
        navigationItem.rightBarButtonItems = [addButton]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "list.bullet.indent"), primaryAction: nil, menu: showMenu)
        

    }

    
    override func setEditing(_ editing: Bool, animated: Bool) {
        // Takes care of toggling the button's title.
        super.setEditing(editing, animated: true)

        // Toggle table view editing.
        tableView.setEditing(editing, animated: true)
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
