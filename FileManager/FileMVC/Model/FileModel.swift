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
            var fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
            
            // Получение текущего состояния переключателя сортировки
            let isSortingEnabled = SettingsModel.shared.isSortingEnabled
            // Сортировка в алфавитном порядке, если переключатель активен
            if isSortingEnabled {
                fileURLs = fileURLs.sorted(by: { $0.lastPathComponent < $1.lastPathComponent })
            } else {
                // В противном случае сортировка в обратном порядке
                fileURLs = fileURLs.sorted(by: { $0.lastPathComponent > $1.lastPathComponent })
            }
            
            files.removeAll()
            files.append(contentsOf: fileURLs)
            delegate?.filesUpdated()
        } catch {
            print("Ошибка при получении списка файлов: \(error)")
        }
    }
    
    func renameFile(at index: Int, to newName: String) {
        let currentFileURL = files[index]
        let newFileURL = currentFileURL.deletingLastPathComponent().appendingPathComponent(newName)
        
        do {
            try FileManager.default.moveItem(at: currentFileURL, to: newFileURL)
            files[index] = newFileURL // Обновляем массив файлов с новым URL
            delegate?.filesUpdated() // Уведомляем делегата о изменениях
            print("Файл успешно переименован в: \(newFileURL)")
        } catch {
            print("Ошибка при переименовании файла: \(error)")
        }
    }
    
    func fileSize(at url: URL) -> Int64? {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
            if let fileSize = fileAttributes[.size] as? Int64 {
                return fileSize
            }
        } catch {
            print("Ошибка при получении размера файла: \(error)")
        }
        return nil
    }
}
