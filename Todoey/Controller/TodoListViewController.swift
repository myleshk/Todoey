//
//  ViewController.swift
//  Todoey
//
//  Created by ZILU FANG on 30/8/2019.
//  Copyright © 2019 MYLES.HK. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var items : Results<TodoItem>?
    var realm: Realm?
    var category : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = items?.count {
            if count > 0 { return count }
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if items?.count == 0 {
            cell.textLabel?.text = "Start by adding an item"
            cell.textLabel?.textColor = .gray
            cell.accessoryType = .none
        } else {
            cell.textLabel?.textColor = .black
            
            let todoItem = items?[indexPath.row]
            cell.textLabel?.text = todoItem?.title
            if todoItem!.isDone {
                cell.accessoryType = .checkmark
                cell.textLabel?.textColor = UIColor.gray
            } else {
                cell.accessoryType = .none
                cell.textLabel?.textColor = UIColor.black
            }
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let todoItem = items?[indexPath.row] {
            do {
                try realm?.write {
                    todoItem.isDone = !todoItem.isDone
                }
            } catch {
                print(error)
            }
            
            tableView.reloadData()
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Todoey Item", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let textValue = (alert.textFields?[0].text)!
            
            if textValue.isEmpty {
                return
            }
            
            if self.category != nil {
                let newTodoItem = TodoItem()
                newTodoItem.title = textValue
                
                self.addTodoItem(todoItem: newTodoItem)
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new item."
        }
        
        alert.addAction(confirmAction)
        // add cancel action, too
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in })
        
        
        present(alert, animated: true, completion: nil)
    }
    
    func addTodoItem(todoItem: TodoItem) {
        do {
            try realm?.write {
                realm?.add(todoItem)
                category!.items.append(todoItem)
            }
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        items = category?.items.sorted(byKeyPath: "title", ascending: false)
        self.tableView.reloadData()
    }
}

//MARK: - Search Bar
extension TodoListViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            items = items?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "createdAt", ascending: true)
            self.tableView.reloadData()
        } // otherwise show all
        else {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
