//
//  ContactsRepository.swift
//  ContactsMultithreading
//
//  Created by user on 24.03.2021.
//

import Foundation

protocol ContactsRepository {
    func getContacts() throws -> [Contact]
}
class GistConstactsRepository: ContactsRepository {
    private let path: String
    
    init(path: String) {
        self.path = path
    }
    func getContacts() throws -> [Contact] {
        let sem = DispatchSemaphore(value: 0)
        guard let url = URL(string: path) else
        {
            throw ContactsRepositoryError.urlFailure
            
        }
        let request = URLRequest(url: url)
        var result: [Contact] = []
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer {
                sem.signal()
            }
            if let data = data {
                do {
                    result = try JSONDecoder().decode([Contact].self,from: data)
                }
                catch {
                    print("\(ContactsRepositoryError.jsonDecoderFailure)")
                }
            }
        }
        task.resume()
        
        if sem.wait(timeout: .now() + .seconds(10)) == .timedOut {
            throw ContactsRepositoryError.timeout
        }
        return result
    }
}
