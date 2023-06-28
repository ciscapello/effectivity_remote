//
//  TaskDetailsViewModel.swift
//  Effectivity
//
//  Created by Владимир on 25.06.2023.
//

import Foundation
import RxRelay

class TaskDetailsViewModel: TaskDetailsViewModelType {
    
    var task: Task
    
    init(task: Task) {
        self.task = task
    }
    
    func deleteTask() {
        let tasks = TaskService.shared.tasks
//        let filteredTasks = tasks.value.filter { $0.id !== task.id }
//        tasks.accept(filteredTasks)
    }
}
