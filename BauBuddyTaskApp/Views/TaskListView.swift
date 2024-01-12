//
//  TaskListView.swift
//  BauBuddyTaskApp
//
//  Created by EZGİ KARABAY on 8.01.2024.
//

import UIKit
import SwiftHEXColors

class TaskListView: UIViewController {

    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var auth: Auth?
    var viewModel = TaskViewModel()
    var filteredTasks: [Task] = []
    var refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        taskTableView.dataSource = self
        taskTableView.delegate = self
        searchBar.delegate = self
        
        
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        taskTableView.addSubview(refreshControl)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        
        
        
        if let auth = auth {
            fetchTasks(auth: auth)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func refreshData(_ sender: Any) {
        if let auth = auth {
            fetchTasks(auth: auth)
        }
    }
    
    private func fetchTasks(auth: Auth) {
        viewModel.fetchTasks(auth: auth) { [weak self] result in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                switch result {
                case .success(let tasks):
                    self?.filteredTasks = tasks
                    self?.taskTableView.reloadData()
                case .failure(let error):
                    print("Error fetching tasks: \(error)")
                }
            }
        }
    }
}


// MARK: - UITableView DataSource & Delegate
extension TaskListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else {
            fatalError("TaskCell not found")
        }
        
        let task = filteredTasks[indexPath.row]
        cell.configure(with: task)
        
        return cell
    }
}


// MARK: - UISearchBarDelegate
extension TaskListView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredTasks = viewModel.tasks
        } else {
            filteredTasks = viewModel.tasks.filter { task in
                return (task.title?.contains(searchText) ?? false) ||
                (task.description?.contains(searchText) ?? false) ||
                (task.businessUnit?.contains(searchText) ?? false) ||
                (task.task?.contains(searchText) ?? false) ||
                (task.colorCode?.contains(searchText) ?? false) ||
                (task.businessUnitKey?.contains(searchText) ?? false) ||
                (task.wageType?.contains(searchText) ?? false) ||
                (task.sort?.contains(searchText) ?? false) ||
                (task.parentTaskID?.contains(searchText) ?? false) ||
                (task.preplanningBoardQuickSelect?.contains(searchText) ?? false) ||
                (task.workingTime?.contains(searchText) ?? false) ||
                (task.isAvailableInTimeTrackingKioskMode.description.contains(searchText))
            }
        }
        taskTableView.reloadData()
    }
}
