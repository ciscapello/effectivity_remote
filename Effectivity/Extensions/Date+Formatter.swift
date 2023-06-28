//
//  Date+Formatter.swift
//  Effectivity
//
//  Created by Владимир on 26.06.2023.
//

import UIKit

extension Date {
    func format () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        if Calendar.current.isDateInToday(self) {
            return "Сегодня"
        } else if Calendar.current.isDateInTomorrow(self) {
            return "Завтра"
        }
        return formatter.string(from: self)
    }
}
