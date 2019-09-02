//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by ZILU FANG on 31/8/2019.
//  Copyright © 2019 MYLES.HK. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewControllerTableViewController: UITableViewController {
    var categories : Results<Category>!
    var realm: Realm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        
        loadCategories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Todoey Category", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let textValue = (alert.textFields?[0].text)!
            
            if textValue.isEmpty {
                return
            }
            
            let newCategory = Category()
            newCategory.name = textValue
            
            self.addCategory(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category."
        }
        
        alert.addAction(confirmAction)
        // add cancel action, too
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in })
        
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Tableview
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = categories?.count {
            if count > 0 { return count }
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        if categories?.count == 0 {
            cell.textLabel?.text = "Start by adding a category"
            cell.textLabel?.textColor = .gray
        } else {
            cell.textLabel?.textColor = .black

            let category = categories?[indexPath.row]
            cell.textLabel?.text = category?.name
            if category?.items.count == 0 {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .disclosureIndicator
            }
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoListViewController
        let indexPath = tableView.indexPathForSelectedRow!
        destVC.category = categories?[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    func addCategory(category: Category) {
        do {
            try realm?.write {
                realm?.add(category)
            }
        } catch {
            print(error)
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm?.objects(Category.self)
        
        self.tableView.reloadData()
    }
}
