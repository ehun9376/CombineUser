//
//  UsersListViewModel.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import Combine
import Foundation

class UsersListViewModel {
    @Published private(set) var state: ViewState<[User]> = .idle

    private let fetchUsers: FetchUsersUseCase
    private var bag = Set<AnyCancellable>()

    init(fetchUsers: FetchUsersUseCase) {
        self.fetchUsers = fetchUsers
    }

    func load() {
        self.state = .loading
        self.fetchUsers.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(err) = completion {
                    self?.state = .failed(err.localizedDescription)
                }
            },
                  receiveValue: { [weak self] items in
                guard let self else { return }
                
                if !items.isEmpty {
                    self.state = .loaded(items)
                } else {
                    self.state = .failed("沒有任何使用者資料")
                    
                }
               
            })
            .store(in: &self.bag)
    }
}
