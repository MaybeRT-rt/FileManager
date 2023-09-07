//
//  FileModel.swift
//  FileManager
//
//  Created by Liz-Mary on 07.09.2023.
//

import Foundation

class FileModel {
    
    var files: [URL] = []
    
    weak var delegate: FileModelDelegate?

    
    func loadFilesFromDocuments() {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Директория Documents не найдена")
            return
        }
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
            files.removeAll()
            files.append(contentsOf: fileURLs)
            delegate?.filesUpdated()
        } catch {
            print("Ошибка при получении списка файлов: \(error)")
        }
    }
}
