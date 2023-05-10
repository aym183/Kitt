//
//  DeleteDB.swift
//  Mishki
//
//  Created by Ayman Ali on 10/05/2023.
//

import Foundation
import SwiftUI
import Firebase

class DeleteDB : ObservableObject {
    
    func deleteLink(name: String, url: String) {
        @AppStorage("links") var links: String = ""
        let db = Firestore.firestore()
        let ref = db.collection("links")
        var temp_entries = UserDefaults.standard.array(forKey: "myKey") as? [String: [String:String]] ?? [:]
        
        ref.whereField(FieldPath.documentID(), isEqualTo: links)
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
    
    func deleteProduct(image: String) {
        @AppStorage("products") var products: String = ""
        let db = Firestore.firestore()
        let ref = db.collection("products")
        var temp_entries = UserDefaults.standard.array(forKey: "myKey") as? [String: [String:String]] ?? [:]
        
        ref.whereField(FieldPath.documentID(), isEqualTo: products)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error finding product to delete: \(error.localizedDescription)")
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
                                print("Error deleting product: \(error.localizedDescription)")
                            } else {
                                print("Product deleted successfully")
                                UserDefaults.standard.removeObject(forKey: image)
                            }
                        }
                    }
                }
            }
    }
    
}

//                                    UserDefaults.standard.removeObject(forKey: image)
//                                    db.collection("products").document(document.documentID).delete() { error in
//                                        if let error = error {
//                                            print("Error removing document: \(error)")
//                                        } else {
//                                            print("Document successfully removed!")
//                                        }
//                                    }
