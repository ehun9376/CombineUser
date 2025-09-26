//
//  UserCell.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/24.
//

import UIKit

struct UserCellViewItem: CellRowModel {

    func cellDidSelect(model: any CellRowModel) {
        self.cellDidSelectAction?(model)
    }
    
    
    func getTableViewCellInitType() -> TableViewCellInitType {
        return .code(type: UserCell.self, cellID: "UserCell")
    }

    let id: Int
    let title: String
    let subtitle: String
    var cellDidSelectAction: ((any CellRowModel) -> ())?
}

class UserCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.selectionStyle = .none
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            self.titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4),
            self.subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            self.subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            self.subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    
    
    
}

extension UserCell: CellViewBase {
    func setupCellView(model: any CellRowModel) {
        guard let model = model as? UserCellViewItem else { return }
        self.titleLabel.text = model.title
        self.subtitleLabel.text = model.subtitle
    }
    

}
    
