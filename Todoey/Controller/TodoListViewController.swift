//
//  ViewController.swift
//  Todoey
//
//  Created by ZILU FANG on 30/8/2019.
//  Copyright © 2019 MYLES.HK. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var items : [TodoItem] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let todoItem = items[indexPath.row]
        cell.textLabel?.text = todoItem.title
        
        if todoItem.isDone {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
        } else {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isDone = !items[indexPath.row].isDone
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveItems()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Todoey Item", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let textValue = (alert.textFields?[0].text)!
            
            if textValue.isEmpty {
                return
            }
            
            let newTodoItem = TodoItem(context: self.context)
            newTodoItem.title = textValue
            
            self.items.append(newTodoItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new item."
        }
        
        alert.addAction(confirmAction)
        // add cancel action, too
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in })
        
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        self.tableView.reloadData()
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func loadItems() {
        // get data from core data
        let request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        do {
            items = try context.fetch(request)
        } catch {
            print(error)
        }
    }
}

