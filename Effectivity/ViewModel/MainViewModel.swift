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
    
    let sortTasksBy = BehaviorRelay(value: SortTasksBy.newDesc)
    
    let realm = try! Realm()
    let disposeBag = DisposeBag()
    
    init () {
        let tasks = realm.objects(Task.self).sorted(byKeyPath: "priority", ascending: false)
        Observable.arrayWithChangeset(from: tasks).subscribe { array, changeset in
            self.tasks.accept(array)
        }.disposed(by: disposeBag)
        
        sortTasksBy.subscribe { sortTaskBy in
            guard let sort = sortTaskBy.element else { return }
            print(sort)
            switch sort {
            case .newDesc: self.tasks.accept(Array(self.realm.objects(Task.self).sorted(byKeyPath: "createdAt", ascending: false)))
            case .newAsc: self.tasks.accept(Array(self.realm.objects(Task.self).sorted(byKeyPath: "createdAt", ascending: true)))
            default: self.tasks.accept(Array(self.realm.objects(Task.self).sorted(byKeyPath: "priority", ascending: false)))
            }
        }.disposed(by: disposeBag)
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
    
    func changeSortMethod (_ sortBy: SortTasksBy) {
        print(sortBy)
        sortTasksBy.accept(sortBy)
    }
}
