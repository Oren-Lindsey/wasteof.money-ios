//
//  wasteof_moneyApp.swift
//  wasteof.money
//
//  Created by Oren Lindsey on 10/21/23.
//

import SwiftUI

@main
struct wasteof_moneyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            #if os(macOS)
                .frame(minWidth: 800, minHeight: 600)
            #endif
        }/*.commands {
            CommandGroup(replacing: .appInfo) {
                Button("About wasteof.money") {
                    NSApplication.shared.orderFrontStandardAboutPanel(
                        options: [
                            NSApplication.AboutPanelOptionKey.credits: NSAttributedString(
                                string: "The simple social media. (the name wasteof.money has nothing to do with the wastage of money.. honestly it just sounds funny.)",
                                attributes: [
                                    NSAttributedString.Key.font: NSFont.boldSystemFont(
                                        ofSize: NSFont.smallSystemFontSize)
                                ]
                            ),
                            NSApplication.AboutPanelOptionKey(
                                rawValue: "Copyright"
                            ): "© 2023 Oren Lindsey"
                        ]
                    )
                }
            }
        }*/
    }
}
