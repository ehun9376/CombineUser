//
//  UserDetailViewModel.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import Combine
import Foundation

class UserDetailViewModel {
    
    private var bag = Set<AnyCancellable>()
    
    @Published private(set) var state: ViewState<User> = .idle
    
    @Published var alertConfig: SimpleAlertConfig?

    private let fetchUserById: FetchUsersByIdUseCase
    
    var userId: Int?
    
    init(fetchUserById: FetchUsersByIdUseCase, userId: Int? = nil) {
        self.fetchUserById = fetchUserById
        self.userId = userId
    }
    
    func loadByUserId() {
        guard let userId else { return }
        self.state = .loading
        self.fetchUserById.execute(by: userId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(err) = completion {
                    self?.state = .failed(err.localizedDescription)
                }
            },
                  receiveValue: { [weak self] value in
                guard let self else { return }
                self.state = .loaded(value)
            })
            .store(in: &bag)
        
    }

   
}
