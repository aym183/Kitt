//
//  UpdateDB.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import Foundation
import SwiftUI
import Firebase

class UpdateDB : ObservableObject {
    
    func updateImage(image: UIImage) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users")
        @AppStorage("username") var userName: String = ""
        
        collectionRef.whereField("username", isEqualTo: userName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error updating Image: \(error)")
            } else {
                guard let document = querySnapshot?.documents.first else {
                    print("No documents found")
                    return
                }
            
                let docRef = collectionRef.document(document.documentID)
                docRef.updateData(["profile_image": String(describing: image)])
                UserDefaults.standard.set(String(describing: image), forKey: "profile_image")
            }
        }
    }
    
    func updateLinks(name: String, url: String) {
        @AppStorage("links") var links: String = ""
        
        let db = Firestore.firestore()
        let ref = db.collection("links")
        var docID = ref.document(links)
        var presentDateTime = TimeData().getPresentDateTime()
        
        var documentData = [String: Any]()
        var fieldID = ref.document()
        documentData[fieldID.documentID] = ["name": name, "url": url, "time_created": presentDateTime]
        
        docID.updateData(documentData) { error in
        if let error = error {
            print("Error updating link: \(error.localizedDescription)")
        } else {
            print("Link Updated!")
        }
        }
        
    }
    
    func updateProducts(image: String, name: String, description: String, price: String) {
        @AppStorage("products") var links: String = ""
        
        let db = Firestore.firestore()
        let ref = db.collection("products")
        var docID = ref.document(links)
        var presentDateTime = TimeData().getPresentDateTime()
        
        var documentData = [String: Any]()
        var fieldID = ref.document()
        documentData[fieldID.documentID] = ["name": name, "image": image, "time_created": presentDateTime, "description": description, "price": price]
        
        docID.updateData(documentData) { error in
        if let error = error {
            print("Error updating link: \(error.localizedDescription)")
        } else {
            print("Link Updated!")
        }
        }
        
    }
}
