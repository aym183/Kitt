//
//  CreateDB.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import Foundation
import Firebase

class CreateDB : ObservableObject {
    
    func addUser(email: String, username: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("users")
        let data: [String: Any] = [
            "date_created": TimeData().getPresentDateTime(),
            "email": email,
            "username": username,
            "stripe_customer_id": "",
            "stripe_payment_method": ""
        ]
        
        ref.addDocument(data: data) { error in
            if let error = error {
                print("Error adding user: \(error.localizedDescription)")
                completion("Error")
            } else {
                print("User added")
                completion("User Added")
            }
            
        }
    }
}
