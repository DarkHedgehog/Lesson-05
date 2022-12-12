//
//  ViewController.swift
//  Lesson-05
//
//  Created by Aleksandr Derevenskih on 12.12.2022.
//

import UIKit

class ViewController: UIViewController {
    private var rootTask = TaskItem(text: "root")

    override func viewDidLoad() {
        super.viewDidLoad()

        rootTask.subTasks.append(TaskItem(text: TaskHelper.shared.genName()))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rootTaskSegue" {
            guard let destination = segue.destination as? TaskTableViewController else { return }

            destination.configure(task: rootTask)
        }
    }
}
