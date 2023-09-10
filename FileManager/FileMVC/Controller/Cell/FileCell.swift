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
    
    let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let fileSizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = .gray
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
        addSubview(previewImageView)
        addSubview(fileSizeLabel)
        
        NSLayoutConstraint.activate([
            fileNameLabel.leadingAnchor.constraint(equalTo: previewImageView.trailingAnchor, constant: 16),
            fileNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            fileNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            previewImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            previewImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            previewImageView.widthAnchor.constraint(equalToConstant: 50),
            previewImageView.heightAnchor.constraint(equalToConstant: 50),
            
            fileSizeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            fileSizeLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setPreviewImage(_ image: UIImage?) {
        previewImageView.image = image
    }
}

