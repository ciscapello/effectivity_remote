//
//  TaskService.swift
//  Effectivity
//
//  Created by Владимир on 26.06.2023.
//

import Foundation
import RxRelay

class TaskService {
    static let shared = TaskService()
    private init () {}
    let tasks = BehaviorRelay(value: [])
}
