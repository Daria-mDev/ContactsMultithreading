//
//  TableViewController.swift
//  ContactsMultithreading
//
//  Created by user on 25.03.2021.
//

import UIKit

class TableViewController: UITableViewController {
    var contactList: [Contact] = []
    private var tableSections = [String]()
    private var dictionaryContacts: Dictionary<String, [Contact]>?
    var isOperation: Bool = false
    
    func asyncMainQueue() {
        
        DispatchQueue.main.async {
            self.dictionaryContacts = Dictionary(grouping: self.contactList) {
                contact in  (contact.firstName.first?.uppercased() ?? " ")
            }
            if let dictionaryContacts = self.dictionaryContacts {
                for (key, _)  in dictionaryContacts {
                    self.tableSections.append(key)
                }
                self.tableSections.sort()
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path: String = "https://gist.githubusercontent.com/artgoncharov/d257658423edd46a9ead5f721b837b8c/raw/c38ace33a7c871e4ad3b347fc4cd970bb45561a3/contacts_data.json"
        
        let contactsRepo = GistConstactsRepository(path: path)
        if isOperation  {
            navigationItem.title = "Contact - Operation"
            OperationQueue().addOperation(
                {
                    do {
                        self.contactList = try contactsRepo.getContacts()
                    }
                    catch {
                        print(ContactsRepositoryError.urlFailure)
                    }
                    self.asyncMainQueue()
                }
            )
        }
        else {
            navigationItem.title = "Contact - GCD"
            let utilityQueue = DispatchQueue.global(qos: .utility)
            utilityQueue.async {
                do {
                    self.contactList = try contactsRepo.getContacts()
                }
                catch {
                    print(ContactsRepositoryError.urlFailure)
                }
                self.asyncMainQueue()
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        tableSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRowsInSection = dictionaryContacts?[tableSections[section]]?.count  else {
            return 0
        }
        return numberOfRowsInSection
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let contact = dictionaryContacts?[tableSections[indexPath.section]]?[indexPath.row]
        cell.textLabel?.text = (contact?.firstName ?? " ") + " " + (contact?.lastName ?? " ")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableSections[section]
    }
    func tableView(tableView: UITableView,
                   sectionForSectionIndexTitle title: String,
                   atIndex index: Int) -> Int{
        return index
    }
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]!{
        return tableSections
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        tableSections
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? DetailsViewController, let indexPath = tableView.indexPathForSelectedRow  else {return }
        
        let contact = dictionaryContacts?[tableSections[indexPath.section]]?[indexPath.row]
        viewController.contact = contact
        
    }
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
