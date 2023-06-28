//
//  MainViewModelType.swift
//  Effectivity
//
//  Created by Владимир on 25.06.2023.
//

import Foundation
import RxCocoa

protocol MainViewModelType {
    var tasks: BehaviorRelay<[Task]> { get }
    
    func navigateToAddTask(navigationController: UINavigationController)
    
    func navigateToTaskDetails(navigationController: UINavigationController, with index: IndexPath)
}
