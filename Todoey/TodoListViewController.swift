//
//  ViewController.swift
//  Todoey
//
//  Created by Tony Zhang on 2018/10/16.
//  Copyright © 2018年 SSM. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArr:[String] = ["Find Milk", "Get Egg", "Write Log"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        cell.textLabel?.text = itemArr[indexPath.row]
        
        return cell
    }

    
    // MARK:- tableview delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
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
        let action = UIAlertAction(title: "add item?", style: .default) { (action) in
            // when user click add item button.
            print("action: add item")
            print(alert.textFields?.first?.text as Any)
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel) {(action) in
            print("action: cancel")
            
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
}

