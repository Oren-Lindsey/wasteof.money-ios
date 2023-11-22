//
//  LoginView.swift
//  wasteof.money
//
//  Created by Oren Lindsey on 10/21/23.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loggedIn: LoggedIn
    @State var username = ""
    @State var password = ""
    @State var isAuthenticated: Bool = false
    @State var text = ""
    @State var hideLoader: Bool = true
    var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                Text("Sign In").font(.title2)
                TextField("Username", text: $username).textContentType(.username)
                
                SecureField("Password", text: $password).textContentType(.password)
                if hideLoader == false {
                    ProgressView().accentColor(.accentColor).progressViewStyle(.circular)
                } else {
                    Button(action: login) {
                        Image(systemName: "arrow.right")
                        Text("Go")
                    }
                }
            }.padding([.leading, .trailing], 5).textFieldStyle(.roundedBorder).frame(maxWidth: 1000).disabled(!hideLoader)
        Text(text)
        if isAuthenticated {
            NavigationLink() {
                Homescreen()
            } label: {
                EmptyView()
            }
        }
    }
    func login() {
        hideLoader = false
        wasteof_money.login(username: username.lowercased(), password: password, clear: true) { (isAuthenticated, token, username, password) in
            hideLoader = true
            if isAuthenticated {
                text = "Logged in successfully! Last 3 characters of token: \(String(token.suffix(3)))"
                loggedIn.li = true
            } else {
                text = "Error logging in! Full error: \"\(token)\""
            }
         }
    }
}
#Preview {
    LoginView(loggedIn: LoggedIn())
}
