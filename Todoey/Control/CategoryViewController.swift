//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Tony Zhang on 2018/10/17.
//  Copyright © 2018年 SSM. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = loadCategories()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curCategory = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = curCategory.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "DEL"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let curCategory = categories[indexPath.row]
            categories.remove(at: indexPath.row)
            context.delete(curCategory)
            saveContext()
            
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCategory = categories[indexPath.row]
        performSegue(withIdentifier: "ShowItems", sender: selectedCategory)
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let todoVC = segue.destination as! TodoListViewController
        todoVC.selectedCategory = (sender as! Category)
    }
    
    
    func loadCategories() -> [Category] {
        let fr:NSFetchRequest<Category> = Category.fetchRequest()
        var categories = [Category]()
        do {
             categories = try context.fetch(fr)
        } catch {
            print("load categories error:\(error)")
        }
        
        return categories
    }
    
    
    
    @IBAction func addCategoryPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Category", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "add new category"
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        let add = UIAlertAction(title: "add", style: .default) { (action) in
            let textfiele = alert.textFields?.first!
            if let inputName = textfiele?.text {
                self.saveNewCategory(name: inputName)
            }
            
        }
        
        alert.addAction(cancel)
        alert.addAction(add)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func saveNewCategory(name:String) {
        let name = name.trimmingCharacters(in: .whitespaces)
        if name.count == 0 {
            return
        }
        
        let category = Category(context: context)
        category.name = name
        
        categories.append(category)
        saveContext()
        
        let indexPath = IndexPath(row: categories.count-1, section: 0)
        self.tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        
    }
    
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("save category error:\(error)")
        }
    }
}
