//
//  CreateDB.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseStorage

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
    
    func addProducts(image: String, name: String, description: String, price: String) {
        @AppStorage("products") var products: String = ""
        
        let db = Firestore.firestore()
        let ref = db.collection("products")
        var docID = ref.document(products)
        var presentDateTime = TimeData().getPresentDateTime()
        
        var documentData = [String: Any]()
        var fieldID = ref.document()
        documentData[fieldID.documentID] = ["name": name, "image": image, "time_created": presentDateTime, "description": description, "price": price]
        
        docID.setData(documentData) { error in
           if let error = error {
               print("Error adding product: \(error.localizedDescription)")
           } else {
               print("Product added successfully!")
           }
        }
    }
    
    func uploadProfileImage(image: UIImage) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users")
        @AppStorage("username") var userName: String = ""
        
        let storage = Storage.storage().reference()
        let imageData = image.jpegData(compressionQuality: 0.8)

        guard imageData != nil else {
            return
        }
        
        let path = "profile_images/\(UUID().uuidString).jpg"
        let fileRef = storage.child("profile_images/\(UUID().uuidString).jpg")
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
        }
        
        
        collectionRef.whereField("username", isEqualTo: userName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error uploading Image: \(error)")
            } else {
                guard let document = querySnapshot?.documents.first else {
                    print("No documents found")
                    return
                }
            
                let docRef = collectionRef.document(document.documentID)
                docRef.updateData(["profile_image": path])
            }
        }
    }
    
    func uploadProductImage(image: UIImage) {
        let storage = Storage.storage().reference()
        let imageData = image.jpegData(compressionQuality: 0.8)

        guard imageData != nil else {
            return
        }
        
        let fileRef = storage.child("product_images/\(UUID().uuidString).jpg")
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            
        }
    }
    
}
