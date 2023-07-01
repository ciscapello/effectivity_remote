//
//  TaskDetailsViewModelType.swift
//  Effectivity
//
//  Created by Владимир on 25.06.2023.
//

import UIKit
import RxRelay

protocol TaskDetailsViewModelType {
    var task: Task { get set }
    func deleteTask (navigationController: UINavigationController)
    var comments: BehaviorRelay<[Comment]> { get }
    var commentField: BehaviorRelay<String> { get }
    
}
