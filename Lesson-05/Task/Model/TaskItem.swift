//
//  Task.swift
//  Lesson-05
//
//  Created by Aleksandr Derevenskih on 12.12.2022.
//

import Foundation

class TaskItem {
    var text: String
    var subTasks: [TaskItem]

    init(text: String, subTasks: [TaskItem]? = nil) {
        self.text = text
        self.subTasks = subTasks ?? [TaskItem]()
    }
}
