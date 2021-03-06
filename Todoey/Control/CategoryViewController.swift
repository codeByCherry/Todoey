//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Tony Zhang on 2018/10/17.
//  Copyright © 2018年 SSM. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    

    var categories: Results<Category>?
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name
        let bgColor = UIColor(hexString: category?.hexString)
        cell.backgroundColor = bgColor
        
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:bgColor!, isFlat:true)
        
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
                category.hexString = UIColor.randomFlat()?.hexValue() ?? "#00bb00"
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
    
    
    override func deleteModels(at indexPath:IndexPath) {
        
        if let category = categories?[indexPath.row] {
            
            try! realm.write {
                realm.delete(category.items)
                realm.delete(category)
            }
            
        }
        // end if
        
    }
    
}


