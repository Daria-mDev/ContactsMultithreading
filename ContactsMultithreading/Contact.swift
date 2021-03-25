//
//  Contact.swift
//  ContactsMultithreading
//
//  Created by user on 24.03.2021.
//

import Foundation

struct Contact: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "firstname"
        case lastName = "lastname"
        case email
        case phone
    }
    
    init(firstName: String, lastName: String, email: String, phone: String){
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
    }
}
