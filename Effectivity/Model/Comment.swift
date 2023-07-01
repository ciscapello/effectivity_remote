//
//  Comment.swift
//  Effectivity
//
//  Created by Владимир on 01.07.2023.
//

import Foundation
import RealmSwift

class Comment: EmbeddedObject {
    @Persisted var text: String
    @Persisted var createdAt: Date
    
    convenience init(text: String, createdAt: Date) {
        self.init()
        self.text = text
        self.createdAt = createdAt
    }
}


