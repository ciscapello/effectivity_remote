//
//  AddTaskViewModel.swift
//  Effectivity
//
//  Created by Владимир on 25.06.2023.
//

import Foundation
import RxRelay
import RxSwift
import RealmSwift

class AddTaskViewModel: AddTaskViewModelType {
    
//    var priority: RxRelay.BehaviorRelay<Priority>

    let titleField = BehaviorRelay(value: "")
    let textField = BehaviorRelay(value: "")
    let priority = BehaviorRelay(value: 1)
    var date = BehaviorRelay<Date?>(value: nil)
    
    let controlItems = ["Несрочная", "Обычная", "Срочная"]
    
    let disposeBag = DisposeBag()
    let realm = try! Realm()
        
    func returnPriority (index: Int) -> Priority {
        switch index {
        case 0: return Priority.nonUrgently
        case 1: return Priority.usually
        case 2: return Priority.urgently
        default:
            return Priority.usually
        }
    }
    
    func isValid () -> Observable<Bool> {
        return Observable.combineLatest(titleField, textField, date, resultSelector: { title, text, date in
            return !title.isEmpty && !text.isEmpty && date != nil
        })
    }
    
    func saveTask(navigationController: UINavigationController) {
        guard let date = date.value else { return }
        print(priority.value)
        let task = Task(title: titleField.value, text: textField.value, priority: Priority(rawValue: priority.value)!, deadline: date)
        try! realm.write {
            realm.add(task)
        }
        navigationController.popViewController(animated: true)
    }
}
