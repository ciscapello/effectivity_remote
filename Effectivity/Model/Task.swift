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
    @Persisted var createdAt: Date
    @Persisted var comments: List<Comment>
    
    convenience init(id: String = UUID().uuidString, title: String, text: String, priority: Priority, deadline: Date) {
        self.init()
        self.id = id
        self.title = title
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.createdAt = Date()
    }
    
    func priorityColor () -> UIColor {
        switch priority {
        case .urgently:
            return .systemRed
        case .nonUrgently:
            return .yellow
        case .usually:
            return .systemGreen
        }
    }
    
    func priorityLabel () -> String {
        switch priority {
        case .urgently:
            return "Срочная"
        case .nonUrgently:
            return "Несрочная"
        case .usually:
            return "Обычная"
        }
    }
}


enum Priority: Int, PersistableEnum {
    case urgently = 2
    case nonUrgently = 1
    case usually = 0
}

enum SortTasksBy {
    case newDesc
    case newAsc
    case urgentlyDesc
}
