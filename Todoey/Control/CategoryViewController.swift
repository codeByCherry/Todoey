//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Tony Zhang on 2018/10/17.
//  Copyright © 2018年 SSM. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit


class CategoryViewController: UITableViewController {

    

    var categories: Results<Category>?
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        loadCategories()
        
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectedCategory = categories?[indexPath.row] {
            performSegue(withIdentifier: "ShowItems", sender: selectedCategory)
        } else {
            print("No categories")
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let todoVC = segue.destination as! TodoListViewController
        todoVC.selectedCategory = (sender as! Category)
    }
    
    
    func loadCategories(){
        categories =  realm.objects(Category.self).sorted(byKeyPath: "name", ascending: true)
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
                let inputName = inputName.trimmingCharacters(in: .whitespaces)
                if inputName.count == 0 {
                    //TODO:: prompt input something to store.
                    return
                }
                
                let category = Category()
                category.name = inputName
                self.saveNewCategory(category)
                self.tableView.reloadData()
            }
            
        }
        
        alert.addAction(cancel)
        alert.addAction(add)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if categories?.count ?? 0 > 0 {
            return nil
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            return view
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    func saveNewCategory(_ category:Category) {
        try! realm.write {
            realm.add(category)
        }
    }
    
    
    func deleteCategory(_ category:Category, at indexPath:IndexPath?=nil) {
        try! realm.write {
            realm.delete(category.items)
            realm.delete(category)
        }
    }
    
}


// MARK:- swipe cell delegate methods
extension CategoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            // handle action by updating model with deletion
            let selectedCategory = self.categories![indexPath.row]
            self.deleteCategory(selectedCategory)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    
}
