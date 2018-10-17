//
//  ViewController.swift
//  Todoey
//
//  Created by Tony Zhang on 2018/10/16.
//  Copyright © 2018年 SSM. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    
    var tmpArr = [Item]()
    var itemArr:[Item] = [Item]()
    
    
    let defaults = UserDefaults.standard
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO:: 读取写入的items
        itemArr = loadItems()
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
        

        let curItem = Item(context: context)
        curItem.title = newItem ?? "no title"
        curItem.done = false
        itemArr.append(curItem)
        saveItems()
        let newIndexPath = IndexPath(item: self.itemArr.count-1, section: 0)
        self.tableView.insertRows(at: [newIndexPath], with:.fade)
    }
    
    
    func saveItems() {
        if context.hasChanges == false {
            return
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving context:\(error)")
        }
        
    }
    
    func loadItems(reqeust: NSFetchRequest<Item> = Item.fetchRequest()) -> [Item]{
        // 推荐下面的写法，更加OOP
        // let fr = NSFetchRequest<Item>(entityName:"Item")
        // let fr2:NSFetchRequest<Item> = Item.fetchRequest()
        
        var results = [Item]()
        do {
            results = try context.fetch(reqeust)

        } catch {
            print("load items error:\(error)")
        }
        return results
    }
    
    
    func deleteItem(atIndex index:NSInteger) {
        let curItem = itemArr[index]
        
        context.delete(curItem)
        itemArr.remove(at: index)
        
        saveItems()
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
        
        let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
        let title = title.trimmingCharacters(in: CharacterSet.whitespaces)
        if title.count == 0 {
            // FixBug:: 直接点删除操作，删除searchbar中内容后，键盘不缩回。
            DispatchQueue.main.async {
                self.searchBar.endEditing(true)
            }
        } else {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", title)
        }
        

        tmpArr = itemArr
        itemArr = loadItems(reqeust: fetchRequest)
        self.tableView.reloadData()
        
    }
    
}

