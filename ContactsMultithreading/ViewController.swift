//
//  ViewController.swift
//  ContactsMultithreading
//
//  Created by user on 25.03.2021.
//

import UIKit

class ViewController: UIViewController {
    private var isOperation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func makeGCD(_ sender: Any) {
        isOperation = false
    }
    
    @IBAction func makeOperation(_ sender: Any) {
        isOperation = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let viewController = segue.destination as? TableViewController else {return }
        if segue.identifier == "gcdSegue" {
            viewController.isOperation = isOperation
        }
        else if segue.identifier == "operationSegue" {
            viewController.isOperation = isOperation
        }
    }
}

