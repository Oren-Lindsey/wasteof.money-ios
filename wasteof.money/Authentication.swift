//
//  LoginViewModel.swift
//  wasteof.money
//
//  Created by Oren Lindsey on 10/21/23.
//

import Foundation
struct User: Hashable, Codable {
    var name: String
    var id: String
    var bio: String
    var verified: Bool
    var permissions: Permissions
    var beta: Bool
    var color: String
    var links: [Link]
    var history: History
    var stats: UserStats
    var online: Bool
}
struct UserStats: Hashable, Codable {
    var followers: Int
    var following: Int
    var posts: Int
}
struct Credentials {
    var username: String
    var password: String
    static let server = "wasteof.money"
}
enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
func login(username: String, password: String, clear: Bool, callback: ((Bool, String, String, String) -> ())? = nil) {
    //let defaults = UserDefaults.standard
    var result: String = ""
    let url = URL(string: "https://api.wasteof.money/session")
    guard let requestUrl = url else { fatalError() }
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
    //let postString = "username=\(username)&password=\(password)"
    /*struct LoginData: Hashable, Codable {
        let username: String
        let password: String
    }*/
    struct BodyData: Codable {
        // Define your data model here.
        // This struct should conform to Codable if you want to send it in the request body.
        let username: String
        let password: String
    }
    let body = BodyData(username: username, password: password)
    let finalBody = try? JSONEncoder().encode(body)
    request.httpBody = finalBody
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error took place \(error)")
            result = error.localizedDescription
            callback!(false, result, username, password)
        } else {
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                struct LoginResponse: Decodable {
                    let token: String
                }
                let jsonData = dataString.data(using: .utf8)!
                var response: LoginResponse = LoginResponse(token: "")
                do {
                    response = try JSONDecoder().decode(LoginResponse.self, from: jsonData)
                } catch DecodingError.keyNotFound(_, _) {
                    callback!(false, "Username or password incorrect", username, password)
                } catch {
                    callback!(false, error.localizedDescription, username, password)
                }
                //dataReturn = data
                //LoginViewModel().data = data
                result = response.token
                if result.count < 1 {
                    callback!(false, "Username or password incorrect", username, password)
                } else {
                    do {
                        try savePassword(username: username, password: password, clear: clear)
                        callback!(true, result, username, password)
                    } catch KeychainError.unhandledError(let status) {
                        print("Keychain Error, status is: \(status)")
                        callback!(false, "Could not save password to keychain.", username, password)
                    } catch {
                        callback!(false, "Something went wrong...", username, password)
                    }
                }
                
                //return data
            }
        }
    }
    task.resume()
}
func savePassword(username: String, password: String, clear: Bool) throws {
    if clear {
        [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity].forEach {
            let status = SecItemDelete([
                kSecClass: $0,
                kSecAttrSynchronizable: kSecAttrSynchronizableAny
            ] as CFDictionary)
            if status != errSecSuccess && status != errSecItemNotFound {
                // no error handling lol
            }
        } //clear all keychain
    }
    let credentials: Credentials = Credentials(username: username, password: password)
    let account = credentials.username
    let password = credentials.password.data(using: String.Encoding.utf8)!
    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrAccount as String: account,
                                kSecAttrServer as String: Credentials.server,
                                kSecValueData as String: password]
    let status = SecItemAdd(query as CFDictionary, nil)
    guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    print("Saved successfully!")
}
