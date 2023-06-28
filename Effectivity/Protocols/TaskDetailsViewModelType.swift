//
//  TaskDetailsViewModelType.swift
//  Effectivity
//
//  Created by Владимир on 25.06.2023.
//

import Foundation

protocol TaskDetailsViewModelType {
    var task: Task { get set }
    func deleteTask ()
}
