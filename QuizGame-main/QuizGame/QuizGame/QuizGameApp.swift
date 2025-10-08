//
//  QuizGameApp.swift
//  QuizGame
//
//  Created by Jonathan Soo on 10/5/2025.
//

import SwiftUI

@main
struct QuizGameApp: App {
    @StateObject private var navigationState = NavigationState()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationState.routes) {
                IndroductionView()
                    .navigationDestination(for: Routes.self) { route in
                        switch route {
                        case .mainNavigation(let routes):
                            MainRouter(routes: routes).configure()
                        }
                    }
            }
            .environmentObject(navigationState)
        }
    }
}
