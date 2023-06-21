//
//  DeleteDB.swift
//  Mishki
//
//  Created by Ayman Ali on 10/05/2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

class DeleteDB : ObservableObject {
    
    func deleteLink(name: String, url: String, completion: @escaping (String?) -> Void) {
        @AppStorage("products") var products: String = ""
        let db = Firestore.firestore()
        let ref = db.collection("products")
        var temp_entries = UserDefaults.standard.array(forKey: "myKey") as? [String: [String:String]] ?? [:]
        let rtRef = Database.database().reference().child("products")
        let userRef = rtRef.child(products)
        
        ref.whereField(FieldPath.documentID(), isEqualTo: products)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error finding product to delete: \(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        for documentData in document.data() {
                            if let valueDict = documentData.value as? [String: String] {
                                if valueDict["name"] != name && valueDict["url"] != url {
                                    temp_entries[documentData.key] = valueDict
                                }
                            }
                        }
                        userRef.setValue(temp_entries) { (error, _) in
                            if let error = error {
                                print("Failed to delete link in realtime db: \(error)")
                            } else {
                                print("Link deleted realtime")
                                completion("Deleted")
                            }
                        }
                        ref.document(document.documentID).setData(temp_entries) { error in
                            if let error = error {
                                print("Error deleting link: \(error.localizedDescription)")
                            } else {
                                print("Link deleted successfully")
                            }
                        }
                    }
                }
            }
    }
    
    func deleteProduct(name: String, completion: @escaping (String?) -> Void) {
        @AppStorage("products") var products: String = ""
        let db = Firestore.firestore()
        let ref = db.collection("products")
        var temp_entries = UserDefaults.standard.array(forKey: "myKey") as? [String: [String:String]] ?? [:]
        let rtRef = Database.database().reference().child("products")
        let userRef = rtRef.child(products)
        
        ref.whereField(FieldPath.documentID(), isEqualTo: products)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error finding product to delete: \(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        for documentData in document.data() {
                            if let valueDict = documentData.value as? [String: String], let dict_name = valueDict["name"] {
                                if dict_name != name {
                                    temp_entries[documentData.key] = valueDict
                                }
                            }
                        }
                        userRef.setValue(temp_entries) { (error, _) in
                            if let error = error {
                                print("Failed to delete product in realtime db: \(error)")
                            } else {
                                print("Product deleted realtime")
                                completion("Deleted")
                            }
                        }
                        
                        ref.document(document.documentID).setData(temp_entries) { error in
                            if let error = error {
                                print("Error deleting product: \(error.localizedDescription)")
                            } else {
                                print("Product deleted successfully")
                            }
                        }
                    }
                }
            }
    }
    
    func deleteClass(image: String, completion: @escaping (String?) -> Void) {
        @AppStorage("classes") var classes: String = ""
        let db = Firestore.firestore()
        let ref = db.collection("classes")
        var temp_entries = UserDefaults.standard.array(forKey: "myKey") as? [String: [String:String]] ?? [:]
        
        
        ref.whereField(FieldPath.documentID(), isEqualTo: classes)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error finding class to delete: \(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        for documentData in document.data() {
                            if let valueDict = documentData.value as? [String: String], let dict_image = valueDict["image"] {
                                if dict_image != image {
                                    temp_entries[documentData.key] = valueDict
                                }
                            }
                        }
                        ref.document(document.documentID).setData(temp_entries) { error in
                            if let error = error {
                                print("Error deleting class: \(error.localizedDescription)")
                            } else {
                                completion("Deleted")
                                UserDefaults.standard.removeObject(forKey: image)
                            }
                        }
                    }
                }
            }
    }
    
}
