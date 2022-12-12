//
//  TaskHelper.swift
//  Lesson-05
//
//  Created by Aleksandr Derevenskih on 12.12.2022.
//

import Foundation

class TaskHelper {
    static let shared = TaskHelper()

    var id = 0

    func genName() -> String {
        id += 1
        return "Task: \(id)"
    }

    private init() {
    }
}
