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
import FirebaseFirestore

class CreateDB : ObservableObject {
    
    let imageCache = NSCache<NSString, UIImage>()
    
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
            "products": docRef,
            "classes": docRef,
            "profile_image": "",
            "instagram": "",
            "tiktok": "",
            "facebook": "",
            "youtube": "",
            "website": ""
        ]
        
        ref.addDocument(data: data) { error in
            if let error = error {
                print("Error adding user: \(error.localizedDescription)")
                completion("Error")
            } else {
                UserDefaults.standard.set(username, forKey: "username")
                UserDefaults.standard.set(docRef, forKey: "links")
                UserDefaults.standard.set(docRef, forKey: "products")
                UserDefaults.standard.set(docRef, forKey: "classes")
                UserDefaults.standard.set("", forKey: "tiktok")
                UserDefaults.standard.set("", forKey: "facebook")
                UserDefaults.standard.set("", forKey: "website")
                UserDefaults.standard.set("", forKey: "youtube")
                UserDefaults.standard.set("", forKey: "instagram")
                UserDefaults.standard.set(nil, forKey: "profile_image")
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
    
    
    func addProducts(image: UIImage, name: String, description: String, price: String, file: URL) {
        @AppStorage("products") var products: String = ""
        
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
        let filePath = "product_files/\(randomID).pdf"
        
        
        DispatchQueue.global(qos: .background).async {
            let storage = Storage.storage().reference()
            let fileRef = storage.child("product_images/\(randomID).jpg")
            let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading product image \(error.localizedDescription)")
                }
            }
            
            let productFileRef = storage.child("product_files/\(randomID).pdf")
            let productFileUpload = productFileRef.putFile(from: file, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading product file \(error.localizedDescription)")
                }
            }
        }
        
       
        UserDefaults.standard.set(image.jpegData(compressionQuality: 0.8), forKey: path)
        UserDefaults.standard.set(file.lastPathComponent, forKey: filePath)
        
        var documentData = [String: Any]()
        var fieldID = ref.document()
        documentData[fieldID.documentID] = ["name": name, "image": path, "time_created": presentDateTime, "description": description, "price": price, "file": filePath]
        
        docID.setData(documentData) { error in
           if let error = error {
               print("Error adding product: \(error.localizedDescription)")
           } else {
               print("Product added successfully!")
           }
        }
    }
    
    func addClasses(image: UIImage, name: String, description: String, price: String, duration: String, seats: String, location: String) {
        @AppStorage("classes") var classes: String = ""
        
        let imageData = image.jpegData(compressionQuality: 0.8)

        guard imageData != nil else {
            return
        }
        let db = Firestore.firestore()
        let ref = db.collection("classes")
        var docID = ref.document(classes)
        var presentDateTime = TimeData().getPresentDateTime()
        let randomID = UUID().uuidString
        let path = "classes_images/\(randomID).jpg"
        
        
        DispatchQueue.global(qos: .background).async {
            let storage = Storage.storage().reference()
            let fileRef = storage.child("classes_images/\(randomID).jpg")
            let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading classes image \(error.localizedDescription)")
                }
            }
        }
        
       
        UserDefaults.standard.set(image.jpegData(compressionQuality: 0.8), forKey: path)
        
        var documentData = [String: Any]()
        var fieldID = ref.document()
        documentData[fieldID.documentID] = ["name": name, "image": path, "time_created": presentDateTime, "description": description, "price": price, "duration": duration, "seats": seats, "location": location]
        
        docID.setData(documentData) { error in
           if let error = error {
               print("Error adding class: \(error.localizedDescription)")
           } else {
               print("Class added successfully!")
           }
        }
    }
    
    func uploadProfileImage(image: UIImage, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users")
        @AppStorage("username") var userName: String = ""
        
        let imageData = image.jpegData(compressionQuality: 0.8)

        guard imageData != nil else {
            return
        }
        
        let randomID = UUID().uuidString
        let path = "profile_images/\(randomID).jpg"
        
        
        DispatchQueue.global(qos: .background).async {
            let storage = Storage.storage().reference()
            let fileRef = storage.child("profile_images/\(randomID).jpg")
            let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading profile image \(error.localizedDescription)")
                }
            }
            print("File added to profile image")
        }
        
        
        UserDefaults.standard.set(image.jpegData(compressionQuality: 0.8), forKey: "profile_image")
        completion("Cached")
        
        
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
    
}
