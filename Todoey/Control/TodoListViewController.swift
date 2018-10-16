//
//  ViewController.swift
//  Todoey
//
//  Created by Tony Zhang on 2018/10/16.
//  Copyright © 2018年 SSM. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArr:[Item] = [Item]()
    
    
    let defaults = UserDefaults.standard
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO:: 读取写入的items
        loadItems()
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
        itemArr.append(curItem)
        saveItems()
        let newIndexPath = IndexPath(item: self.itemArr.count-1, section: 0)
        self.tableView.insertRows(at: [newIndexPath], with:.fade)
    }
    
    
    // TODO:: 保存数据到本地磁盘
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArr)
            try data.write(to:filePath!)
            print("save to:", filePath!)
        } catch {
            print("保存items数据失败")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: filePath!) {
            do {
                let decoder = PropertyListDecoder()
                itemArr = try decoder.decode([Item].self, from: data)
            } catch {
                print("读取数据失败")
            }
        }
    }
}



