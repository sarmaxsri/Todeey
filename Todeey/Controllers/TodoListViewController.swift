//
//  TodoListViewController.swift
//  Todeey
//
//  Created by Sarvesh on 08/10/19.
//  Copyright © 2019 sarmaxsri. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    //let defaults = UserDefaults.standard
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()
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
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
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

            let newItem = Item(context: self.context)
            newItem.title = addItemTemp.text!
            newItem.done = false;
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

        do
        {
            try context.save()
        }
        catch
        {
            print("Error saving context \(error)");
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest())
    {
        do
        {
            itemArray = try context.fetch(request)
        }
        catch
        {
            print("Error fetching data from context", error)
        }
        tableView.reloadData()
    }
    
}

//MARK: - Search Bar Methods

extension TodoListViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
    self.view.endEditing(true)
        if(searchBar.text == "")
        {
            searchBar.setShowsCancelButton(false, animated: true)
        }
        else
        {
            searchBar.setShowsCancelButton(true, animated: true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
        if(searchBar.text != "")
        {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            //print(searchBar.text)
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request)
        }
        else
        {
            loadItems()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        self.view.endEditing(true)
        loadItems()
    }
}


