//
//  ViewController.swift
//  MVVMBindings
//
//  Created by Sanghun Park on 20.09.22.
//

import UIKit

// MARK: - Observable

class Observable<T> {
    var value: T? {
        didSet {
            listeners.forEach {
                $0(value)
            }
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    private var listeners: [((T?) -> Void)] = []
    
    func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listeners.append(listener)
    }
}

// MARK: - Model

struct User: Codable {
    let name: String
}

// MARK: - ViewModels

struct UserTableViewCellViewModel {
    let name: String
}

struct UserListViewModel {
    var users: Observable<[UserTableViewCellViewModel]> = Observable([])
}

// MARK: - Controller

class ViewController: UIViewController, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private var viewModel = UserListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        
        viewModel.users.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        fetchData()
    }
    
    // MARK: Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.users.value?[indexPath.row].name
        return cell
    }

    func fetchData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let userModels = try JSONDecoder().decode([User].self, from: data)
                
                self.viewModel.users.value = userModels.compactMap({
                    UserTableViewCellViewModel(name: $0.name)
                })
            }
            catch {
                
            }
        }
        
        task.resume()
    }

}

