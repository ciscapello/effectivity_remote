//
//  MainViewModel.swift
//  Effectivity
//
//  Created by Владимир on 24.06.2023.
//

import Foundation
import RxCocoa
import RxSwift
import RxRelay
import RealmSwift
import RxRealm

class MainViewModel: MainViewModelType {
    
    let tasks = BehaviorRelay<[Task]>(value: [])
    
    let realm = try! Realm()
    let disposeBag = DisposeBag()
    
    init () {
        let tasks = realm.objects(Task.self)
        
        self.tasks.accept(Array(tasks))
//        self.tasks = Observable.from(tasks)
        Observable.arrayWithChangeset(from: tasks).subscribe { array, changeset in
            self.tasks.accept(array)
//            print(changeset?.inserted)
        }.disposed(by: disposeBag)
        
        print(tasks)
//        self.tasks = Array(tasks)
    }

    func navigateToAddTask(navigationController: UINavigationController) {
        let addTaskVC = AddTaskViewController()
        navigationController.pushViewController(addTaskVC, animated: true)
    }
    
    func navigateToTaskDetails(navigationController: UINavigationController, with index: IndexPath) {
        let taskDetailsVC = TaskDetailsViewController()
        let task = tasks.value[index.row]
        taskDetailsVC.viewModel = TaskDetailsViewModel(task: task)
        navigationController.pushViewController(taskDetailsVC, animated: true)
    }
}
