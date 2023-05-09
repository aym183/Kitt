//
//  CreateDB.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import Foundation
import Firebase
import SwiftUI

class CreateDB : ObservableObject {
    
    func addUser(email: String, username: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("users")
        var docRef = ref.document().documentID
        
        let data: [String: Any] = [
            "date_created": TimeData().getPresentDateTime(),
            "email": email,
            "username": username,
            "stripe_customer_id": "",
            "stripe_payment_method": "",
            "links": docRef,
            "products": docRef
        ]
        
        ref.addDocument(data: data) { error in
            if let error = error {
                print("Error adding user: \(error.localizedDescription)")
                completion("Error")
            } else {
                print("User added")
                UserDefaults.standard.set(username, forKey: "username")
                UserDefaults.standard.set(docRef, forKey: "links")
                UserDefaults.standard.set(docRef, forKey: "products")
                completion("User Added")
            }
        }
    }
    
    func addLink(name: String, url: String) {
        @AppStorage("links") var links: String = ""
        
        let db = Firestore.firestore()
        let ref = db.collection("links")
        var docID = ref.document(links)
        var presentDateTime = TimeData().getPresentDateTime()
        
        var documentData = [String: Any]()
        var fieldID = ref.document()
        documentData[fieldID.documentID] = ["name": name, "url": url, "time_created": presentDateTime]
        
        docID.setData(documentData) { error in
           if let error = error {
               print("Error adding link: \(error.localizedDescription)")
           } else {
               print("Link added successfully!")
           }
                   }
    }
    
    
}
