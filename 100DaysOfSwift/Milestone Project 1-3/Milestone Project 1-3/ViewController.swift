//
//  ViewController.swift
//  Milestone Project 1-3
//
//  Created by Ryordan Panter on 17/6/20.
//  Copyright © 2020 Ryordan Panter. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    //countries we will use, will grab them from app bundle
    var countries = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //View Title
        title = "Countries of the World"
        
        //Large title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath! //+ "/countries"
        print(path)
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.hasSuffix("3x.png") {
                //let tempitem = item.replacingOccurrences(of: "@3x", with: "")
                countries.append(item)
            }

        }
        print(countries)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        // Cell Label
        cell.textLabel?.text = countries[indexPath.row].replacingOccurrences(of: "@3x.png", with: "").capitalized
        // Cell image preview
        cell.imageView?.image = UIImage(named: countries[indexPath.row])
        // Cell Border
        cell.imageView?.layer.borderWidth = 2
        // Cell Bordercolor
        cell.imageView?.layer.borderColor = UIColor.white.cgColor
        // Cell row height
        self.tableView.rowHeight = 75
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

