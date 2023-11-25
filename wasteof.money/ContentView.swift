//
//  ContentView.swift
//  wasteof.money
//
//  Created by Oren Lindsey on 10/21/23.
//

import SwiftUI
@MainActor class LoggedIn: ObservableObject {
    @Published var li: Bool = false
}
@MainActor class Session: ObservableObject {
    @Published var username: String = ""
    @Published var token: String = ""
}
@MainActor class CurrentUser: ObservableObject {
    @Published var name: String = ""
    @Published var id: String = ""
    @Published var bio: String = ""
    @Published var verified: Bool = false
    @Published var permissions: Permissions = Permissions(admin: false, banned: false)
    @Published var beta: Bool = false
    @Published var color: String = "indigo"
    @Published var links: [Link] = []
    @Published var history: History = History(joined: 0)
    @Published var stats: UserStats = UserStats(followers: 0, following: 0, posts: 0)
    @Published var online: Bool = false
}
struct ContentView: View {
    @State var color: Color = Color.green
    @ObservedObject var loggedIn: LoggedIn = LoggedIn()
    @ObservedObject var session: Session = Session()
    @ObservedObject var user: CurrentUser = CurrentUser()
    let localLoggedIn = LoggedIn()
    init() {
        /*[kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity].forEach {
                let status = SecItemDelete([
                  kSecClass: $0,
                  kSecAttrSynchronizable: kSecAttrSynchronizableAny
                ] as CFDictionary)
                if status != errSecSuccess && status != errSecItemNotFound {
                    //Error while removing class $0
                }
              }*/
        var credentials: Credentials = Credentials(username: "", password: "")
        do {
            credentials = try lookupToken()
        } catch {
            print("Could not look up token \(error)")
            localLoggedIn.li = false
        }
        if credentials.password.count > 0 {
            localLoggedIn.li = true
            session.username = credentials.username
        } else {
            localLoggedIn.li = false
        }
        loggedIn = localLoggedIn
    }
    var body: some View {
        EmptyView().onAppear() {
            var credentials: Credentials = Credentials(username: "", password: "")
            do {
                credentials = try lookupToken()
            } catch {
                print("Could not look up token \(error)")
                loggedIn.li = false
            }
            if credentials.password.count > 0 {
                loggedIn.li = true
                session.username = credentials.username
            } else {
                loggedIn.li = false
            }
        }
        if loggedIn.li {
            if session.username != "" {
                    Homescreen().environmentObject(session).environmentObject(user).tint(color).onAppear() {
                        getColor(username: session.username)
                    }
            } else {
                ProgressView()
            }
        } else {
            VStack {
                Text("wasteof.money")
                    .font(.title)
                Image(systemName: "dollarsign.square")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                LoginView(loggedIn: loggedIn)
            }.padding()
        }
    }
    func getColor(username: String) {
        guard let url = URL(string: "https://api.wasteof.money/users/\(username)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("error with the data: \(error!)")
                return
            }
            do {
                let api = try JSONDecoder().decode(User.self, from:data)
                DispatchQueue.main.async {
                    user.name = api.name
                    user.id = api.id
                    user.bio = api.bio
                    user.verified = api.verified
                    user.permissions = api.permissions
                    user.beta = api.beta
                    user.history = api.history
                    user.color = api.color
                    user.links = api.links
                    user.stats = api.stats
                    user.online = api.online
                    color = {
                        switch api.color {
                        case "red":
                            return Color.red
                        case "orange":
                            return Color.orange
                        case "yellow":
                            return Color.yellow
                        case "green":
                            return Color.green
                        case "teal":
                            return Color.teal
                        case "blue":
                            return Color.blue
                        case "indigo":
                            return Color.indigo
                        case "violet":
                            return Color.purple
                        case "fuchsia":
                            return Color.pink
                        case "pink":
                            return Color.pink
                        case "gray":
                            return Color.gray
                        case "rainbow":
                            return Color.gray
                        default:
                            return Color.green
                        }
                    }()
                }
            } catch {
                print("error decoding: \(error)")
            }
        }
        task.resume()
    }
}
func lookupToken() throws -> Credentials {
    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword, kSecAttrServer as String: Credentials.server,kSecMatchLimit as String: kSecMatchLimitOne,kSecReturnAttributes as String: true,kSecReturnData as String: true]
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status != errSecItemNotFound else { throw KeychainError.noPassword }
    guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    guard let existingItem = item as? [String : Any],
        let passwordData = existingItem[kSecValueData as String] as? Data,
        let password = String(data: passwordData, encoding: String.Encoding.utf8),
        let account = existingItem[kSecAttrAccount as String] as? String
    else {
        throw KeychainError.unexpectedPasswordData
    }
                let credentials = Credentials(username: account, password: password)
    return credentials
}
#Preview {
    ContentView()
}
