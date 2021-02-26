//
//  NeededThingsTableVC.swift
//  SwiftVsSwift
//
//  Created by Maris Rasnacs on 24/02/2021.
//

import UIKit
import CoreData

class GettingReadyTableVC: UITableViewController {

    var neededThings = [NeededThings]()
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }

    @IBAction func addNewItemTapped(_ sender: Any) {
        addNewItem()
    }
    
    
    private func addNewItem() {
        let alertController = UIAlertController(title: "Get ready!", message: "What is missing in list?", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Start with main idea"
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .no
        }
        alertController.addTextField { (detailsField: UITextField) in
            detailsField.placeholder = "Add details to clarify"
            detailsField.autocapitalizationType = .sentences
            detailsField.autocorrectionType = .no
        }
        
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (action: UIAlertAction) in
            
            let textField = alertController.textFields?.first
            let detailsField = alertController.textFields?.last
            if textField?.text == "" {
                self.warningPopup(withTitle: "No information provided", withMessage: nil)
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "NeededThings", in: self.context!)
                let item = NSManagedObject(entity: entity!, insertInto: self.context)
                item.setValue(textField?.text, forKey: "title")
                item.setValue(detailsField?.text, forKey: "details")
                self.saveData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
    
    func sharedData() -> String {
        var resultString = ""

        let request: NSFetchRequest<NeededThings> = NeededThings.fetchRequest()
        do {
            let result = try context?.fetch(request)
            neededThings = result!
        } catch {
            warningPopup(withTitle: "Error!", withMessage: error.localizedDescription)
            fatalError(error.localizedDescription)
        }
        
        neededThings.forEach { item in
            if resultString == "" {
                resultString.append("\(item.value(forKey: "title")!) - \(item.value(forKey: "details")!)")
            } else {
                resultString.append(", \(item.value(forKey: "title")!) - \(item.value(forKey: "details")!)")
            }
        }
        return resultString
    }
    
    func loadData() {
        let request: NSFetchRequest<NeededThings> = NeededThings.fetchRequest()
        do {
            let result = try context?.fetch(request)
            neededThings = result!
        } catch {
            warningPopup(withTitle: "Error!", withMessage: error.localizedDescription)
            fatalError(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func saveData() {
        do {
            try self.context?.save()
        } catch {
            warningPopup(withTitle: "Error!", withMessage: error.localizedDescription)
            fatalError(error.localizedDescription)
        }
        loadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return neededThings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell",for: indexPath)
        let item = neededThings[indexPath.row]
        cell.textLabel?.text = item.value(forKey: "title") as? String
        cell.detailTextLabel?.text = item.value(forKey: "details") as? String
        cell.accessoryType = item.purchased ? .checkmark : .none
        cell.selectionStyle = .none
        return cell
    }

    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        neededThings[indexPath.row].purchased = !neededThings[indexPath.row].purchased
        saveData()
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Removing?warningPopup", message: "Do not need this in list?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                let item = self.neededThings[indexPath.row]
                
                self.context?.delete(item)
                self.saveData()
            }))
            self.present(alert, animated: true)
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let currentItem = neededThings.remove(at: fromIndexPath.row)
        neededThings.insert(currentItem, at: to.row)
        saveData()
    }
}
extension UIViewController {
    func warningPopup(withTitle title: String?, withMessage message: String?) {
        DispatchQueue.main.async {
            let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            popup.addAction(okButton)
            
            self.present(popup, animated: true, completion: nil)
        }
    }
}
