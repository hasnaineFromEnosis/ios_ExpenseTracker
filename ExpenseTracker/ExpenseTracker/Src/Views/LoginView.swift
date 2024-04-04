//
//  LoginView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 5/4/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    var body: some View {
        ZStack {
            Image("backgroundImage")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.2)
            
            VStack(spacing: 70) {
                VStack {
                    Image(uiImage: UIImage(imageLiteralResourceName: "AppIcon"))
                        .resizable()
                        .frame(width: 150, height: 150)
                        .padding(.bottom)
                    
                    Text("Expense Tracker")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom)
                        .foregroundStyle(.accent)
                    
                    Text("Take control of your finances. Track your expenses with ease.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .foregroundStyle(.accent)
                }
                
                VStack(spacing: 16) {
                    SignInButton(imageName: "g.circle.fill", text: "Sign in with Google")
                    SignInButton(imageName: "apple.logo", text: "Sign in with Apple")
                }
            }
        }
    }
}

struct SignInButton: View {
    let imageName: String
    let text: String
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        Button{
            Task {
                authViewModel.signInWithGoogle { result in
                    print("Result: \(result)")
                }
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 24)
                
                Text(text)
                    .font(.headline)
                    .fontWeight(.regular)
            }
            .padding()
            .foregroundColor(.primary)
            .background(.background)
            .cornerRadius(10)
            .shadow(color: .primary, radius: 3, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}

#Preview {
    LoginView()
}
