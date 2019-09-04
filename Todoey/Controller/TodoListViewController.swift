//
//  ViewController.swift
//  Todoey
//
//  Created by ZILU FANG on 30/8/2019.
//  Copyright © 2019 MYLES.HK. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var items : Results<TodoItem>?
    var realm: Realm?
    var category : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let themeColor = UIColor(hexString: category!.colorHex) {
            searchBar?.barTintColor = themeColor
            
            navigationController?.navigationBar.barTintColor = themeColor
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: ContrastColorOf(themeColor, returnFlat: true)
                
            ]
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        let themeColor = UIColor.flatLimeDark
        navigationController?.navigationBar.barTintColor = themeColor
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: ContrastColorOf(themeColor, returnFlat: true)
        ]
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if items?.count == 0 {
            cell.textLabel?.text = "Start by adding an item"
            cell.textLabel?.textColor = .gray
            cell.accessoryType = .none
        } else {
            let rowNo = CGFloat(indexPath.row)
            let numOfRows = CGFloat(items!.count)
            let colorLevel = (rowNo+0.5-numOfRows/2.0) / numOfRows
            var bgColor = UIColor(hexString: category!.colorHex)
            if colorLevel > 0 {
                bgColor = bgColor?.darken(byPercentage: colorLevel)
            } else if colorLevel < 0 {
                bgColor = bgColor?.lighten(byPercentage: -colorLevel)
            }
            cell.backgroundColor = bgColor
            cell.textLabel?.textColor = ContrastColorOf(bgColor!, returnFlat: true)
            
            let todoItem = items![indexPath.row]
            let rawTitle = todoItem.title
            if todoItem.isDone {
                cell.accessoryType = .checkmark
                
                
                let attributeTitle = NSMutableAttributedString(string: rawTitle)
                attributeTitle.addAttribute(
                    NSAttributedString.Key.strikethroughStyle,
                    value: 1,
                    range: NSRange(location: 0, length: attributeTitle.length)
                )
                cell.textLabel?.text = nil
                cell.textLabel?.attributedText = attributeTitle
            } else {
                cell.accessoryType = .none
                cell.textLabel?.attributedText = nil
                cell.textLabel?.text = rawTitle
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
    
    override func deleteData(at indexPath: IndexPath) {
        if let itemToDelete = self.items?[indexPath.row] {
            do {
                try self.realm?.write {
                    self.realm?.delete(itemToDelete)
                }
            } catch {
                print(error)
            }
        }
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
