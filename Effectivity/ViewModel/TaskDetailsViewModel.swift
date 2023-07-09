//
//  TaskDetailsViewModel.swift
//  Effectivity
//
//  Created by Владимир on 25.06.2023.
//

import Foundation
import RxRelay
import RealmSwift
import UIKit
import RxSwift
import RxRealm

class TaskDetailsViewModel: TaskDetailsViewModelType {
    
    let disposeBag = DisposeBag()
    
    var task: Task
    
    let commentField = BehaviorRelay(value: "")
    
    var comments = BehaviorRelay<[Comment]>(value: [])
        
    let realm = try! Realm()
        
    init(task: Task) {
        self.task = task
        let sameTask = realm.objects(Task.self).where { res in
            res.id == task.id
        }.first!
        
        Observable.arrayWithChangeset(from: sameTask.comments).subscribe { array, changeset in
            self.comments.accept(array.sorted(by: { first, second in
                first.createdAt > second.createdAt
            }))
        }.disposed(by: disposeBag)
    }
    
    func deleteTask(navigationController: UINavigationController) {
        try! realm.write {
            let object = realm.objects(Task.self).where { task in
                task.id == self.task.id
            }
            realm.delete(object)
        }
        navigationController.popViewController(animated: true)
    }
    
    func sendComment () {
        guard !commentField.value.isEmpty else { return }
        let comment = Comment(text: commentField.value, createdAt: Date())
        print(comment.text)
        try! realm.write {
            task.comments.append(comment)
        }
        commentField.accept("")
    }
    
    func deleteComment (id: String) {
        let comment = realm.objects(Task.self).where { task in
            task.id == self.task.id
        }[0].comments.where { comment in
            comment.id == id
        }[0]
        try! realm.write {
            realm.delete(comment)
        }
    }
}
