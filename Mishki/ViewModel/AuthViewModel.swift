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
    
    func signUp(email: String, password: String, completion: @escaping (String?) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
                completion("Unsuccessful")
            } else {
                print("Successful auth")
                completion("Successful")
            }
        }
    }

    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Successful auth")
            }
        }
    }
    
}
