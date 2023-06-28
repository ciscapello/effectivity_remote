//
//  MainViewModel.swift
//  Effectivity
//
//  Created by Владимир on 24.06.2023.
//

import Foundation
import RxCocoa

class MainViewModel: MainViewModelType {
    
    let tasks = TaskService.shared.tasks

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
