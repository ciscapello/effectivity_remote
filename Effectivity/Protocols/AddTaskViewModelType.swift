//
//  AddTaskViewModelType.swift
//  Effectivity
//
//  Created by Владимир on 25.06.2023.
//

import Foundation
import RxRelay
import UIKit

protocol AddTaskViewModelType {
    var titleField: BehaviorRelay<String> { get }
    var textField: BehaviorRelay<String> { get }
    var priority: BehaviorRelay<Int> { get }
    var controlItems: [String] { get }
    var date: BehaviorRelay<Date?> { get }
    func saveTask (navigationController: UINavigationController)
}
