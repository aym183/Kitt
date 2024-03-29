//
//  FormSelection.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI

struct FormSelection: View {
    var emojis = ["😎", "❤️"]
//    "🧘‍♀️", , "New Class Booking"
    var labels = ["New Product", "New Link"]
    @State var productFormShown = false
    @State var classFormShown = false
    @State var linkFormShown = false
    @State var linkEditShown = false
    @State var linkName = ""
    @State var linkURL = ""
    var links_number: Int
    var products_number: Int
    var classes_number: Int
    @State var oldProductName = ""
    @State var oldProductDesc = ""
    @State var oldProductPrice = ""
    @State var oldImage: UIImage?
    @State var oldIndex = ""
    @State var oldFileName = ""
    @State var oldFile = ""
    @State var file = ""
    @State var fileName = ""
    @State var productName = ""
    @State var productDesc = ""
    @State var productPrice = ""
    @State var image: UIImage?
    @State var oldClassName = ""
    @State var oldClassDesc = ""
    @State var oldClassPrice = ""
    @State var oldClassSeats = ""
    @State var oldClassLocation = ""
    @State var oldClassDuration = ""
    @State var oldClassImage: UIImage?
    @State var className = ""
    @State var classDesc = ""
    @State var classDuration = ""
    @State var classPrice = ""
    @State var classSeats = ""
    @State var classLocation = ""
    @State var classImage: UIImage?
    @ObservedObject var readData: ReadDB
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack {
                        Text("What would you like to add\nto your shop?").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.bold).padding(.vertical)
                            .padding(.leading, -20)
                        
                        ForEach(0..<2) { index in
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("TextField"))
                                    .frame(width: max(0, geometry.size.width-60), height: 70)
                                
                                HStack {
                                    Button(action: {
                                        if index == 0 {
                                            productFormShown.toggle()
                                        } else if index == 1{
                                            linkFormShown.toggle()
                                        }
                                        else if index == 2 {
                                            linkFormShown.toggle()
                                        }
                                    }) {
                                        Text("\(emojis[index])  \(labels[index])").foregroundColor(.black).font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.04))
                                            .fontWeight(.medium).padding(.leading, 30)
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.top,10)
                        }
                        
                        Spacer()
                    }
                    .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height-20))
                    }
                    .foregroundColor(.black)
                    .navigationDestination(isPresented: $productFormShown) {
                        ProductForm(oldIndex: $oldIndex, oldProductName: $oldProductName, oldProductDesc: $oldProductDesc, oldProductPrice: $oldProductPrice, oldImage: $oldImage, oldFile: $oldFile, oldFileName: $oldFileName, productName: $productName, productDesc: $productDesc, productPrice: $productPrice, image: $image, file: $file, fileName: $fileName, products_number: products_number, ifEdit: false, readData: readData)
                    }
                    .navigationDestination(isPresented: $linkFormShown) {
                        LinkForm(oldName: $linkName, oldURL: $linkURL, oldIndex: $oldIndex, linkName: $linkName, linkURL: $linkURL, ifEdit: false, products_number:  products_number, linkEditShown: $linkEditShown, readData: readData)
                    }
        }
    }
}
