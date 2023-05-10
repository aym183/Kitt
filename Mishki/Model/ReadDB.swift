//
//  ReadDb.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseStorage

class ReadDB : ObservableObject {
    
    @Published var links: [[String: String]]? = []
    @Published var products: [[String: String]]? = []
    @Published var profile_image: UIImage? = nil
    @Published var product_images: [UIImage?] = []
    
    func getProfileImage() {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users")
        @AppStorage("username") var userName: String = ""
        
        collectionRef.whereField("username", isEqualTo: userName).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting profile image: \(error)")
            } else {
                for document in snapshot!.documents {
                    if document.data()["profile_image"] != nil {
                        let storageRef = Storage.storage().reference()
                        let fileRef = storageRef.child(String(describing: document.data()["profile_image"]!))
                        
                        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                            if error == nil && data != nil {
                                if let image = UIImage(data: data!) {
                                    self.profile_image = image
                                }
                            } else {
                                print(error)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getLinks() {
        @AppStorage("links") var links: String = ""
        let db = Firestore.firestore()
        let ref = db.collection("links")
        var temp_links = UserDefaults.standard.array(forKey: "myKey") as? [[String:String]] ?? []
        
        ref.whereField(FieldPath.documentID(), isEqualTo: links)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting email in getLinks: \(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        for documentData in document.data().values {
                            if let valueDict = documentData as? [String: String] {
                                temp_links.append(valueDict)
                            }
                        }
                    }
                }
                self.links = temp_links
                if self.links != [] {
                    self.sortLinksArray()
                }
            }
    }
    
    func getProducts() {
        @AppStorage("products") var products: String = ""
        let db = Firestore.firestore()
        let ref = db.collection("products")
        var temp_products = UserDefaults.standard.array(forKey: "myKey") as? [[String:String]] ?? []
        var temp_products_images = UserDefaults.standard.array(forKey: "myKey") as? [UIImage?] ?? []
        
        ref.whereField(FieldPath.documentID(), isEqualTo: products)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting email in getProducts: \(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        for documentData in document.data().values {
                            if let valueDict = documentData as? [String: String] {
                                temp_products.append(valueDict)
                                if valueDict["image"] != nil {
                                    let storageRef = Storage.storage().reference()
                                    let fileRef = storageRef.child(String(describing: valueDict["image"]!))
                                
                                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                                        if error == nil && data != nil {
                                            if let image = UIImage(data: data!) {
                                                temp_products_images.append(image)
                                                if temp_products_images.count == self.products?.count {
                                                    self.product_images = temp_products_images
                                                }
                                            }
                                        } else {
                                            print(error)
                                        }
                                    }
                    //                self.product_images = temp_products_images
                    //                print("Product Images are \(self.product_images)")
                                }
                            }
                        }
                    }
                }
                self.products = temp_products
                if self.products != [] {
                    self.sortProductsArray()
                }
            }
    }
    
    
    func sortProductsArray() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let sortedArray = self.products!.sorted(by: { dict1, dict2 in
            if let date1 = formatter.date(from: dict1["time_created"]!), let date2 = formatter.date(from: dict2["time_created"]!) {
                return date1.compare(date2) == .orderedAscending
            } else {
                return false
            }
        })
        self.products = sortedArray
    }
    
    func sortLinksArray() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let sortedArray = self.links!.sorted(by: { dict1, dict2 in
            if let date1 = formatter.date(from: dict1["time_created"]!), let date2 = formatter.date(from: dict2["time_created"]!) {
                return date1.compare(date2) == .orderedAscending
            } else {
                return false
            }
        })
        self.links = sortedArray
    }
}
