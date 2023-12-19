//
//  RS_OperativApp.swift
//  RS Operativ
//
//  Created by Preben Løite on 19/12/2023.
//

import SwiftUI

@main
struct RS_OperativApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
