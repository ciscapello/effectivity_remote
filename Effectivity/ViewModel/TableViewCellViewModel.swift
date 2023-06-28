//
//  TableViewCellViewModel.swift
//  Effectivity
//
//  Created by Владимир on 24.06.2023.
//

import Foundation

class TableViewCellViewModel: TableViewCellViewModelType {
    var task: Task?
    
    init(task: Task) {
        self.task = task
    }
    
}
