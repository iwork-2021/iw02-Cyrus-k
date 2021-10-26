//
//  ToDoTableViewController.swift
//  Mytodolist
//
//  Created by nju on 2021/10/22.
//

import UIKit

class ToDoTableViewController: UITableViewController {

    var items:[ToDoitem] =
    [
        ToDoitem(title: "Homework", isChecked: false),
        ToDoitem(title: "Walk Dog", isChecked: true),
        ToDoitem(title: "Play football", isChecked: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .blue
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        loadItems()
        /*UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableViewBackground.png"]];
        [tempImageView setFrame:self.tableView.frame];

        self.tableView.backgroundView = tempImageView;
        [tempImageView release];*/
        

        //self.tableView.backgroundColor = [UIColor.clearColor];

        let bg = UIImage(named: "nixeu")
        let bgView = UIImageView(image: bg)
        bgView.contentMode = UIView.ContentMode.scaleAspectFill
        self.tableView.backgroundView = bgView
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! ToDoTableViewCell
        let item = items[indexPath.row]
        
        cell.title.text! = item.title
        if item.isChecked{
            cell.status.text! = "✅"
        }
        else{
            cell.status.text! = " "
        }

        // Configure the cell...

        return cell
    }
    /*override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }*/
    
    /*override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        
    }*/
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "additem"{
            let addItemViewController = segue.destination as! ItemViewController
            addItemViewController.addItemDelegate = self
        }
        else if segue.identifier == "edititem"{
            let editItemViewController = segue.destination as! ItemViewController
            let cell = sender as! ToDoTableViewCell
            var isChecked:Bool
            if cell.status.text! == "✅"{
                isChecked = true
            }
            else{
                isChecked = false
            }
            let item = ToDoitem(title: cell.title.text!, isChecked: isChecked)
            editItemViewController.itemToEdit = item
            editItemViewController.itemIndex = tableView.indexPath(for: cell)!.row
            editItemViewController.editItemDelegate = self
        }
    }
    
    private func handleMarkAsFavourite(indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        print("Marked as favourite")
    }
    
    private func moveToFirst(indexPath: IndexPath) {
        let newitem = items[indexPath.row]
        items.remove(at: indexPath.row)
        let toIndexPath = IndexPath(row: 0, section: 0)
        items.insert(newitem, at: toIndexPath.row)
        self.tableView.moveRow(at: indexPath, to: toIndexPath)
        print("move to first")
    }
    
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // ...
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
                                            self?.handleMarkAsFavourite(indexPath: indexPath)
                                            completionHandler(true)
        }
        action.backgroundColor = .systemCyan
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
                                            self?.handleMarkAsFavourite(indexPath: indexPath)
                                            completionHandler(true)
        }
        action.backgroundColor = .systemRed
        
        let movetotop = UIContextualAction(style: .normal,
                                        title: "Top") { [weak self] (action, view, completionHandler) in
                                            self?.moveToFirst(indexPath: indexPath)
                                            completionHandler(true)
        }
        movetotop.backgroundColor = .systemGray
        
        return UISwipeActionsConfiguration(actions: [action,movetotop])
    }
    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            items[indexPath.row].isChecked = !(items[indexPath.row].isChecked)
            self.tableView.reloadData()
        }*/

}



extension ToDoTableViewController:AddItemDelegate {
    func addItem(item: ToDoitem){
        self.items.append(item)
        self.tableView.reloadData()
    }
}

extension ToDoTableViewController:EditItemDelegate{
    func editItem(newitem: ToDoitem, itemIndex: Int) {
        self.items[itemIndex] = newitem
        self.tableView.reloadData()
    }
}

extension ToDoTableViewController{
    func dataFilePath()->URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return path!.appendingPathComponent("ToDoitems.json")
    }
    func saveAllItems() {
        do{
            let data = try JSONEncoder().encode(items)
            try data.write(to: dataFilePath(), options: .atomic)
            
        }catch{
            print("Cannot save: \(error.localizedDescription)")
        }
    }
    
    func loadItems(){
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path){
            do{
                items = try JSONDecoder().decode([ToDoitem].self, from: data)
            }catch{
                print("Error decoding list:\(error.localizedDescription)")
            }
        }
    }
}
