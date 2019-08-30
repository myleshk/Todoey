//
//  ViewController.swift
//  Todoey
//
//  Created by ZILU FANG on 30/8/2019.
//  Copyright © 2019 MYLES.HK. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var items = [
        "Find Jack",
        "Fuck Dinosaur",
        "Follow Bugs"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
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
            
            self.items.append(textValue)
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new item."
        }
        
        alert.addAction(confirmAction)
        // add cancel action, too
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in })
        
        
        present(alert, animated: true, completion: nil)
    }
}

