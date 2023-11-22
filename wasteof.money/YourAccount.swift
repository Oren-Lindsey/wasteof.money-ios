//
//  YourAccount.swift
//  wasteof.money
//
//  Created by Oren Lindsey on 10/26/23.
//

import SwiftUI

struct YourAccount: View {
    @EnvironmentObject var session: Session
    var body: some View {
        Text(session.username)
    }
}

#Preview {
    YourAccount()
}
