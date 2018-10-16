//
//  ViewController.swift
//  Todoey
//
//  Created by Tony Zhang on 2018/10/16.
//  Copyright © 2018年 SSM. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let todoArray:[String] = ["Find Milk", "Get Egg", "Write Log"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK- TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell")
        cell?.textLabel?.text = todoArray[indexPath.row]
        return cell!
    }


}

