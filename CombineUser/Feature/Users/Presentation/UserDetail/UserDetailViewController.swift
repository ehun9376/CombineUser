//
//  UserDetailViewController.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import UIKit
import Combine

class UserDetailViewController: UIViewController {
    
    private var bag = Set<AnyCancellable>()
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private lazy var adapter = TableViewAdapter(tableView: self.tableView)
    
    private let viewModel: UserDetailViewModel

    init(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.bind()
        self.viewModel.loadByUserId()
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
    
    func bind() {
        self.viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                guard let self = self else { return }
                switch state {

   
         
                case .failed(let message):
                    print(message)
                    //TODO: - showAlert
                default:
                    break
                }
            })
            .store(in: &self.bag)
        
        self.viewModel.$alertConfig
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {config in
                guard let config = config else { return }
                AlertPresenter.shared.showAlert(.simple(config: config))
            })
            .store(in: &self.bag)
                
    }
    
    func updateTableView(user: User) {
        let models: [UserCellViewItem] = [
            .init(id: user.id,
                  title: user.phone,
                  subtitle: user.website,
                  cellDidSelectAction: { [weak self] _ in
                      guard let self = self else { return }
                      self.viewModel.alertConfig = .init(title: "title", message: "message", actions: [ .cancel(), .confirm(),], prefersDismissOnBackgroundTap: true)
                  })
        ]
        self.adapter.updateRowModels(models)
            
    }

  
}
