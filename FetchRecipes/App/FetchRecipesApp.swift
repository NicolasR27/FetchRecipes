//
//  FetchRecipesApp.swift
//  FetchRecipes
//
//  Created by Nicolas Rios on 4/11/25.
//

import SwiftUI

@main
struct FetchRecipesApp: App {
    @StateObject private var serviceContainer = ServiceContainer()
    @StateObject private var appCoordinator: AppCoordinator
    
    init() {
        _appCoordinator = StateObject(wrappedValue: AppCoordinator(container: ServiceContainer()))
    }
    
    var body: some Scene {
        WindowGroup {
            appCoordinator.start()
                .environmentObject(serviceContainer)
                .preferredColorScheme(.light)
                .tint(.orange)
        }
    }
}
