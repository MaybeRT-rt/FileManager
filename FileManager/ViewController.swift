//
//  ViewController.swift
//  FileManager
//
//  Created by Liz-Mary on 06.09.2023.
//

import UIKit

class ViewController: UIViewController {
    private var files: [URL] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
       return tableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setupTableView()
        loadFilesFromDocuments()
    }
    
    func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить фото", style: .plain, target: self, action: #selector(addPhotoButtonTapped))

        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([

            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FileCell.self, forCellReuseIdentifier: "FileCell")
    }
    
    private func loadFilesFromDocuments() {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Директория Documents не найдена")
            return
        }
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
            print(fileURLs)
            files.removeAll()
            files.append(contentsOf: fileURLs)
            tableView.reloadData()
        } catch {
            print("Ошибка при получении списка файлов: \(error)")
        }
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
        return files.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as? FileCell else {
            return UITableViewCell()
        }
        
        let fileURL = files[indexPath.row]
        cell.fileNameLabel.text = fileURL.lastPathComponent
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let fileURLToRemove = files[indexPath.row]
            
            do {
                try FileManager.default.removeItem(at: fileURLToRemove)
                files.remove(at: indexPath.row)
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
            if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileName = "photo_\(Date().timeIntervalSince1970).jpg"
                let fileURL = documentsURL.appendingPathComponent(fileName)
                if let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
                    do {
                        try imageData.write(to: fileURL)
                    
                        files.append(fileURL)
                        tableView.reloadData()
                    } catch {
                        print("Ошибка при сохранении файла: \(error)")
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

