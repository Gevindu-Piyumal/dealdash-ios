//
//  dealdash_iosApp.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-22.
//

import CoreData
import SwiftUI

@main
struct dealdash_iosApp: App {
    let coreDataManager = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            BottomTabBarView()
                .environment(\.managedObjectContext, coreDataManager.context)
        }
    }
}
