//
//  TaskDetailsViewModel.swift
//  Effectivity
//
//  Created by Владимир on 25.06.2023.
//

import Foundation
import RxRelay
import RealmSwift
import UIKit

class TaskDetailsViewModel: TaskDetailsViewModelType {
    
    var task: Task
    
    let realm = try! Realm()
    
    init(task: Task) {
        self.task = task
    }
    
    func deleteTask(navigationController: UINavigationController) {
        print(task.id)
        try! realm.write {
            let object = realm.objects(Task.self).where { task in
                task.id == self.task.id
            }
            realm.delete(object)
        }
        navigationController.popViewController(animated: true)
//        let tasks = TaskService.shared.tasks
//        let filteredTasks = tasks.value.filter { $0.id !== task.id }
//        tasks.accept(filteredTasks)
    }
}
