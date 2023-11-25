//
//  Homescreen.swift
//  wasteof.money
//
//  Created by Oren Lindsey on 10/21/23.
//

import SwiftUI

struct Homescreen: View {
    @State var text: String = ""
    @State var name = ""
    @State var hideLoader = false
    @State var token: String = "e"
    @State var credentials: Credentials = Credentials(username: "", password: "")
    @EnvironmentObject var session: Session
    @EnvironmentObject var user: CurrentUser
    var body: some View {
        if !hideLoader {
            ProgressView().onAppear() {
                var credentials: Credentials = Credentials(username: "", password: "")
                do {
                    credentials = try lookupToken()
                } catch {
                    print("Could not look up password \(error)")
                }
                if credentials.password.count > 0 {
                    print("logging in...")
                    wasteof_money.login(username: credentials.username, password: credentials.password, clear: true) { (isAuthenticated, tk,username,password) in
                        if isAuthenticated {
                            hideLoader = true
                            token = tk
                            name = credentials.username
                            DispatchQueue.main.async {
                                session.token = token
                            }
                        } else {
                            token = ""
                        }
                        //token = res
                     }
                    //return response
                    //print(login(credentials: credentials))
                } else {
                    print("password too short")
                    print("could not login \(credentials)")
                }
                print("token: \(token)")
            }
        } else {
            #if os(iOS)
            ZStack {
                    TabView {
                        Feed().tabItem {
                            Label("Home", systemImage: "house")
                        }.environmentObject(session).environmentObject(user)
                        Explore().tabItem {
                            Label("Explore", systemImage: "globe")
                        }.environmentObject(session).environmentObject(user)
                        YourAccount().tabItem {
                            Label("Your Account", systemImage: "person")
                        }.environmentObject(session).environmentObject(user)
                        Messages().tabItem {
                            Label("Messages", systemImage: "envelope")
                        }.environmentObject(session).environmentObject(user).navigationTitle("Messages")
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            PostEditor().environmentObject(session).environmentObject(user)
                        }.padding().padding([.bottom],50)
                    }
            }
            #else
            NavigationStack {
                Feed().tabItem {
                    Label("Home", systemImage: "globe")
                }.environmentObject(session).navigationTitle("@\(self.session.username)'s Feed")
            }
            #endif
        }
    }
}
/*func login(credentials: Credentials) -> String {
    var response = ""
    response = wasteof_money.login(username: credentials.username, password: credentials.password, clear: true, callback: parseResponse) /*{ (isAuthenticated, tk,username,password) -> String in
        var res = ""
        if isAuthenticated {
            res = tk
        } else {
            res = ""
        }
        return res
     }*/
    return response
}
func parseResponse(isAuthenticated: Bool, tk: String, username: String, password: String) -> String {
    var res = ""
    if isAuthenticated {
        res = tk
    } else {
        res = ""
    }
    return res
}*/
#Preview {
    Homescreen()
}
