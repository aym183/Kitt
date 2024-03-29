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
    func addtoDB(completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        var uuid = ""
        if Auth.auth().currentUser?.uid != nil {
            uuid = Auth.auth().currentUser!.uid
        }
        
        let ref = db.collection("users")
        let productRef = db.collection("products")
        let docRef = ref.document(uuid)
        let prodDocRef = productRef.document(uuid)
        prodDocRef.setData([:])
        docRef.setData([:])
        completion("Successful")
    }
    
    func addUser(email: String, username: String, completion: @escaping (String?) -> Void) {

        let db = Firestore.firestore()
        let ref = db.collection("users")
        @AppStorage("fcm_token") var cached_fcm: String = ""
        var uuid = ""
        if Auth.auth().currentUser?.uid != nil {
            uuid = Auth.auth().currentUser!.uid
        }
        let docRef = ref.document(uuid)
        
            ref.whereField("metadata.username", isEqualTo: username).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error checking username: \(error.localizedDescription)")
                    return
                }
                if let documents = snapshot?.documents, !documents.isEmpty {
                    completion("Username already exists")
                } else {
                    
                    let data: [String: Any] = [
                        "metadata": ["email": email, "username": username, "links": uuid, "products": uuid, "classes": uuid, "profile_image": "", "instagram": "", "tiktok": "", "facebook": "", "social_email": "", "youtube": "", "website": ""],
                        "date_created": TimeData().getPresentDateTime(),
                        "sales": uuid,
                        "bank_name": "",
                        "bank_full_name": "",
                        "account_number": "",
                        "iban": "",
                        "fcm_token": cached_fcm,
                        "auth_uuid": uuid
                    ]
                    
                    docRef.setData(data) { error in
                        if let error = error {
                            print("Error adding user: \(error.localizedDescription)")
                            completion("Error")
                        } else {
                            UserDefaults.standard.set(username, forKey: "username")
                            UserDefaults.standard.set(uuid, forKey: "links")
                            UserDefaults.standard.set(uuid, forKey: "products")
                            UserDefaults.standard.set(uuid, forKey: "classes")
                            UserDefaults.standard.set(uuid, forKey: "sales")
                            UserDefaults.standard.set("", forKey: "tiktok")
                            UserDefaults.standard.set("", forKey: "social_email")
                            UserDefaults.standard.set("", forKey: "facebook")
                            UserDefaults.standard.set("", forKey: "website")
                            UserDefaults.standard.set("", forKey: "youtube")
                            UserDefaults.standard.set("", forKey: "instagram")
                            UserDefaults.standard.set(nil, forKey: "profile_image")
                            UserDefaults.standard.set("", forKey: "bank_name")
                            UserDefaults.standard.set("", forKey: "bank_full_name")
                            UserDefaults.standard.set("", forKey: "acc_number")
                            UserDefaults.standard.set("", forKey: "iban")
                            completion("User Added")
                        }
                    }
                }
            }
    }
    
    func addLink(name: String, url: String, index: String, completion: @escaping (String?) -> Void) {
        @AppStorage("products") var products: String = ""
        let db = Firestore.firestore()
        let ref = db.collection("products")
        var docID = ref.document(products)
        var presentDateTime = TimeData().getPresentDateTime()
        let rtRef = Database.database().reference().child("products")
        let userRef = rtRef.child(products)
        var documentData = [String: Any]()
        var fieldID = ref.document()
        documentData[fieldID.documentID] = ["name": name, "url": url, "time_created": presentDateTime, "index": index]
        userRef.setValue(documentData) { (error, _) in
            if let error = error {
                print("Failed to add link to realtime db: \(error)")
            } else {
                print("Link added succesfully to realtimedb")
            }
        }
        
        docID.setData(documentData) { error in
           if let error = error {
               print("Error adding link: \(error.localizedDescription)")
           } else {
               completion("Successful")
           }
        }
    }
    
    
    func addProducts(image: UIImage, name: String, description: String, price: String, file: URL, file_name: String, index: String, completion: @escaping (String?) -> Void) {
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
        let rtRef = Database.database().reference().child("products")
        let userRef = rtRef.child(products)

        DispatchQueue.global(qos: .background).async {
            let storage = Storage.storage().reference()
            let fileRef = storage.child("product_images/\(randomID).jpg")
            let sourceOrientation = image.imageOrientation
            let sideLength = min(image.size.width, image.size.height)
            let sourceSize = image.size
            let xOffset = (sourceSize.width - sideLength) / 2.0
            let yOffset = (sourceSize.height - sideLength) / 2.0
            let cropRect = CGRect(
                x: xOffset,
                y: yOffset,
                width: sideLength,
                height: sideLength
            ).integral

            // Create a copy of the original image with the correct orientation
            let correctedImage: UIImage
            if sourceOrientation != .up {
                UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
                image.draw(in: CGRect(origin: .zero, size: image.size))
                correctedImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
                UIGraphicsEndImageContext()
            } else {
                correctedImage = image
            }

            // Center crop the corrected image
            let sourceCGImage = correctedImage.cgImage!
            let croppedCGImage = sourceCGImage.cropping(to: cropRect)!
            let croppedImage = UIImage(cgImage: croppedCGImage, scale: correctedImage.scale, orientation: correctedImage.imageOrientation)

            // Convert the UIImage to data
            guard let croppedImageData = croppedImage.jpegData(compressionQuality: 0.8) else {
                print("Error converting cropped image to JPEG data")
                return
            }

            let uploadTask = fileRef.putData(croppedImageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading product image: \(error.localizedDescription)")
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
        documentData[fieldID.documentID] = ["name": name, "image": path, "time_created": presentDateTime, "description": description, "price": price, "file": filePath, "file_name": file_name, "index": index]
    
        userRef.setValue(documentData) { (error, _) in
            if let error = error {
                print("Failed to add product to realtime db: \(error)")
            } else {
                print("Product added succesfully to realtimedb")
            }
        }
        
        docID.setData(documentData) { error in
           if let error = error {
               print("Error adding product: \(error.localizedDescription)")
           } else {
               completion("Successful")
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
        guard imageData != nil else { return }
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
        }
        
        UserDefaults.standard.set(image.jpegData(compressionQuality: 0.8), forKey: "profile_image")
        completion("Cached")
        collectionRef.whereField("metadata.username", isEqualTo: userName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error uploading Image: \(error)")
            } else {
                guard let document = querySnapshot?.documents.first else {
                    print("No documents found")
                    return
                }
            
                let docRef = collectionRef.document(document.documentID)
                let metadata = document.data()["metadata"] as? [String: Any]
                var updatedMetadata = metadata ?? [:]
                updatedMetadata["profile_image"] = path
                docRef.updateData(["metadata": updatedMetadata])
            }
        }
    }
}
