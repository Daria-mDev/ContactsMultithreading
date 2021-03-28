//
//  TableViewController.swift
//  ContactsMultithreading
//
//  Created by user on 25.03.2021.
//

import UIKit

class TableViewController: UITableViewController {
    private var contactList: [Contact] = []
    private var tableSections = [String]()
    private var dictionaryContacts: [String: [Contact]] = [:]
    var concurrencyOption: ConcurrencyOption = ConcurrencyOption.operationQueue
    private let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLoadindIndicator()
        
        let path: String = "https://gist.githubusercontent.com/artgoncharov/d257658423edd46a9ead5f721b837b8c/raw/c38ace33a7c871e4ad3b347fc4cd970bb45561a3/contacts_data.json"
        
        let contactsRepo = GistConstactsRepository(path: path)
        if concurrencyOption == ConcurrencyOption.operationQueue {
            navigationItem.title = "Contact - Operation"
            fetchOperationQueue(contactsRepo: contactsRepo)
        }
        else if concurrencyOption == ConcurrencyOption.grandCentralDispatch {
            navigationItem.title = "Contact - GCD"
            fetchGCD(contactsRepo: contactsRepo)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        tableSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRowsInSection = dictionaryContacts[tableSections[section]]?.count  else {
            return 0
        }
        return numberOfRowsInSection
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let contact = dictionaryContacts[tableSections[indexPath.section]]?[indexPath.row]
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
        
        let contact = dictionaryContacts[tableSections[indexPath.section]]?[indexPath.row]
        viewController.contact = contact
        
    }
    
    private func addLoadindIndicator() {
        loadingIndicator.style = .large
        loadingIndicator.color = UIColor.systemGray
        loadingIndicator.hidesWhenStopped = true
        
        loadingIndicator.center.x = self.view.center.x
        loadingIndicator.center.y = self.view.center.y * 0.8
        
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        self.view.isUserInteractionEnabled = false
    }
    
    private func fetchOperationQueue(contactsRepo: ContactsRepository) {
        let operationQueue = OperationQueue()
        operationQueue.name = "Contacts Downloader Queue"
        operationQueue.maxConcurrentOperationCount = 1
        
        let downloaderOperation = ContactsDownloadOperation(contactsRepository: contactsRepo)
        downloaderOperation.completionBlock = {
            if downloaderOperation.isCancelled {
                return
            }
            self.contactList = downloaderOperation.contactList
            self.setTableViewData()
        }
        operationQueue.addOperation(downloaderOperation)
    }
    
    private func fetchGCD(contactsRepo: GistConstactsRepository) {
        let utilityQueue = DispatchQueue.global(qos: .utility)
        utilityQueue.async {
            self.loadContactsData(contactsRepo: contactsRepo)
        }
    }
    
    private func setTableViewData() {
        DispatchQueue.main.async {
            self.dictionaryContacts = Dictionary(grouping: self.contactList) {
                contact in  (contact.firstName.first?.uppercased() ?? " ")
            }
            for (key, _)  in self.dictionaryContacts {
                self.tableSections.append(key)
            }
            self.tableSections.sort()
            self.tableView.reloadData()
            
            self.loadingIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    private func loadContactsData(contactsRepo: ContactsRepository) {
        do {
            self.contactList = try contactsRepo.getContacts()
        }
        catch {
            print(error)
        }
        self.setTableViewData()
    }
}
