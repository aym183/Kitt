//
//  ReadDb.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import Foundation
import Firebase
import SwiftUI

class ReadDB : ObservableObject {
    
    @Published var links: [[String: String]]? = []
    @Published var products: [[String: String]]? = []
    
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
            }
    }
    
    func getProducts() {
        @AppStorage("products") var products: String = ""
        let db = Firestore.firestore()
        let ref = db.collection("products")
        var temp_products = UserDefaults.standard.array(forKey: "myKey") as? [[String:String]] ?? []
        
        ref.whereField(FieldPath.documentID(), isEqualTo: products)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting email in getProducts: \(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        for documentData in document.data().values {
                            if let valueDict = documentData as? [String: String] {
                                temp_products.append(valueDict)
                            }
                        }
                    }
                }
                self.products = temp_products
            }
    }
}
