//
//  AuthenticationManager.swift
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

class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var user: User?
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var displayName: String = ""
    
    private init() {
        registerAuthStateHandler()
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.displayName ?? "Invalid Name"
            }
        }
    }
    
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
                    self.user = firebaseUser
                    self.authenticationState = .authenticated
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.authenticationState = .unauthenticated
        }
        catch {
            print(error)
        }
    }
}
