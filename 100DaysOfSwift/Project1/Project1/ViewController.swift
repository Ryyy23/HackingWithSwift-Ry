//
//  ViewController.swift
//  Project1
//
//  Created by Ryordan Panter on 11/6/20.
//  Copyright © 2020 Ryordan Panter. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        performSelector(inBackground: #selector(loadPictures), with: nil)
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            
            print(indexPath.row + 1)
            
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func loadPictures() {
        let fm = FileManager.default
                   let path = Bundle.main.resourcePath!
                   let items = try! fm.contentsOfDirectory(atPath: path)
                   
                   for item in items {
                       if item.hasPrefix("nssl") {
                           pictures.append(item)
                       }
                   }
                   pictures.sort()
        
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
}

