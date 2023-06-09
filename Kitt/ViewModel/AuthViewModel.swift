//
//  AuthViewModel.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import AuthenticationServices
import CryptoKit
import GoogleSignIn
import GoogleSignInSwift

class AuthViewModel : ObservableObject {
    let auth = Auth.auth()
    fileprivate var currentNonce: String?

    func signUp(email: String, password: String, completion: @escaping (String?) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
                completion(error!.localizedDescription)
            } else {
                print("Successful auth")
                completion("Successful")
            }
        }
    }

    
    func signIn(email: String, password: String, completion: @escaping (String?) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                completion(error.localizedDescription)
            } else {
                print("Successful auth")
                completion("Successful")
            }
        }
    }
    
    func signOut(completion: @escaping (String?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion("Successful")
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
            completion("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
//    func signUpWithGoogle() {
//        
//    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email]
        randomNonceString() { response in
            if response != nil {
                self.currentNonce = response!
                request.nonce = self.sha256(response!)
            }
        }
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>, completion: @escaping (String?) -> Void) {
        if case .failure(let failure) = result {
          print(failure.localizedDescription)
        }
        else if case .success(let authorization) = result {
          if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
              guard let nonce = self.currentNonce else {
              print("Invalid state: a login callback was received, but no login request was sent.")
              return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
              print("Unable to fetdch identify token.")
              return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
              print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
              return
            }

            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Task {
              do {
                let result = try await Auth.auth().signIn(with: credential)
                completion("Success")
//                await updateDisplayName(for: result.user, with: appleIDCredential)
              }
              catch {
                print("Error authenticating: \(error.localizedDescription)")
              }
            }
          }
        }
    }
    
    private func randomNonceString(length: Int = 32, completion: @escaping (String?) -> Void) {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }
      
      completion(String(nonce))
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()
    
      return hashString
    }
    
}
