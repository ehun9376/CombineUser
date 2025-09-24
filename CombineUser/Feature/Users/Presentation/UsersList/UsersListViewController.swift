//
//  UsersListViewController.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import UIKit
import Combine

class UsersListViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private lazy var tableViewAdapter = TableViewAdapter(tableView: self.tableView)
    
    private let viewModel: UsersListViewModel
    
    private var bag = Set<AnyCancellable>()

    init(viewModel: UsersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "Users"
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.bind()
        self.viewModel.load()
    }
    
    func setupView() {
        self.view.backgroundColor = .systemBackground

        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    private func bind() {
        self.viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .idle, .loading:
                    break
                case .loaded(let data):
                    guard let items = data as? [User] else { return }
                    self.applySnapshot(items: items)
                case .failed(let message):
                    self.showErrorAlert(message)
                }
            })
            .store(in: &bag)
    }
    
    func applySnapshot(items: [User]) {
        var rowModels: [CellRowModel] = []
        
        for item in items {
            let rowModel = UserCellViewItem(id: item.id,
                                            title: item.name,
                                            subtitle: item.email,
                                            cellDidSelectAction: { [weak self] _ in
                guard let self = self else { return }
                self.pushToUserDetail(userId: item.id)
            })
            rowModels.append(rowModel)
            
        }
        
        self.tableViewAdapter.updateRowModels(rowModels)
    }
    
    func pushToUserDetail(userId: Int) {
        let apiClient = APIClient(baseURL: APIURL.jsonPlaceholder.rawValue)
        let repo = UsersRepositoryImpl(api: apiClient)
        let detailVM = UserDetailViewModel(fetchUserById: FetchUsersByIdUseCase(repository: repo), userId: userId)
        let detailVC = UserDetailViewController(viewModel: detailVM)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func showErrorAlert(_ message: String) {
        let ac = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }


}
