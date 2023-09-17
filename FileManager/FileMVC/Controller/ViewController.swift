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
    private let imageModel = ImageModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        model.delegate = self
        model.loadFilesFromDocuments()
        setupView()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.loadFilesFromDocuments()
    }
    
    func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить фото", style: .plain, target: self, action: #selector(addPhotoButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .systemMint
        
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
        DispatchQueue.main.async {
            self.tbView.tableView.reloadData()
        }
    }
    
    func showEditFileNameDialog(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Изменить имя файла", message: "Введите новое имя файла:", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Новое имя файла"
        }
        
        let renameAction = UIAlertAction(title: "Изменить", style: .default) { [weak self] _ in
            if let newName = alertController.textFields?.first?.text {
                if !newName.isEmpty {
                    self?.model.renameFile(at: indexPath.row, to: newName)
                } else {
                    print("Имя файла не может быть пустым.")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertController.addAction(renameAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
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
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as? FileCell else {
            return UITableViewCell()
        }
        
        let fileURL = model.files[indexPath.row]
        let fileName = fileURL.lastPathComponent
        
        cell.fileNameLabel.text = fileName
        
        let previewImage = imageModel.loadPreviewImage(for: fileURL)
        cell.setPreviewImage(previewImage)
        
    
        if let fileSize = model.fileSize(at: fileURL) {
            let fileSizeInMB = Double(fileSize) / (1024 * 1024) 
            let fileSizeText = String(format: "%.2f МБ", fileSizeInMB)
            cell.fileSizeLabel.text = fileSizeText
        } else {
            cell.fileSizeLabel.text = "Размер неизвестен"
        }
        
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
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Изменить") { [weak self] (action, view, completionHandler) in
            self?.showEditFileNameDialog(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .systemMint
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            print("Выбрано изображение: \(selectedImage)")
            
            if let fileURL = imageModel.saveImage(selectedImage) {
                model.loadFilesFromDocuments()
                print("Изображение успешно сохранено по пути: \(fileURL)")
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
