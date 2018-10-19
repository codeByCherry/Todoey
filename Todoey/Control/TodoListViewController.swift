//
//  ViewController.swift
//  Todoey
//
//  Created by Tony Zhang on 2018/10/16.
//  Copyright © 2018年 SSM. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    var selectedCategory: Category? {
        didSet {
            self.loadItems()
            self.themeColor = UIColor(hexString: selectedCategory?.hexString)!
        }
    }
    
    var themeColor:UIColor!
    var items:Results<Item>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let naviBar = navigationController?.navigationBar else {
//            fatalError("has no bar!")
//        }

    }
    

    override func viewWillAppear(_ animated: Bool) {
//        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.red
        
        self.navigationController?.navigationBar.tintColor = themeColor
        self.title = selectedCategory?.name
    }
    
    // MARK:- TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let curItem = items?[indexPath.row] {
            cell.textLabel?.text = curItem.title
            cell.accessoryType = curItem.done ? .checkmark : .none
            cell.backgroundColor = UIColor(hexString: curItem.hexString)
        } else {
            cell.textLabel?.text = "None"
            cell.accessoryType = .none
        }
        
        // update cell color
        let percent = CGFloat(indexPath.row)/CGFloat(items?.count ?? 10) * 0.53
        let backgroundColor = themeColor.darken(byPercentage: percent)
        let constrastingColor = UIColor(contrastingBlackOrWhiteColorOn:backgroundColor!, isFlat:true)
        
        cell.backgroundColor = backgroundColor
        cell.textLabel?.textColor = constrastingColor
        cell.tintColor = constrastingColor
        
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
                curItem.hexString = UIColor.randomFlat()?.hexValue() ?? "#BB00BB"
                curCategory.items.append(curItem)
            }
        }
        tableView.reloadData()
    }
    
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending:true)
    }
    
    
    override func deleteModels(at indexPath: IndexPath) {
        if let curItem = items?[indexPath.row] {
            try! realm.write {
                realm.delete(curItem)
            }
        }
    }
    
}


// MARK:- search bar
extension TodoListViewController: UISearchBarDelegate {

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let inputTitle = searchBar.text {
            
            let inputTitle = inputTitle.trimmingCharacters(in: .whitespaces)
            if inputTitle.count == 0 {
                return
            }
            
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

