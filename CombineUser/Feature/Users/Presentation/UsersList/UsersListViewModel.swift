//
//  UsersListViewModel.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/23.
//

import Combine
import Foundation

protocol UsersListViewModelProtocol: ObservableObject {
    
    init(fetchUsers: FetchUsersUseCase)
    
    var state: ViewState { get }
    var users: [User] { get }
    var fetchUsers: FetchUsersUseCase { get }
    var bag: Set<AnyCancellable> { get set }
    
    func load(page: Int, size: Int)
    func refresh()
}

class UsersListViewModel: UsersListViewModelProtocol {
    
    @Published private(set) var users: [User] = []
    
    @Published private(set) var state: ViewState = .idle

    internal var fetchUsers: FetchUsersUseCase
    internal var bag = Set<AnyCancellable>()

    required init(fetchUsers: FetchUsersUseCase) {
        self.fetchUsers = fetchUsers
    }

    func load(page: Int, size: Int) {
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
                    self.state = .loaded
                    self.users += items
                } else {
                    self.state = .failed("沒有任何使用者資料")
                    
                }
               
            })
            .store(in: &self.bag)
    }
    
    func refresh() {
        self.users = []
        self.load(page: 1, size: 20)
    }
    
    
}
