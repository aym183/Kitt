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
    
    func deleteLink() {
        
    }
    
    func deleteProduct(image: String) {
        @AppStorage("products") var products: String = ""
        let db = Firestore.firestore()
        let ref = db.collection("products")
        
        ref.whereField(FieldPath.documentID(), isEqualTo: products)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error finding product to delete: \(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        for documentData in document.data().keys {
                            print(documentData)
//                            if let valueDict = documentData as? [String: String], let dict_image = valueDict["image"] {
//                                if dict_image == image {
//                                    db.collection("products").document(document.documentID).delete() { error in
//                                        if let error = error {
//                                            print("Error removing document: \(error)")
//                                        } else {
//                                            print("Document successfully removed!")
//                                        }
//                                    }
//                                }
//                            }
                        }
                    }
                }
            }
    }
    
}
