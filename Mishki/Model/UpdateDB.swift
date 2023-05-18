//
//  UpdateDB.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

class UpdateDB : ObservableObject {
    
    func updateImage(image: UIImage, completion: @escaping (String?) -> Void) {
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
                completion("Successful")
            }
        }
    }
    
    func updateBio(bioText: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users")
        @AppStorage("username") var userName: String = ""
        
        collectionRef.whereField("username", isEqualTo: userName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error updating Bio: \(error)")
            } else {
                guard let document = querySnapshot?.documents.first else {
                    print("No documents found")
                    return
                }
            
                let docRef = collectionRef.document(document.documentID)
                docRef.updateData(["bio": bioText])
                UserDefaults.standard.set(bioText, forKey: "bio")
                completion("Successful")
            }
        }
    }
    
    func updateFullName(fullName: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users")
        @AppStorage("username") var userName: String = ""
        
        collectionRef.whereField("username", isEqualTo: userName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error updating Full Name: \(error)")
            } else {
                guard let document = querySnapshot?.documents.first else {
                    print("No documents found")
                    return
                }
            
                let docRef = collectionRef.document(document.documentID)
                docRef.updateData(["full_name": fullName])
                UserDefaults.standard.set(fullName, forKey: "full_name")
                completion("Successful")
            }
        }
    }
    
    func updateUserDetails(fullName: String, bioText: String, completion: @escaping (String?) -> Void) {
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
                docRef.updateData(["full_name": fullName, "bio": bioText])
                UserDefaults.standard.set(fullName, forKey: "full_name")
                UserDefaults.standard.set(bioText, forKey: "bio")
                completion("Successful")
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
    
    func updateCreatedLink(old_url: String, new_url: String, old_name: String, new_name: String, completion: @escaping (String?) -> Void) {
        @AppStorage("links") var links: String = ""
        let db = Firestore.firestore()
        let ref = db.collection("links")
        var temp_entries = UserDefaults.standard.array(forKey: "myKey") as? [String: [String:String]] ?? [:]
        
        ref.whereField(FieldPath.documentID(), isEqualTo: links)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error finding link to update: \(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        for documentData in document.data() {
                            if let valueDict = documentData.value as? [String: String] {
                                if valueDict["name"] == old_name && valueDict["url"] == old_url {
                                    temp_entries[documentData.key] = ["name": new_name, "url": new_url, "time_created": TimeData().getPresentDateTime()]
                                } else {
                                    temp_entries[documentData.key] = valueDict
                                }
                            }
                        }
                        ref.document(document.documentID).setData(temp_entries) { error in
                            if let error = error {
                                print("Error updating created link: \(error.localizedDescription)")
                            } else {
                                print("Updated Created Link successfully")
                                completion("Successful")
                            }
                        }
                    }
                }
            }
    }
    
    func updateCreatedProduct(data: [String: Any], old_image: UIImage, new_image: UIImage, completion: @escaping (String?) -> Void) {
        @AppStorage("products") var products: String = ""
        let db = Firestore.firestore()
        let ref = db.collection("products")
        let randomID = UUID().uuidString
        let path = "product_images/\(randomID).jpg"
        var temp_entries = UserDefaults.standard.array(forKey: "myKey") as? [String: [String:String]] ?? [:]
        
        let imageData = new_image.jpegData(compressionQuality: 0.8)

        guard imageData != nil else {
            return
        }
        
        UserDefaults.standard.set(new_image.jpegData(compressionQuality: 0.8), forKey: path)
        
        ref.whereField(FieldPath.documentID(), isEqualTo: products)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error finding product to update: \(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        for documentData in document.data() {
                            if let valueDict = documentData.value as? [String: String] {

                                if valueDict["name"] == String(describing: data["oldProductName"]!) && valueDict["price"] == String(describing: data["oldProductPrice"]!) && valueDict["description"] == String(describing: data["oldProductDesc"]!) {
                                    
                                        temp_entries[documentData.key] = ["name": String(describing: data["productName"]!), "description": String(describing: data["productDesc"]!), "time_created": TimeData().getPresentDateTime(), "price": String(describing: data["productPrice"]!), "image": path]

                                        DispatchQueue.global(qos: .background).async {
                                            let storage = Storage.storage().reference()
                                            let fileRef = storage.child("product_images/\(randomID).jpg")
                                            let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
                                            }
                                        }

                                } else {
                                    temp_entries[documentData.key] = valueDict
                                }
                            }
                        }
                        ref.document(document.documentID).setData(temp_entries) { error in
                            if let error = error {
                                print("Error updating created product: \(error.localizedDescription)")
                            } else {
                                print("Updated Created Product successfully")
                                completion("Successful")
                            }
                        }
                    }
                }
            }
    }
    
    func updateCreatedClasses(data: [String: Any], old_image: UIImage, new_image: UIImage, completion: @escaping (String?) -> Void) {
        @AppStorage("classes") var classes: String = ""
        let db = Firestore.firestore()
        let ref = db.collection("classes")
        let randomID = UUID().uuidString
        let path = "classes_images/\(randomID).jpg"
        var temp_entries = UserDefaults.standard.array(forKey: "myKey") as? [String: [String:String]] ?? [:]
        
        let imageData = new_image.jpegData(compressionQuality: 0.8)

        guard imageData != nil else {
            return
        }
        
        UserDefaults.standard.set(new_image.jpegData(compressionQuality: 0.8), forKey: path)
        
        ref.whereField(FieldPath.documentID(), isEqualTo: classes)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error finding class to update: \(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        for documentData in document.data() {
                            if let valueDict = documentData.value as? [String: String] {

                                if valueDict["name"] == String(describing: data["oldClassName"]!) && valueDict["price"] == String(describing: data["oldClassPrice"]!) && valueDict["description"] == String(describing: data["oldClassDesc"]!) {
                                    
                                    temp_entries[documentData.key] = ["name": String(describing: data["className"]!), "description": String(describing: data["classDesc"]!), "time_created": TimeData().getPresentDateTime(), "price": String(describing: data["classPrice"]!), "image": path, "duration": String(describing: data["classDuration"]!), "seats": String(describing: data["classSeats"]!), "location": String(describing: data["classLocation"]!)]

                                        DispatchQueue.global(qos: .background).async {
                                            let storage = Storage.storage().reference()
                                            let fileRef = storage.child("classes_images/\(randomID).jpg")
                                            let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
                                            }
                                        }

                                } else {
                                    temp_entries[documentData.key] = valueDict
                                }
                            }
                        }
                        ref.document(document.documentID).setData(temp_entries) { error in
                            if let error = error {
                                print("Error updating created classes: \(error.localizedDescription)")
                            } else {
                                print("Updated Created Classes successfully")
                                completion("Successful")
                            }
                        }
                    }
                }
            }
    }
    
    func updateProducts(image: UIImage, name: String, description: String, price: String) {
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
        
        DispatchQueue.global(qos: .background).async {
            let storage = Storage.storage().reference()
            let fileRef = storage.child("product_images/\(randomID).jpg")
            let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            }
        }
        
        UserDefaults.standard.set(image.jpegData(compressionQuality: 0.8), forKey: path)
        
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
    
    func updateClasses(image: UIImage, name: String, description: String, price: String, duration: String, seats: String, location: String) {
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
            }
        }
        
       
        UserDefaults.standard.set(image.jpegData(compressionQuality: 0.8), forKey: path)
        
        var documentData = [String: Any]()
        var fieldID = ref.document()
        documentData[fieldID.documentID] = ["name": name, "image": path, "time_created": presentDateTime, "description": description, "price": price, "duration": duration, "seats": seats, "location": location]
        
        docID.updateData(documentData) { error in
           if let error = error {
               print("Error adding class: \(error.localizedDescription)")
           } else {
               print("Class added successfully!")
           }
        }
    }
    
    func updateSocials(instagram: String, tiktok: String, facebook: String, youtube: String, website: String) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users")
        @AppStorage("username") var userName: String = ""
        
        collectionRef.whereField("username", isEqualTo: userName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error updating Socials: \(error)")
            } else {
                guard let document = querySnapshot?.documents.first else {
                    print("No documents found")
                    return
                }
            
                let docRef = collectionRef.document(document.documentID)
                docRef.updateData(["instagram": instagram, "tiktok": tiktok, "facebook": facebook, "youtube": youtube, "website": website])
            }
        }
    }
}
