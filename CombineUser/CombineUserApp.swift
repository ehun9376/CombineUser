//
//  CombineUserApp.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/30.
//

import SwiftUI

@main
struct CombineUserApp: App {
    
    // MARK: - Dependencies
    
    private let appContainer = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appContainer)
                .environmentObject(NavigationCoordinator(appContainer: appContainer))
        }
    }
}

// MARK: - Main Content View

struct ContentView: View {
    @EnvironmentObject private var appContainer: AppContainer
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    
    var body: some View {
        NavigationWrapper {
            TabView {
                let usersContainer = UsersContainer(parent: appContainer)
                let viewModel: UsersListViewModel = usersContainer.resolve()
                
                UsersListView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Users")
                    }
                
                // Settings Tab (Future expansion)
                NavigationWrapper {
                    SettingsView()
                }
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }
          
        }
        .sheet(item: $navigationCoordinator.sheet) { destination in
            NavigationBuilder(appContainer: appContainer).sheet(for: destination)
        }
        .fullScreenCover(item: $navigationCoordinator.fullScreenCover) { destination in
            NavigationBuilder(appContainer: appContainer).fullScreen(for: destination)
        }
    }
}

// MARK: - Navigation Wrapper

struct NavigationWrapper<Content: View>: View {
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    @EnvironmentObject private var appContainer: AppContainer
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.path) {
            content
                .navigationDestination(for: Destination.self) { destination in
                    NavigationBuilder(appContainer: appContainer).view(for: destination)
                }
        }
    }
}




// MARK: - Preview

#Preview {
    ContentView()
        .environmentObject(AppContainer())
        .environmentObject(NavigationCoordinator(appContainer: AppContainer()))
}
