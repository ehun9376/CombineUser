//
//  Untitled.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/24.
//

import UIKit

//TODO: - 拓展成section

enum TableViewCellInitType {
    case code(type: UITableViewCell.Type, cellID: String)
    case nib(nibName: String, bundle: Bundle?, cellID: String)
}

protocol CellRowModel {
    func getTableViewCellInitType() -> TableViewCellInitType
    func cellDidSelect(model: CellRowModel)
    var cellDidSelectAction: ((CellRowModel) -> ())? { get set }
}

protocol CellViewBase {
    func setupCellView(model: CellRowModel)
}

class TableViewAdapter: NSObject {
    
    var tableView: UITableView
    
    var rowModels: [CellRowModel] = []
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func updateRowModels(_ models: [CellRowModel]) {
        self.rowModels = models
        self.regisCells(models: models)
        self.tableView.reloadData()
    }
    
    func regisCells(models: [CellRowModel]) {
        for model in models {
            switch model.getTableViewCellInitType() {
            case .code(let type, let cellID):
                self.tableView.register(type, forCellReuseIdentifier: cellID)
            case .nib(let nibName, let bundle, let cellID):
                self.tableView.register(UINib(nibName: nibName, bundle: bundle), forCellReuseIdentifier: cellID)
            }
        }
 
    }
    
}

extension TableViewAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.rowModels[indexPath.row]
        
        switch model.getTableViewCellInitType() {
        case .code(_, let cellID), .nib(_, _, let cellID):
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            if let cell = cell as? CellViewBase {
                cell.setupCellView(model: model)
            }
            return cell
        }

    }
 
}


extension TableViewAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.rowModels[indexPath.row]
        model.cellDidSelect(model: model)
    }
    
    
    
}
