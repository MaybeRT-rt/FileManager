//
//  FileCell.swift
//  FileManager
//
//  Created by Liz-Mary on 07.09.2023.
//

import Foundation
import UIKit

class FileCell: UITableViewCell {
    
    let fileNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        addSubview(fileNameLabel)
        
        NSLayoutConstraint.activate([
            fileNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            fileNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            fileNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            fileNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0)
        ])
    }
}

