//
//  TodoListViewController.swift
//  Todeey
//
//  Created by Sarvesh on 08/10/19.
//  Copyright © 2019 sarmaxsri. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    //let defaults = UserDefaults.standard
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let newItem = Item()
        
        
//        newItem.title = "Hello"
//        itemArray.append(newItem)
//                itemArray.append(newItem)
//                itemArray.append(newItem)
//                itemArray.append(newItem)
        tableView.reloadData()
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String]
//        {
//            itemArray = items
//        }
        
        loadItems();
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        print(itemArray[indexPath.row])
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
            let newItem = Item()
            newItem.title = addItemTemp.text!
            self.itemArray.append(newItem)
//            print(self.itemArray)
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.saveItems();
            
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
    func saveItems()
    {
        let encoder = PropertyListEncoder();
        do
        {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch
        {
            print("Error Encoding item array \(error)");
        }
        self.tableView.reloadData()
    }
    
    func loadItems()
    {
        if let data = try? Data(contentsOf: dataFilePath!)
        {
            let decoder = PropertyListDecoder()
            do
            {
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch
            {
                print("Error;")
            }
        }
    }
}


