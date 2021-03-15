//
//  ViewController.swift
//  MilestoneProject 10-12
//
//  Created by Ryordan Panter on 15/3/21.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var photos = [Photo]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //UserDefaults
        
        let defaults = UserDefaults.standard
        
        if let savedPhoto = defaults.object(forKey: "photos") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                photos = try jsonDecoder.decode([Photo].self, from: savedPhoto)
            } catch {
                print("Failed to load Photos")
            }
        }
        
        
        // NavBar items:
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openCamera))
        
        title = "Pictures"
//        let test1 = Photos(image: "test", caption: "hello")
//        photos.append(test1)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath)
        let photo = photos[indexPath.item]
        cell.textLabel?.text = photo.caption
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let photo = photos[indexPath.item]
            
            let imagePath = getDocumentDirectory().appendingPathComponent(photo.image)
            vc.selectedImage = imagePath.path
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func getDocumentDirectory() -> URL{
        let paths = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)
        return paths[0]
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        let newPhoto = Photo(image: imageName, caption: "test")
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        addCaption(photos: newPhoto)
        photos.append(newPhoto)
        save()
    }
    
    @objc func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
    }
    // should make this a popup
    func addCaption(photos: Photo) {
        print("test")
        let ac = UIAlertController(title: "Add Photo Caption", message: "Test", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak self, weak ac] action in
            guard let newCaption = ac?.textFields?[0].text else {return}
            photos.caption = newCaption
            self?.save()
            
            self?.tableView.reloadData()
        })
        present(ac, animated: true)
//        tableView.reloadData()
        
    }
    
    func save() {
            let jsonEncoder = JSONEncoder()
            if let savedData = try? jsonEncoder.encode(photos) {
                let defaults = UserDefaults.standard
                defaults.setValue(savedData, forKey: "photos")
            } else {
                print("Failed to save people")
            }
        }

}

