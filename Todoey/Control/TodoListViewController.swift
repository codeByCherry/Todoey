//
//  ViewController.swift
//  Todoey
//
//  Created by Tony Zhang on 2018/10/16.
//  Copyright © 2018年 SSM. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    var selectedCategory: Category? {
        didSet {
            self.loadItems()
        }
    }
    
    var items:Results<Item>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.red
    }
    
    // MARK:- TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        if let curItem = items?[indexPath.row] {
            cell.textLabel?.text = curItem.title
            cell.accessoryType = curItem.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "None"
            cell.accessoryType = .none
        }
        return cell
    }

    
    // MARK:- tableview delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        try! realm.write {
            if let selectItem = items?[indexPath.row] {
                selectItem.done = !selectItem.done
            }
        }
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Del"
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let curItem = selectedCategory!.items[indexPath.row]
            print("delete:", curItem.title)
            try! realm.write {
                realm.delete(curItem)
            }
            
            tableView.reloadData()
        }
        
    }
    
    
    // MARK:- Add new item.
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
 
        alert.addTextField { (textfield) in
            textfield.placeholder = "create new item"

        }
        

        let action = UIAlertAction(title: "add item?", style: .default) { (action) in
            // when user click add item button.
            print("action: add item")
            self.addNewItemAndUpdateView(alert.textFields?.first?.text)
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel) {(action) in
            print("action: cancel")
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func addNewItemAndUpdateView(_ newItem : String?) {
        

        if let curCategory = self.selectedCategory {
            try! realm.write {
                let curItem = Item()
                curItem.title = newItem ?? "no title"
                curItem.timeStamp = Date()
                curCategory.items.append(curItem)
            }
        }
        tableView.reloadData()
    }
    
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending:true)
    }
    
}


// MARK:- search bar
extension TodoListViewController: UISearchBarDelegate {

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let inputTitle = searchBar.text {
            searchItem(subTitle: inputTitle)
            self.tableView.reloadData()
        }
        searchBar.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchText = searchText.trimmingCharacters(in: .whitespaces)
        
        if searchText.count == 0 {
            loadItems()
        } else {
            searchItem(subTitle: searchText)
        }
        
        self.tableView.reloadData()
    }

    func searchItem(subTitle: String) {
        items = items?.filter(NSPredicate(format: "title CONTAINS[cd] %@", subTitle)).sorted(byKeyPath: "timeStamp", ascending: true)
    }
    
}

