//
//  ViewController.swift
//  FileManager
//
//  Created by Liz-Mary on 06.09.2023.
//

import UIKit

class ViewController: UIViewController, FileModelDelegate {
    
    private let model = FileModel()
    private let tbView = FileListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        model.delegate = self
        model.loadFilesFromDocuments()
        setupView()
        setupTableView()
    }
    
    func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить фото", style: .plain, target: self, action: #selector(addPhotoButtonTapped))
        
        view.addSubview(tbView.tableView)
        
        NSLayoutConstraint.activate([
            tbView.tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tbView.tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tbView.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tbView.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupTableView() {
        tbView.tableView.delegate = self
        tbView.tableView.dataSource = self
        tbView.tableView.register(FileCell.self, forCellReuseIdentifier: "FileCell")
    }
    
    func filesUpdated() {
        tbView.tableView.reloadData()
    }
    
    @objc private func addPhotoButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Documents"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.files.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as? FileCell else {
            return UITableViewCell()
        }
        
        let fileURL = model.files[indexPath.row]
        cell.fileNameLabel.text = fileURL.lastPathComponent
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let fileURLToRemove = model.files[indexPath.row]
            
            do {
                try FileManager.default.removeItem(at: fileURLToRemove)
                model.files.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Ошибка при удалении файла: \(error)")
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            print("Выбрано изображение: \(selectedImage)")
            
            if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileName = "photo_\(Date().timeIntervalSince1970).jpg"
                let fileURL = documentsURL.appendingPathComponent(fileName)
                if let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
                    do {
                        try imageData.write(to: fileURL)
                        model.loadFilesFromDocuments()
                        print("Изображение успешно сохранено по пути: \(fileURL)")
                    } catch {
                        print("Ошибка при сохранении файла: \(error)")
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
