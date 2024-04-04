//
//  AuthenticationViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 5/4/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

class AuthenticationViewModel: ObservableObject {
    func signInWithGoogle(completion: @escaping (Bool) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found")
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller")
            completion(false)
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { userAuthentication, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let user = userAuthentication?.user,
                  let idToken = user.idToken else {
                completion(false)
                return
            }
            
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                
                if let firebaseUser = authResult?.user {
                    print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "invalid")")
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
}
