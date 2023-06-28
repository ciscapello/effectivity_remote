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
    
    init() {
        titleField.subscribe { string in
            if let elem = string.element {
                print(elem)
            }
        }.disposed(by: disposeBag)
        textField.subscribe { string in
            if let elem = string.element {
                print(elem)
            }
        }.disposed(by: disposeBag)
        priority.subscribe { int in
            if let elem = int.element {
                print(self.controlItems[elem])
            }
        }.disposed(by: disposeBag)
    }
    
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
        let tasks = TaskService.shared.tasks
        guard let date = date.value else { return }
        let task = Task(title: titleField.value, text: textField.value, priority: Priority(rawValue: priority.value)!, deadline: date)
        try! realm.write {
            realm.add(task)
        }
        navigationController.popViewController(animated: true)
    }
}
