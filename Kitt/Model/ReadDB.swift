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
    @Published var sales: [[String: Any]]? = []
    @Published var classes: [[String: String]]? = []
    @Published var week_sales: [String: Int]? = ["total": 0, "sales": 0]
    @Published var month_sales: [String: Int]? = ["total": 0, "sales": 0]
    @Published var total_sales: [String: Int]? = ["total": 0, "sales": 0]
    @Published var temp_values: [[String: String]]? = []
//    @Published var sale_dates: [String]? = []
    @Published var sale_dates: [String]? = []
    @Published var profile_image: UIImage? = nil
    @Published var link_elements_check = false
    @Published var product_elements_check = false
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
//                                temp_links.append(valueDict)
                                temp_links.append(valueDict)
                            }
                        }
                    }
                }
                
//                self.products! = temp_links
                    
                self.links = temp_links
                self.temp_values = self.products
                self.products = temp_links
                self.products!.append(contentsOf: self.temp_values!)
                if self.products != [] {
                    self.sortProductsArray()
                }
//                self.link_elements_check = true
                
               
            }
    }
    
    func getUserDetails(email: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("users")
        let storage = Storage.storage()
        let storageRef = storage.reference()
            
        ref.whereField("email", isEqualTo: email)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting userDetils: \(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        UserDefaults.standard.set(document.data()["username"]!, forKey: "username")
                        UserDefaults.standard.set(document.data()["links"]!, forKey: "links")
                        UserDefaults.standard.set(document.data()["products"]!, forKey: "products")
                        UserDefaults.standard.set(document.data()["classes"]!, forKey: "classes")
                        UserDefaults.standard.set(document.data()["sales"]!, forKey: "sales")
                        UserDefaults.standard.set(document.data()["tiktok"]!, forKey: "tiktok")
                        UserDefaults.standard.set(document.data()["facebook"]!, forKey: "facebook")
                        UserDefaults.standard.set(document.data()["website"]!, forKey: "website")
                        UserDefaults.standard.set(document.data()["youtube"]!, forKey: "youtube")
                        UserDefaults.standard.set(document.data()["instagram"]!, forKey: "instagram")
                        let imageRef = storageRef.child(String(describing: document.data()["profile_image"]!))
                        
                        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                                if let error = error {
                                    print("Error fetching image: \(error.localizedDescription)")
                                    completion(nil)
                                    return
                                }
                                
                                if let data = data, let image = UIImage(data: data) {
                                    UserDefaults.standard.set(image.jpegData(compressionQuality: 0.8), forKey: "profile_image")
                                    print("profile image retrieved")
                                    completion("Successful")
                                } else {
                                    print("profile image not retrieved")
                                }
                            }
                        
//                        UserDefaults.standard.set(nil, forKey: "profile_image")
//                        for documentData in document.data() {
//                            print(documentData)
//                        }
                    }
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
//                self.getLinks()
//                self.product_elements_check = true
                if self.products != [] {
                    self.sortProductsArray()
                }
//                self.getLinks()
            }
    }
    
    func getSales() {
        @AppStorage("sales") var sales: String = ""
        let db = Firestore.firestore()
        let ref = db.collection("sales")
        var temp_sales = UserDefaults.standard.array(forKey: "myKey") as? [[String:Any]] ?? []
        let oneWeekAgo = Date().addingTimeInterval(-7 * 24 * 60 * 60)
        let oneMonthAgo = Date().addingTimeInterval(-31 * 24 * 60 * 60)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        sales
        
        ref.whereField(FieldPath.documentID(), isEqualTo: sales)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting sales in getSales: \(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        for documentData in document.data().values {
                            temp_sales.append(documentData as! [String : Any])
                        }
                    }
                }
                
                self.sales = temp_sales
                
                
//                if let date = dateFormatter.date(from: dateString) {
//                    dateFormatter.dateFormat = "dd MMMM"
//                    let formattedDate = dateFormatter.string(from: date)
//                    print(formattedDate) // Output: 07 June
//                }
                
                if self.sales!.count != 0 {
                    
//                    for index in 0..<self.sales!.count {
//                        let date = (self.sales![index]["date"]! as AnyObject).dateValue()
//                        dateFormatter.dateFormat = "dd MMMM YYYY"
//                        let formattedDate = dateFormatter.string(from: date)
//                        self.sales![index]["date"]! = formattedDate
//                    }
                    var temp_week_sales = 0
                    var temp_month_sales = 0
                    var temp_total_sales = 0
                    var temp_week_amount = 0
                    var temp_month_amount = 0
                    var temp_total_amount = 0
                    
                    for index in 0..<self.sales!.count {
                        let date = (self.sales![index]["date"]! as AnyObject).dateValue()
                        dateFormatter.dateFormat = "dd MMMM YYYY"
                        let formattedDate = dateFormatter.string(from: date)
                        self.sales![index]["date"]! = formattedDate
                        
                        if !self.sale_dates!.contains(formattedDate) {
                            self.sale_dates!.append(formattedDate)
                        }
                        
                        if (date.compare(oneWeekAgo) == .orderedDescending) {
                            temp_week_amount += Int(String(describing: self.sales![index]["price"]!))!
                            temp_month_amount += Int(String(describing: self.sales![index]["price"]!))!
                            temp_total_amount += Int(String(describing: self.sales![index]["price"]!))!
                            
                            temp_week_sales += 1
                            temp_month_sales += 1
                            temp_total_sales += 1
                            
                        } else if (date.compare(oneMonthAgo) == .orderedDescending) {
                            temp_month_amount += Int(String(describing: self.sales![index]["price"]!))!
                            temp_total_amount += Int(String(describing: self.sales![index]["price"]!))!
                            temp_month_sales += 1
                            temp_total_sales += 1
                        } else {
                            temp_total_amount += Int(String(describing: self.sales![index]["price"]!))!
                            temp_total_sales += 1
                        }
                    }
                    self.week_sales!["total"] = temp_week_amount
                    self.month_sales!["total"] = temp_month_amount
                    self.total_sales!["total"] = temp_total_amount
                    self.week_sales!["sales"] = temp_week_sales
                    self.month_sales!["sales"] = temp_month_sales
                    self.total_sales!["sales"] = temp_total_sales
                    if self.sale_dates != [] {
                        self.sortDatesDescending()
                    }
                }
                if self.sales!.count != 0 {
                    self.sortArrayByTime()
                }
            }
    }
    
    
    func sortProductsArray() {
        let sortedArray = self.products?.sorted(by: { dict1, dict2 in
            guard let index1 = Int(dict1["index"]!),
                  let index2 = Int(dict2["index"]!) else {
                return false
            }
            
            return index1 < index2
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
    
    func sortDatesDescending() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy" // Update the date format
            
        let sortedDates = self.sale_dates!.sorted { dateString1, dateString2 in
               guard let date1 = dateFormatter.date(from: dateString1),
                     let date2 = dateFormatter.date(from: dateString2) else {
                   return false // Invalid date format
               }
               return date1 > date2
           }
        
        self.sale_dates = sortedDates
            
    }
    
    func sortArrayByTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"

        let sortedTime = self.sales!.sorted(by: { dict1, dict2 in
            if let date1 = dateFormatter.date(from: String(describing: dict1["time"]!)), let date2 = dateFormatter.date(from: String(describing:dict2["time"]!)) {
                return date1.compare(date2) == .orderedDescending
            } else {
                return false
            }
        })
        
        self.sales = sortedTime
    }
}
