//
//  PayoutDetails.swift
//  Kitt
//
//  Created by Ayman Ali on 14/06/2023.
//

import SwiftUI

struct PayoutDetails: View {
    @State private var isEditingTextField = false
    @State var bank_name = ""
    @State var full_name = ""
    @State var account_number = ""
    @State var iban = ""
    @State var bankDetailsUpdated = false
    var areAllFieldsEmpty: Bool {
        return bank_name.isEmpty || full_name.isEmpty || account_number.isEmpty || iban.isEmpty
    }
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack{
                        HStack {
                            Text("Payout Details").font(Font.custom("Avenir-Heavy", size: min(geometry.size.width, geometry.size.height) * 0.06)).fontWeight(.bold).multilineTextAlignment(.leading).padding(.vertical).padding(.leading)
                            
                            Spacer()
                            }
                        
                        TextField("", text: $bank_name, prompt: Text("Bank Name").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: max(0, geometry.size.width-70), height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).font(Font.custom("Avenir-Medium", size: 16)).padding(.bottom, 10)
                            .onTapGesture {
                                isEditingTextField = true
                            }
                        
                        TextField("", text: $full_name, prompt: Text("Full Name").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: max(0, geometry.size.width-70), height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).font(Font.custom("Avenir-Medium", size: 16)).padding(.bottom, 10)
                            .onTapGesture {
                                isEditingTextField = true
                            }
                        
                        
                        ZStack {
                            TextField("", text: $account_number, prompt: Text("Account Number").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: max(0, geometry.size.width-70), height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).keyboardType(.decimalPad).autocapitalization(.none).autocorrectionDisabled(true).font(Font.custom("Avenir-Medium", size: 16)).padding(.bottom, 10)
                                .onChange(of: self.account_number, perform: { value in
                                       if value.count > 8 {
                                           self.account_number = String(value.prefix(8))
                                      }
                                })
                                .onTapGesture {
                                    isEditingTextField = true
                                }
                            
                            if account_number.count > 0 {
                                HStack {
                                    Spacer()
                                        Text("\(8 - account_number.count)")
                                            .foregroundColor(.black)
                                            .font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                            .fontWeight(.bold)
                                }
                                .padding(.trailing, 30).padding(.top, -8)
                                .frame(height: 60)
                        }
                        }
                        
                        ZStack {
                            TextField("", text: $iban, prompt: Text("IBAN").foregroundColor(.gray).font(Font.custom("Avenir-Black", size: 16))).padding().frame(width: max(0, geometry.size.width-70), height: 60).foregroundColor(.black).background(Color("TextField")).cornerRadius(10).font(Font.custom("Avenir-Medium", size: 16)).autocapitalization(.none).autocorrectionDisabled(true).padding(.bottom, 10)
                                .onChange(of: self.iban, perform: { value in
                                       if value.count > 23 {
                                           self.iban = String(value.prefix(23))
                                      }
                                })
                                .onTapGesture {
                                    isEditingTextField = true
                                }
                            
                            if iban.count > 0 {
                                HStack {
                                    Spacer()
                                        Text("\(23 - iban.count)")
                                            .foregroundColor(.black)
                                            .font(Font.custom("Avenir-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                            .fontWeight(.bold)
                                }
                                .padding(.trailing, 30).padding(.top, -8)
                                .frame(height: 60)
                        }
                            
                        }
                        
                        
                        Spacer()
                        
                        Button(action: {
                            DispatchQueue.global(qos: .userInteractive).async {
                                UpdateDB().updateBankDetails(fullName: full_name, bankName: bank_name, accountNumber: account_number, iban: iban) { response in
                                    if response == "Successful" {
                                        print("Bank Details Updated!")
                                        bankDetailsUpdated.toggle()
                                    }
                                }
                            }
                        }) {
                            Text("Update").font(Font.custom("Avenir-Black", size: min(geometry.size.width, geometry.size.height) * 0.06)).frame(width: max(0, geometry.size.width-70), height: 60).background(areAllFieldsEmpty ? Color.gray : Color.black).foregroundColor(areAllFieldsEmpty ? Color.black : Color.white).cornerRadius(10)
                        }
                        .padding(.bottom)
                        .disabled(areAllFieldsEmpty)
                        
                        }
                        .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height-20))
                        }
                        .onTapGesture {
                            isEditingTextField = false
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                        .onAppear {
                            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                                isEditingTextField = false
                            }
                        }
                        .foregroundColor(.black)
                        .navigationDestination(isPresented: $bankDetailsUpdated) {
                            HomePage(isShownHomePage: false, isChangesMade: true, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false).navigationBarHidden(true)
                        }
                    }
    }
}

struct PayoutDetails_Previews: PreviewProvider {
    static var previews: some View {
        PayoutDetails()
    }
}
