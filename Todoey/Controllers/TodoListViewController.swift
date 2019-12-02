//
//  ViewController.swift
//  Todoey
//
//  Created by APAN on 2019/11/27.
//  Copyright © 2019 APAN. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    // 當selectedCategory被賦予值時，didset{ }內的內容就會被實現
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        // Ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
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
            // 將textField內容加入到資料的陣列中
            let newItem = Item(context: self.context)
            newItem.title = textField.text!     // 由於表格也可以呈現空白，故直接用!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory  // 指定新增的item的category為點擊的category
            self.itemArray.append(newItem)
            self.saveItems()
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
    func saveItems() {

        do {
            try context.save()      // 將資料儲存在persistentContainer
        } catch {
            print("Error saving context, \(error)")
        }
        // 重新讀取tableView否則會無法將新的資料顯示在table view上
        tableView.reloadData()
    }
    
    // 等號用來表示如果未給參數，則使用等號後方的default value作為參數
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
}
//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        // 依據設定的條件進行搜索
        // %@代表傳入的值;c代表大小寫;d代表變音符號
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        // 排列出搜索的值
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
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
