//
//  ViewController.swift
//  Project7
//
//  Created by Ryordan Panter on 1/7/20.
//  Copyright © 2020 Ryordan Panter. All rights reserved.
//

import UIKit


class ViewController: UITableViewController {
    
    var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString: String

        //Most Recent Tab
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        // Top Rated Tab
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url){
                // we're OK to parse!
                parse(json: data)
                return
            }
        }
        showError()
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController ()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "404 cannot load feed", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    


}

