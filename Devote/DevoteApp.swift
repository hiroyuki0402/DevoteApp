//
//  DevoteApp.swift
//  Devote
//
//  Created by SHIRAISHI HIROYUKI on 2023/11/03.
//

import SwiftUI

@main
struct DevoteApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
