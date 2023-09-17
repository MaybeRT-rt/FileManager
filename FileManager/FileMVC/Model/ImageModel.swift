//
//  ImageModel.swift
//  FileManager
//
//  Created by Liz-Mary on 10.09.2023.
//

import Foundation
import UIKit

class ImageModel {
    
    var count = 0
    
    func saveImage(_ image: UIImage) -> URL? {
        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            count += 1
            let fileName = "photo_\(count).jpg"
            let fileURL = documentsURL.appendingPathComponent(fileName)
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                do {
                    try imageData.write(to: fileURL)
                    return fileURL
                } catch {
                    print("Ошибка при сохранении файла: \(error)")
                }
            }
        }
        return nil
    }
    
    func loadPreviewImage(for fileURL: URL) -> UIImage? {
        if let imageData = try? Data(contentsOf: fileURL),
           let image = UIImage(data: imageData) {
            return image
        }
        return nil
    }
}
