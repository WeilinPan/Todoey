//
//  ViewController.swift
//  Todoey
//
//  Created by APAN on 2019/11/27.
//  Copyright © 2019 APAN. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy eggs", "Destory Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 點擊cell後右方顯示打勾，若該欄已打勾則取消打勾
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
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
            self.itemArray.append(textField.text!)      // 由於表格也可以呈現空白，故直接用!
            // 重新讀取tableView否則會無法將新的資料顯示在table view上
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
}

