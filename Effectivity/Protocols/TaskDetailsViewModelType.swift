//
//  TaskDetailsViewModelType.swift
//  Effectivity
//
//  Created by Владимир on 25.06.2023.
//

import UIKit

protocol TaskDetailsViewModelType {
    var task: Task { get set }
    func deleteTask (navigationController: UINavigationController)
}
