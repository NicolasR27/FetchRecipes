//
//  FetchRecipesApp.swift
//  FetchRecipes
//
//  Created by Nicolas Rios on 4/11/25.
//

import SwiftUI

@main
struct FetchRecipesApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            appCoordinator.start()
        }
    }
}
