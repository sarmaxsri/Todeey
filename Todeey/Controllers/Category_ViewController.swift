//
//  Category_ViewController.swift
//  Todeey
//
//  Created by Sarvesh on 20/12/19.
//  Copyright © 2019 sarmaxsri. All rights reserved.
//

import UIKit
import CoreData

class Category_ViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Categories.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        loadCategories()

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var addCategoryTemp = UITextField(); //temp
        let alert = UIAlertController(title: "Add New Category", message: "" , preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Shopping List";
            addCategoryTemp = alertTextField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            print("Success")
            
            let newCategory = Category(context: self.context)
            newCategory.name = addCategoryTemp.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories();
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancelled Succesfully")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    func saveCategories()
    {
        do
        {
            try context.save()
        }
        catch
        {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest())
    {
        do
        {
            categoryArray = try context.fetch(request)
        }
        catch
        {
            print("Error fetching data from context", error)
        }
        tableView.reloadData()
    }
}
