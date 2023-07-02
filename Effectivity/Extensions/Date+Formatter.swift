//
//  Date+Formatter.swift
//  Effectivity
//
//  Created by Владимир on 26.06.2023.
//

import UIKit

extension Date {
    func format (withTime: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        if Calendar.current.isDateInToday(self) {
            return "Сегодня \(withTime ? timeformatter.string(from: self) : "")"
        } else if Calendar.current.isDateInTomorrow(self) {
            return "Завтра  \(withTime ? timeformatter.string(from: self) : "")"
        } else if Calendar.current.isDateInYesterday(self) {
            return "Вчера  \(withTime ? timeformatter.string(from: self) : "" )"
        }
        if withTime {
            return formatter.string(from: self) + ", " + timeformatter.string(from: self)
        }
        return formatter.string(from: self)
    }
}
