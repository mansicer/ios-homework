//
//  ShoppingItemTableViewController.swift
//  HW4-ShoppingList
//
//  Created by 张福翔 on 2020/11/9.
//

import UIKit
import os.log

@IBDesignable class ShoppingItemTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        if let items = loadShoppingList() {
            shoppingItems += items
        } else {
            loadSamples()
        }
    }
    
    // MARK: properties
    var shoppingItems = [ShoppingItem]()
    
    // MARK: private methods
    private func loadSamples() {
        let photo1 = UIImage(named: "SampleItem1")
        let photo2 = UIImage(named: "SampleItem2")
        let photo3 = UIImage(named: "SampleItem3")
        let item1 = ShoppingItem(name: "iPhone 12 蓝色", photo: photo1, rating: 3, reason: "这蓝色真好看! (并不)")
        let item2 = ShoppingItem(name: "iPhone 12 Pro 石墨色", photo: photo2, rating: 4, reason: "手感沉, 质感好")
        let item3 = ShoppingItem(name: "iPhone 电源适配器 20W", photo: photo3, rating: 1, reason: "宇宙最强超级快充")
        shoppingItems += [item1, item2, item3]
    }
    
    private func saveShoppingList() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: shoppingItems, requiringSecureCoding: false)
            try data.write(to: ShoppingItem.ArchiveURL)
        } catch {
            os_log("Failed to save shopping list", log: .default, type: .debug)
        }
    }
    
    private func loadShoppingList() -> [ShoppingItem]? {
        do {
            let data = try Data(contentsOf: ShoppingItem.ArchiveURL)
            let result = try NSKeyedUnarchiver.unarchiveObject(with: data) as? [ShoppingItem]
            return result
        } catch {
            os_log("Failed to load shopping list", log: .default, type: .debug)
            return nil
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shoppingItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Shopping Item Row", for: indexPath) as! ShoppingItemTableViewCell
        let item = shoppingItems[indexPath.row]
        cell.nameLabel.text = item.name
        cell.photoImageView.image = item.photo
        cell.ratingPickerView.rating = item.rating
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            shoppingItems.remove(at: indexPath.row)
            
            DispatchQueue.main.async {
                self.saveShoppingList()
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: actions
    @IBAction func unwindToShoppingList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ShoppingItemViewController, let item = sourceViewController.item {
            if let selectedPath = tableView.indexPathForSelectedRow {
                shoppingItems[selectedPath.row] = item
                tableView.reloadRows(at: [selectedPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: shoppingItems.count, section: 0)
                shoppingItems.append(item)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            DispatchQueue.main.async {
                self.saveShoppingList()
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
        case "Add Shopping Item":
            os_log("Add a new item", log: OSLog.default, type: .debug)
        case "Edit Shopping Item":
            os_log("Edit a item", log: OSLog.default, type: .debug)
            guard let itemViewController = segue.destination as? ShoppingItemViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let seletedCell = sender as? ShoppingItemTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "Unknown sender")")
            }
            guard let index = tableView.indexPath(for: seletedCell) else {
                fatalError("Cell \(seletedCell) is not in the table")
            }
            let model = shoppingItems[index.row]
            itemViewController.item = model
        default:
            fatalError("I don't know what you are doing")
        }
    }
    
    
}
