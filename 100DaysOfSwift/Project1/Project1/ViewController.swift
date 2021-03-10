//
//  ViewController.swift
//  Project1
//
//  Created by Ryordan Panter on 11/6/20.
//  Copyright © 2020 Ryordan Panter. All rights reserved.
//

import UIKit
class Picture: NSObject, Comparable, Codable {
    static func < (lhs: Picture, rhs: Picture) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func == (lhs: Picture, rhs: Picture) -> Bool {
        return lhs.name! < rhs.name!
    }
    
    var name: String?
    var count: Int?
    var image: String?
    
    init(name: String?, count: Int?, image: String?) {
        self.name = name
        self.count = count
        self.image = image
    }
}

class ViewController: UITableViewController {
    var pictures = [Picture]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetUserDefualts()
        
        // View Title
        title = "Storm Viewer"
        
        // Large titles
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendApp))
        // put on backgroud thread
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            let fm = FileManager.default
//            let path = Bundle.main.resourcePath!
//            let items = try! fm.contentsOfDirectory(atPath: path)
//
//            for item in items {
//                if item.hasPrefix("nssl") {
//                    self?.pictures.append(item)
//                }
//            }
//            self?.pictures.sort()
//        }
//        performSelector(inBackground: #selector(loadPictures), with: nil)
//        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
//        loadPictures()
//        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let pic = pictures[indexPath.item]
        cell.textLabel?.text = pic.name
        cell.detailTextLabel?.text = String(pic.count ?? 0)
        cell.detailTextLabel?.textColor = .white
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let picture = pictures[indexPath.item]
//            vc.selectedImage = pic.[indexPath.item]
            vc.selectedImage = picture.image
            print(indexPath.row + 1)
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            count(picture:picture )

            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func GetUserDefualts() {
        
        // UserDefualts
        let defaults = UserDefaults.standard

        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
            } catch {
                print("Failed to load pictures")
            }
        }
        if pictures.isEmpty {
            performSelector(inBackground: #selector(loadPictures), with: nil)
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }
        
    }
    func count(picture: Picture) {
        
        var newCount = picture.count ?? 0
        newCount += 1
        picture.count = newCount
        print("\(picture.name ?? "Error") + \(picture.count ?? 0)")
        save()
        tableView.reloadData()
    }
    @objc func loadPictures() {
        let fm = FileManager.default
                   let path = Bundle.main.resourcePath!
                   let items = try! fm.contentsOfDirectory(atPath: path)
                   
                   for item in items {
                       if item.hasPrefix("nssl") {
                        print(item)
                        // remove filename path extension eg: .jpg
                        let name = (item as NSString).deletingPathExtension
                        let picture = Picture(name: name, count: 0, image: item)
                            pictures.append(picture)
                        }
                   }
        pictures.sort()
        save()
    }
    // share app
    @objc func recommendApp() {
        print("test")
        
        
        // use real itunes web address
        if let urlStr = NSURL(string: "https://google.com") {
            let objectsToShare = [urlStr]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            // needed to stop crashing on ipad.
            activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.setValue(savedData, forKey: "pictures")
        } else {
            print("Failed to save pictures")
        }
        
    }
}
