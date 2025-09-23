//
//  UsersListViewController.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import UIKit
import Combine

class UsersListViewController: UIViewController {
    enum Section {
        case main
    }

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var dataSource: UITableViewDiffableDataSource<Section, UserCellViewItem>?
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
        
        self.dataSource = UITableViewDiffableDataSource<Section, UserCellViewItem>(tableView: self.tableView) {
            tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.subtitle
            cell.accessoryType = .disclosureIndicator
            return cell
        }

        self.bind()
        self.viewModel.load()
    }
    
    func setupView() {
        self.view.backgroundColor = .systemBackground

        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.delegate = self
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
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .idle, .loading:
                    break
                case .loaded(let items):
                    var snap = NSDiffableDataSourceSnapshot<Section, UserCellViewItem>()
                    snap.appendSections([.main  ])
                    snap.appendItems(items, toSection: .main)
                    self.dataSource?.apply(snap, animatingDifferences: true)
                case .failed(let message):
                    let ac = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
            .store(in: &bag)
    }


}


extension UsersListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        
        let vm = UserDetailViewModel(
            title: item.title,
            lines: [
                ("Email", item.subtitle)
            ]
        )
        let vc = UserDetailViewController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
    
