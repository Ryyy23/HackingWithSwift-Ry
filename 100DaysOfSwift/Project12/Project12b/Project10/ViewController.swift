//
//  ViewController.swift
//  Project10
//
//  Created by Ryordan Panter on 13/7/20.
//  Copyright © 2020 Ryordan Panter. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(cameraOrLibary))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.backgroundColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        
        return cell
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        let person = Person(name: "Unkown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        dismiss(animated: true)
        
    }
    @objc func cameraOrLibary() {
        let picker = UIImagePickerController()
        let ac = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
        let cameraButton = UIAlertAction(title: "Camera", style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.openCamera()
        })
        let LibaryButton = UIAlertAction(title: "Libary", style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.pickimage()
        })
        if isCameraAvailable == false {
            cameraButton.isEnabled = false
        } else {
            cameraButton.isEnabled = true
        }
        picker.delegate = self
        ac.addAction(cameraButton)
        ac.addAction(LibaryButton)
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        self.present(ac, animated: true, completion: nil)
        }
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
        
    }
    
    func pickimage(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
           let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
        
    }
        
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func renamePerson(person: Person) {
        print("renamePerson working")
            let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            ac.addTextField()
        
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
            ac.addAction(UIAlertAction(title: "Ok", style: .default) {
                [weak self, weak ac] action in
                guard let newName = ac?.textFields?[0].text else { return }
                person.name = newName
        
                self?.collectionView.reloadData()
                })
        
            present(ac, animated: true)
        
    }
    
    @objc func deletePerson(person: Person, index: IndexPath) {
        print("deletePerson working")
        people.remove(at: index.item)
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename or Delete", message: nil, preferredStyle: .alert)
        
        let renameButton = UIAlertAction(title: "Rename", style: .default) {
            [weak self] _ in
            self?.renamePerson(person: person)
        }
        let deleteButton = UIAlertAction(title: "Delete", style: .default) {
            [weak self] _ in
            self?.deletePerson(person: person, index: indexPath)
        }
        ac.addAction(deleteButton)
        ac.addAction(renameButton)
        present(ac, animated: true)
        
    }
    
    
    


}

