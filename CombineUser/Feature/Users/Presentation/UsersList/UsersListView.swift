//
//  UsersListView.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/30.
//

import SwiftUI
import Combine

// MARK: - Main Users List View

struct UsersListView: View {
    
    @StateObject private var viewModel: UsersListViewModel
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    
    init(viewModel: UsersListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle:
                IdleView()
                
            case .loading:
                LoadingView()
                
            case .loaded:
                UsersContentView(
                    users: viewModel.users,
                    onUserTap: { user in
                        navigationCoordinator.push(.userDetail(user))
                    },
                    onRefresh: {
                        viewModel.refresh()
                    }
                )
                
            case .failed(let message):
                ErrorView(
                    message: message,
                    onRetry: {
                        viewModel.load(page: 1, size: 20)
                    }
                )
            }
        }
        .navigationTitle("Users")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Refresh") {
                    viewModel.refresh()
                }
                .disabled(viewModel.state == .loading)
            }
        }
        .onAppear {
            if case .idle = viewModel.state {
                viewModel.load(page: 1, size: 20)
            }
        }
    }
}

// MARK: - State-specific Views

struct IdleView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.3")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Ready to load users")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading users...")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
}

struct UsersContentView: View {
    let users: [User]
    let onUserTap: (User) -> Void
    let onRefresh: () -> Void
    
    var body: some View {
        List(users) { user in
            UserRowView(user: user)
                .onTapGesture {
                    onUserTap(user)
                }
        }
        .refreshable {
            onRefresh()
        }
        .listStyle(PlainListStyle())
    }
}

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Error")
                .font(.title)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry") {
                onRetry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// MARK: - User Row View

struct UserRowView: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(Color.blue.gradient)
                .frame(width: 50, height: 50)
                .overlay {
                    Text(user.name.prefix(1))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text("@\(user.username)")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Preview

#Preview {
    let mockAppContainer = AppContainer()
    let mockUsersContainer = UsersContainer(parent: mockAppContainer)
    let mockViewModel: UsersListViewModel = mockUsersContainer.resolve()
    let mockNavigationCoordinator = NavigationCoordinator(appContainer: mockAppContainer)
    
    return NavigationStack {
        UsersListView(viewModel: mockViewModel)
            .environmentObject(mockNavigationCoordinator)
    }
}
