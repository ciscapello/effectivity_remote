//
//  Comment.swift
//  Effectivity
//
//  Created by Владимир on 01.07.2023.
//

import Foundation
import RealmSwift

class Comment: EmbeddedObject {
    @Persisted var id: String
    @Persisted var text: String
    @Persisted var createdAt: Date
    
    convenience init(id: String = UUID().uuidString, text: String, createdAt: Date) {
        self.init()
        self.id = id
        self.text = text
        self.createdAt = createdAt
    }
}


