//
//  SwiftUICoordinator.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/30.
//

import SwiftUI
import Combine

// MARK: - Navigation Path for SwiftUI

@MainActor
class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: SheetDestination?
    @Published var fullScreenCover: FullScreenDestination?
    
    private let appContainer: AppContainer
    
    init(appContainer: AppContainer) {
        self.appContainer = appContainer
    }
    
    // MARK: - Navigation Methods
    
    func push(_ destination: Destination) {
        path.append(destination)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func presentSheet(_ sheet: SheetDestination) {
        self.sheet = sheet
    }
    
    func presentFullScreen(_ destination: FullScreenDestination) {
        self.fullScreenCover = destination
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissFullScreen() {
        self.fullScreenCover = nil
    }
}

// MARK: - Destination Types

enum Destination: Hashable {
    case userDetail(User)
    case settings
}

enum SheetDestination: Identifiable {
    case userDetail(User)
    case settings
    
    var id: String {
        switch self {
        case .userDetail(let user):
            return "userDetail_\(user.id)"
        case .settings:
            return "settings"
        }
    }
}

enum FullScreenDestination: Identifiable {
    case onboarding
    case login
    
    var id: String {
        switch self {
        case .onboarding:
            return "onboarding"
        case .login:
            return "login"
        }
    }
}

// MARK: - Navigation Builder

struct NavigationBuilder {
    let appContainer: AppContainer
    
    @ViewBuilder
    func view(for destination: Destination) -> some View {
        switch destination {
        case .userDetail(let user):
            UserDetailView(user: user)
            
        case .settings:
            SettingsView()
        }
    }
    
    @ViewBuilder
    func sheet(for destination: SheetDestination) -> some View {
        switch destination {
        case .userDetail(let user):
            UserDetailView(user: user)
            
        case .settings:
            SettingsView()
        }
    }
    
    @ViewBuilder
    func fullScreen(for destination: FullScreenDestination) -> some View {
        switch destination {
        case .onboarding:
            OnboardingView()
            
        case .login:
            LoginView()
        }
    }
}

// MARK: - Placeholder Views

struct OnboardingView: View {
    var body: some View {
        VStack {
            Text("Onboarding")
                .font(.title)
            Text("Welcome to CombineUser!")
                .font(.body)
        }
    }
}

struct LoginView: View {
    var body: some View {
        VStack {
            Text("Login")
                .font(.title)
            Text("Please sign in")
                .font(.body)
        }
    }
}

// MARK: - Navigation Extensions

extension View {
    func navigationCoordinator(_ coordinator: NavigationCoordinator) -> some View {
        self.environmentObject(coordinator)
    }
}
