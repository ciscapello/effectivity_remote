//
//  TaskModel.swift
//  Effectivity
//
//  Created by Владимир on 24.06.2023.
//

import Foundation
import UIKit
import RealmSwift

class Dog: Object {
    @Persisted var name: String
    @Persisted var age: Int
}

class Task: Object {
    @Persisted var id = UUID().uuidString
    @Persisted var title: String
    @Persisted var text: String
    @Persisted var priority: Priority
    @Persisted var deadline: Date
    
    convenience init(id: String = UUID().uuidString, title: String, text: String, priority: Priority, deadline: Date) {
        self.init()
        self.id = id
        self.title = title
        self.text = text
        self.priority = priority
        self.deadline = deadline
    }
    
    func priorityColor () -> UIColor {
        switch priority {
        case .urgently:
            return UIColor(red: 245/255, green: 66/255, blue: 87/255, alpha: 1.0)
        case .nonUrgently:
            return UIColor(red: 19/255, green: 214/255, blue: 100/255, alpha: 1.0)
        case .usually:
            return UIColor(red: 227/255, green: 245/255, blue: 66/255, alpha: 1.0)
        }
    }
}

//struct Task {
//    let id = UUID().uuidString
//    let title: String
//    let text: String
//    let priority: Priority
//    let deadline: Date
//
//    func priorityColor () -> UIColor {
//        switch priority {
//        case .urgently:
//            return UIColor(red: 245/255, green: 66/255, blue: 87/255, alpha: 1.0)
//        case .nonUrgently:
//            return UIColor(red: 19/255, green: 214/255, blue: 100/255, alpha: 1.0)
//        case .usually:
//            return UIColor(red: 227/255, green: 245/255, blue: 66/255, alpha: 1.0)
//        }
//    }
//}

//enum Priority {
//    case urgently, nonUrgently, usually
//}

enum Priority: Int, PersistableEnum {
    case urgently = 0
    case nonUrgently = 1
    case usually = 2
}


let mockTasks = [
    Task(title: "Создать свою первую задачу", text: "Чтобы начать использовать приложение в полной мере необходимо создать первую задачу", priority: .urgently, deadline: Date()),
]
