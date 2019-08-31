//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by ZILU FANG on 31/8/2019.
//  Copyright © 2019 MYLES.HK. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewControllerTableViewController: UITableViewController {
    var categories : [Category] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories { (request) -> NSFetchRequest<Category> in request }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Todoey Category", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let textValue = (alert.textFields?[0].text)!
            
            if textValue.isEmpty {
                return
            }
            
            let newCategory = Category(context: self.context)
            newCategory.name = textValue
            
            self.categories.append(newCategory)
            
            self.saveCategories()
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
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        
        if category.items!.count > 0 {
            cell.accessoryType = .detailButton
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoListViewController
        let indexPath = tableView.indexPathForSelectedRow!
        destVC.category = categories[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    func saveCategories() {
        self.tableView.reloadData()
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func loadCategories(requestProvider: (_ request: NSFetchRequest<Category>)->NSFetchRequest<Category>) {
        let request : NSFetchRequest<Category> = requestProvider(Category.fetchRequest())
        // get data from core data
        do {
            categories = try context.fetch(request)
            self.tableView.reloadData()
        } catch {
            print(error)
        }
    }
}
