//
//  UpdateDB.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

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
    
    func updateProducts(image: UIImage, name: String, description: String, price: String) {
        @AppStorage("products") var products: String = ""
        
        let storage = Storage.storage().reference()
        let imageData = image.jpegData(compressionQuality: 0.8)

        guard imageData != nil else {
            return
        }
        
        let db = Firestore.firestore()
        let ref = db.collection("products")
        var docID = ref.document(products)
        var presentDateTime = TimeData().getPresentDateTime()
        
        let randomID = UUID().uuidString
        let path = "product_images/\(randomID).jpg"
        let fileRef = storage.child("product_images/\(randomID).jpg")
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
        }
        
        var documentData = [String: Any]()
        var fieldID = ref.document()
        documentData[fieldID.documentID] = ["image": path, "name": name, "time_created": presentDateTime, "description": description, "price": price]
        
        docID.updateData(documentData) { error in
        if let error = error {
            print("Error updating product: \(error.localizedDescription)")
        } else {
            print("Product Updated!")
        }
        }
        
    }
}
