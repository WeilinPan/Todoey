//
//  ViewController.swift
//  Todoey
//
//  Created by APAN on 2019/11/27.
//  Copyright © 2019 APAN. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    // 當selectedCategory被賦予值時，didset{ }內的內容就會被實現
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            // Ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
//                    item.done = !item.done
                }
            } catch {
                print("Error saving done status")
            }
        }
        
        tableView.reloadData()
        
        // 點擊cell後會自動消除掉選取的灰色背景
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // 藉由textField的變數獲取使用者在alert中輸入的內容
        var textField = UITextField()
        // 產生一個alert
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        // 建立一個action
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            // selectedCagegory是optional所以使用optional binding處理
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        // 將textField內容加入到資料的陣列中
                        let newItem = Item()
                        newItem.title = textField.text!     // 由於表格也可以呈現空白，故直接用!
                        newItem.dateCreate = Date()     // 產生時間
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        // 建立alert的textfield
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        // 將action加入alert
        alert.addAction(action)
        // 將alert推出
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manupulation Methods
    
    // 等號用來表示如果未給參數，則使用等號後方的default value作為參數
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}
//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        // 此處不需再呼叫loadItems，因為點擊category時就先loadItems過
        
        tableView.reloadData()

    }

    // 當searchBar.text內容有更動時才會執行此方法
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()    // 讓游標離開searchBar並讓鍵盤消失
            }
        }
    }
}
