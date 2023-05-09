//
//  AuthViewModel.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import Foundation
import FirebaseAuth

class AuthViewModel : ObservableObject {
    let auth = Auth.auth()
    
    func signIn(username: String, email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Successful auth")
            }
        }
    }
    
}
