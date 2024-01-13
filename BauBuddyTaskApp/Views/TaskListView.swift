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
        
        
        if let auth = self.auth {
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
        filterTasks(with: searchText)
        taskTableView.reloadData()
    }
    
    private func filterTasks(with searchText: String) {
        if searchText.isEmpty {
            filteredTasks = viewModel.tasks
        } else {
            filteredTasks = viewModel.tasks.filter { taskContainsSearchText($0, searchText) }
        }
    }
    
    private func taskContainsSearchText(_ task: Task, _ searchText: String) -> Bool {
        return (task.title?.lowercased().contains(searchText.lowercased()) ?? false) ||
        (task.description?.lowercased().contains(searchText.lowercased()) ?? false) ||
        (task.businessUnit?.lowercased().contains(searchText.lowercased()) ?? false) ||
        (task.task?.lowercased().contains(searchText.lowercased()) ?? false) ||
        (task.colorCode?.lowercased().contains(searchText.lowercased()) ?? false) ||
        (task.businessUnitKey?.lowercased().contains(searchText.lowercased()) ?? false) ||
        (task.wageType?.lowercased().contains(searchText.lowercased()) ?? false) ||
        (task.sort?.lowercased().contains(searchText.lowercased()) ?? false) ||
        (task.parentTaskID?.lowercased().contains(searchText.lowercased()) ?? false) ||
        (task.preplanningBoardQuickSelect?.lowercased().contains(searchText.lowercased()) ?? false) ||
        (task.workingTime?.lowercased().contains(searchText.lowercased()) ?? false) ||
        (task.isAvailableInTimeTrackingKioskMode.description.contains(searchText))
    }
}

