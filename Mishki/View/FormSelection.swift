//
//  FormSelection.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI

struct FormSelection: View {
    var emojis = ["😎", "🧘‍♀️", "❤️"]
    var labels = ["New Product", "New Class Booking", "New Link"]
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
                        Text("What would you like to add \nto your shop?").font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.semibold).multilineTextAlignment(.leading).padding(.vertical).kerning(1.5)
                        
                        ForEach(0..<3) { index in
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("TextField"))
                                    .frame(width: geometry.size.width-60, height: 70)
                                
                                HStack {
                                    Button(action: {
                                        if index == 0 {
                                            productFormShown.toggle()
                                        } else if index == 1{
                                            classFormShown.toggle()
                                        } else if index == 2 {
                                            linkFormShown.toggle()
                                        }
                                    }) {
                                        Text("\(emojis[index])  \(labels[index])").foregroundColor(.black).font(Font.system(size: 15)).fontWeight(.medium).padding(.leading, 30).kerning(1.2)
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.top,10)
                        }
                        
                        Spacer()
                    }
                    .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                    }
                    .foregroundColor(.black)
                    .navigationDestination(isPresented: $productFormShown) {
//                        ProductForm(products_number: products_number)
                        ProductForm(oldProductName: $oldProductName, oldProductDesc: $oldProductDesc, oldProductPrice: $oldProductPrice, oldImage: $oldImage, productName: $productName, productDesc: $productDesc, productPrice: $productPrice, image: $image, products_number: products_number, ifEdit: false, readData: readData)
                    }
                    .navigationDestination(isPresented: $classFormShown) {
                        ClassForm(oldClassName: $oldClassName, oldClassDesc: $oldClassDesc, oldClassPrice: $oldClassPrice, oldClassDuration: $oldClassDuration, oldClassSeats: $oldClassSeats, oldClassLocation: $oldClassLocation, oldImage: $oldClassImage, className: $className, classDesc: $classDesc, classDuration: $classDuration, classPrice: $classPrice, classSeats: $classSeats, classLocation: $classLocation, image: $classImage, classes_number: classes_number, ifEdit: false)
                    }
                    .navigationDestination(isPresented: $linkFormShown) {
                        LinkForm(oldName: $linkName, oldURL: $linkURL, linkName: $linkName, linkURL: $linkURL, ifEdit: false, links_number:  links_number, linkEditShown: $linkEditShown, readData: readData)
                    }
        }
    }
}

//struct FormSelection_Previews: PreviewProvider {
//    static var previews: some View {
//        FormSelection()
//    }
//}
