//
//  TodoListViewController.swift
//  Todeey
//
//  Created by Sarvesh on 08/10/19.
//  Copyright © 2019 sarmaxsri. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    let defaults = UserDefaults.standard
    var itemArray : [String] = ["New Item"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "ToDoListArray") as? [String]
        {
            itemArray = items
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem)
    {
        var addItemTemp = UITextField() //Temp text storage
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            addItemTemp = alertTextField
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Success")
            //Adding New Item to Array and Updating Table View
            self.itemArray.append(addItemTemp.text ?? "New Item")
            print(self.itemArray)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancelled Succesfully")
            //do nothing
        }

        print()
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
}

