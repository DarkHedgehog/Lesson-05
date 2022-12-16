//
//  TaskTableViewController.swift
//  Lesson-05
//
//  Created by Aleksandr Derevenskih on 12.12.2022.
//

import UIKit

class TaskTableViewController: UITableViewController {

    private var task: TaskItem?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func configure(task: TaskItem) {
        self.task = task
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task?.subTasks.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let subTask = task?.subTasks[indexPath.row] else {
            preconditionFailure("Cant prepare cell")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskItemCell", for: indexPath)
        cell.textLabel?.text = subTask.text
        cell.detailTextLabel?.text = "\(subTask.subTasks.count)"

        return cell
    }

    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedTask = task?.subTasks[indexPath.row],
              let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: "TaskTableViewController")
                as? TaskTableViewController else {
            return
        }

        viewController.configure(task: selectedTask)
        self.navigationController?.pushViewController(viewController, animated: true)
    }


    // MARK: - IBAction
    @IBAction func taskAdd(_ sender: Any) {
        task?.subTasks.append(TaskItem(text: TaskHelper.shared.genName()))
        tableView.reloadData()
    }
}
