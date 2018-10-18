//
//  ViewController.swift
//  Todoey
//
//  Created by Tony Zhang on 2018/10/16.
//  Copyright © 2018年 SSM. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    var selectedCategory: Category? {
        didSet {
            //itemArr = self.loadItems()
        }
    }
    
    var tmpArr = [Item]()
    var itemArr:[Item] = [Item]()
    
    
    let defaults = UserDefaults.standard
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO:: 读取写入的items
        //itemArr = loadItems()
    }
    
    

    
    // MARK:- TableView DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        let curItem = itemArr[indexPath.row]
        
        cell.textLabel?.text = curItem.title
        cell.accessoryType = curItem.done ? .checkmark : .none
        return cell
    }

    
    // MARK:- tableview delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let curItem = itemArr[indexPath.row]
        
        curItem.done = !curItem.done
        saveItems()
        self.tableView.reloadRows(at: [indexPath], with: .fade)
        
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Del"
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteItem(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        
    }
    
    
    // MARK:- Add new item.
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
 
        alert.addTextField { (textfield) in
            textfield.placeholder = "create new item"

        }
        
        // change action item color
        //alert.view.tintColor = UIColor.green
        alert.tabBarController?.tabBar.backgroundColor = UIColor.red

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
        

        let curItem = Item()
        curItem.title = newItem ?? "no title"
        curItem.done = false
        //curItem.parentCategory = selectedCategory
        
        itemArr.append(curItem)
        saveItems()
        let newIndexPath = IndexPath(item: self.itemArr.count-1, section: 0)
        self.tableView.insertRows(at: [newIndexPath], with:.fade)
    }
    
    
    func saveItems() {

        
    }
    
    func loadItems() {
     
    }
    
    
    func deleteItem(atIndex index:NSInteger) {

    }
}


// MARK:- search bar
extension TodoListViewController: UISearchBarDelegate {

    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let inputTitle = searchBar.text {
            search(title: inputTitle)
        }
        searchBar.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search:'\(searchText)'")
        search(title: searchText)
    }
    
    func search(title: String) {
        
        self.tableView.reloadData()
        
    }
    
}

