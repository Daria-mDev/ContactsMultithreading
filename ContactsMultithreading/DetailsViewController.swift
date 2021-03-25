//
//  DetailsViewController.swift
//  ContactsMultithreading
//
//  Created by user on 25.03.2021.
//

import UIKit

class DetailsViewController: UIViewController {
    var contact: Contact? = nil
    
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var emailLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameLabel.text = contact?.firstName
        lastNameLabel.text = contact?.lastName
        phoneNumberLabel.text = contact?.phone
        emailLable.text = contact?.email
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
