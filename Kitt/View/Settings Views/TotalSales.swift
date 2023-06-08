//
//  TotalSales.swift
//  Kitt
//
//  Created by Ayman Ali on 06/06/2023.
//

import SwiftUI

struct TotalSales: View {
    var labels = ["last 7 days", "last 30 days", "all-time"]
    @ObservedObject var readData: ReadDB
//    @State var sales_amount: [Int]?
    
    var body: some View {
        var sales_amount = [readData.week_sales!["total"], readData.month_sales!["total"], readData.total_sales!["total"]]
        var sales_count = [readData.week_sales!["sales"], readData.month_sales!["sales"], readData.total_sales!["sales"]]
        var noOfSaleDates = readData.sale_dates?.count ?? 0
        var noOfSales = readData.sales?.count ?? 0
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack(alignment: .center) {
                    
                    HStack {
                        Text("Sales").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.bold).multilineTextAlignment(.leading).padding(.vertical)
                        Spacer()
                    }
                    .frame(width: geometry.size.width-40)
                    .padding(.leading, 10).padding(.bottom, -5).padding(.top, -5)
                    
                    TabView {
                        ForEach(0..<labels.count, id: \.self) { index in
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color("TextField"))
                                
                                VStack(alignment: .center) {
                                    
                                    Text(labels[index]).font(Font.custom("Avenir-Medium", size: 18))
                                    HStack(spacing: 2) {

                                        Text(String(describing: sales_amount[index]!)).font(Font.custom("Avenir-Heavy", size: 50)).fontWeight(.black)
                                        
                                        Text("aed").font(Font.custom("Avenir-Heavy", size: 25)).fontWeight(.black).padding(.bottom, -15)
                                    }
                                    .padding(.bottom, -20)
                                    
                                    if sales_count[index]! == 1 {
                                        Text("from \(String(describing:(sales_count[index]!))) customer").font(Font.custom("Avenir-Medium", size:18))
                                    } else {
                                        Text("from \(String(describing:(sales_count[index]!))) customers").font(Font.custom("Avenir-Medium", size:18))
                                    }
                                }
                            }
                            .frame(width: geometry.size.width-50, height: 130)
                            .id(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .padding(.top, -50)
                    .frame(height: 180)
                    .onAppear {
                        setupAppearance()
                    }

                    
                    HStack {
                        Text("Orders").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.bold).multilineTextAlignment(.leading).padding(.vertical)
                        Spacer()
                    }
                    .frame(width: geometry.size.width-40)
                    .padding(.leading, 10).padding(.bottom, -5).padding(.top, -20)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            if noOfSaleDates != 0 {
                                ForEach(readData.sale_dates!, id: \.self) { index in
                                    HStack {
                                        Text(index).font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.045)).fontWeight(.bold).foregroundColor(.gray)
                                        Spacer()
                                    }
                                    .id(index)
                                    .padding(.horizontal, 15)
                                    
                                    ForEach(0..<noOfSales, id: \.self) { sale_index in
                                        if index == String(describing: readData.sales![sale_index]["date"]!) {
                                            HStack(spacing: -5) {
                                                ZStack {
                                                    Image(uiImage: readData.loadProductImage(key: String(describing: readData.sales![sale_index]["image"]!)))
                                                        .resizable()
                                                        .scaledToFill()
                                                }
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(5)

                                                VStack(alignment: .leading, spacing: 6) {
                                                    Text(String(describing: readData.sales![sale_index]["name"]!))
                                                        .font(Font.custom("Avenir-Heavy", size: 15))
                                                    Text(verbatim: String(describing: readData.sales![sale_index]["email"]!))
                                                        .font(Font.custom("Avenir-Medium", size: 13))
                                                        .fontWeight(.bold)
                                                        .foregroundColor(.gray)
                                                }
                                                .padding(.horizontal, 15).padding(.trailing, 30)
                                                //                                    .frame(width: 230)

                                                Spacer()

                                                VStack(alignment: .trailing, spacing: 8) {
                                                    Text("\(String(describing: readData.sales![sale_index]["price"]!)) aed").font(Font.custom("Avenir-Heavy", size: 15)).fontWeight(.bold)

                                                    Text("").font(Font.custom("Avenir-Medium", size: 14)).foregroundColor(.gray).fontWeight(.bold)
                                                    //                                        .padding(.trailing, 20.5)
                                                }
                                                .padding(.leading, -25)
                                            }
                                            .frame(width: geometry.size.width-50, height: 50)
                                            .padding(.bottom, 5).padding(.horizontal, 15)
                                            .id(sale_index)
                                        }
                                        

                                    }
                                }
                                //                            .padding(.leading, 2)
                                
                            }
                        }
//                        .padding(.leading, 15)
                        
                    }
                    .padding(.top, -15)
                    .refreshable {
                        readData.getSales()
                    }
                }
                .frame(width: geometry.size.width-40, height: geometry.size.height-20)
                .foregroundColor(.black)
            }
        }
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
      }
}

//struct TotalSales_Previews: PreviewProvider {
//    static var previews: some View {
//        TotalSales()
//    }
//}
