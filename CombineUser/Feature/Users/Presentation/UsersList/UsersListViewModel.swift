//
//  UsersListViewModel.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import Combine
import Foundation

enum UsersListViewState {
    case idle
    case loading
    case loaded([UserCellViewItem])
    case failed(String)
}

struct UserCellViewItem: Hashable {
    let id: Int
    let title: String
    let subtitle: String
}

final class UsersListViewModel {
    @Published private(set) var state: UsersListViewState = .idle

    private let fetchUsers: FetchUsersUseCase
    private let fetchUserById: FetchUsersByIdUseCase
    private var bag = Set<AnyCancellable>()

    init(fetchUsers: FetchUsersUseCase, fetchUserById: FetchUsersByIdUseCase) {
        self.fetchUsers = fetchUsers
        self.fetchUserById = fetchUserById
    }

    func load() {
        self.state = .loading
        self.fetchUsers.execute()
            .map { users in
                users.map { UserCellViewItem(id: $0.id, title: $0.name, subtitle: $0.email) }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(err) = completion {
                    let message: String
                    switch err {
                    case .network:
                        message = "網路連線失敗"
                    case .server: 
                        message = "伺服器錯誤"
                    case .decoding: 
                        message = "資料解析失敗"
                    case .unknown: 
                        message = "未知錯誤"
                    }
                    self?.state = .failed(message)
                }
            }, receiveValue: { [weak self] items in
                self?.state = .loaded(items)
            })
            .store(in: &bag)
    }
}
