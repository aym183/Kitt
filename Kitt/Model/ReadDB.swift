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
import FirebaseFirestore

class ReadDB : ObservableObject {
    
    @Published var links: [[String: String]]? = []
    @Published var products: [[String: String]]? = []
    @Published var classes: [[String: String]]? = []
    @Published var profile_image: UIImage? = nil
    @Published var product_images: [UIImage?] = []
    @Published var classes_images: [UIImage?] = []
    
//    func getProfileImage() {
//        let db = Firestore.firestore()
//        let collectionRef = db.collection("users")
//        @AppStorage("username") var userName: String = ""
//
//        collectionRef.whereField("username", isEqualTo: userName).getDocuments { (snapshot, error) in
//            if let error = error {
//                print("Error getting profile image: \(error)")
//            } else {
//                for document in snapshot!.documents {
//                    if document.data()["profile_image"] != nil {
//                        let storageRef = Storage.storage().reference()
//                        let fileRef = storageRef.child(String(describing: document.data()["profile_image"]!))
//
//                        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
//                            if error == nil && data != nil {
//                                if let image = UIImage(data: data!) {
//                                    self.profile_image = image
//                                }
//                            } else {
//                                print(error)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
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
    
    func getClasses() {
        @AppStorage("classes") var classes: String = ""
        let db = Firestore.firestore()
        let ref = db.collection("classes")
        var temp_classes = UserDefaults.standard.array(forKey: "myKey") as? [[String:String]] ?? []
        var temp_classes_images = UserDefaults.standard.array(forKey: "myKey") as? [UIImage?] ?? []
        
        ref.whereField(FieldPath.documentID(), isEqualTo: classes)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting email in getClasses: \(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        for documentData in document.data().values {
                            if let valueDict = documentData as? [String: String] {
                                temp_classes.append(valueDict)
                            }
                        }
                    }
                }
                
                // Fix image positioning
                self.classes = temp_classes
                if self.classes != [] {
                    self.sortClassesArray()
                }
            }
    }
    
    func loadProfileImage(completion: @escaping (UIImage?) -> Void) {
        if let imageData = UserDefaults.standard.data(forKey: "profile_image"), let cachedImage = UIImage(data: imageData)  {
                completion(cachedImage)
                return
        }
    }
    
    func loadProductImage(key: String) -> UIImage {
        let imageData = UserDefaults.standard.data(forKey: key)
        let cachedImage = UIImage(data: imageData!)
        return cachedImage!
        
        
//        var temp_images = UserDefaults.standard.array(forKey: "myKey") as? [UIImage] ?? []
        
//        for product in self.products! {
//            if let imageData = UserDefaults.standard.data(forKey: product["image"]!), let cachedImage = UIImage(data: imageData)  {
//                temp_images.append(cachedImage)
//            }
//        }
//        self.product_images = temp_images
//        print("all product images loaded")
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
//                                if valueDict["image"] != nil {
//                                    let storageRef = Storage.storage().reference()
//                                    let fileRef = storageRef.child(String(describing: valueDict["image"]!))
//
//                                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
//                                        if error == nil && data != nil {
//                                            if let image = UIImage(data: data!) {
//                                                temp_products_images.append(image)
//
//
//
//                                                if temp_products_images.count == self.products?.count {
//                                                    self.product_images = temp_products_images
//                                                }
//                                            }
//                                        } else {
//                                            print(error)
//                                        }
//                                    }
//                    //                self.product_images = temp_products_images
//                    //                print("Product Images are \(self.product_images)")
//                                }
                            }
                        }
                    }
                }
                
                // Fix image positioning
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
//        self.loadProductImage()
    }
    
    func sortClassesArray() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let sortedArray = self.classes!.sorted(by: { dict1, dict2 in
            if let date1 = formatter.date(from: dict1["time_created"]!), let date2 = formatter.date(from: dict2["time_created"]!) {
                return date1.compare(date2) == .orderedAscending
            } else {
                return false
            }
        })
        self.classes = sortedArray
//        self.loadProductImage()
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