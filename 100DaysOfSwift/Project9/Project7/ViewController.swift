//
//  ViewController.swift
//  Project7
//
//  Created by Ryordan Panter on 1/7/20.
//  Copyright © 2020 Ryordan Panter. All rights reserved.
//

import UIKit


class ViewController: UITableViewController ,UISearchResultsUpdating {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(showCredit))
        // Old search button
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPetitions))
        setupSearchController()

        performSelector(inBackground: #selector(fetchJSON), with: nil)
        //fetchJSON()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredPetitions.count
        }
        return petitions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition: Petition
        if searchController.isActive && searchController.searchBar.text != "" {
            petition = filteredPetitions[indexPath.row]
        } else {
            petition = petitions[indexPath.row]
        }
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    @objc func fetchJSON() {
        var urlString: String
        switch navigationController?.tabBarItem.tag {
               case 1:
                   urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
               default:
                   urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
               }

        //Most Recent Tab
//            if navigationController?.tabBarItem.tag == 0 {
//                // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
//                urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
//            // Top Rated Tab
//            } else {
//                // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
//                urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
//            }

        
        // push decoding url to .userInitiated thread
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            if let url = URL(string: urlString) {
//                if let data = try? Data(contentsOf: url){
//                    // we're OK to parse!
//                    self?.parse(json: data)
//                    return
//                }
        
//            }
//            // put error in .userinitiated thread
//            self?.showError()
//        }
        
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        
        
        
    }
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
//             put back in main thread
//            DispatchQueue.main.async { [weak self] in
//                self?.tableView.reloadData()
//            }

            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController ()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    func setupSearchController(){
        searchController.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = searchController
    }
    @objc func showError() {
        // put error UI back into main thread
//        DispatchQueue.main.async { [weak self] in
//            let ac = UIAlertController(title: "Loading error", message: "404 cannot load feed", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            self?.present(ac, animated: true)
//        }
        
        let ac = UIAlertController(title: "Loading error", message: "404 cannot load feed", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)

    }
    @objc func showCredit() {
        let ac = UIAlertController(title: "Website Data ", message: "We the people API of the Whitehouse: https://petitions.whitehouse.gov/developers/get-code", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
// Old Search Functions 
//    @objc func searchPetitions(){
//        let ac = UIAlertController(title: "Search Query", message: nil, preferredStyle: .alert)
//        ac.addTextField()
//
//        let submitAction = UIAlertAction(title: "Submit", style: .default) {
//            [weak self, weak ac] _ in
//            guard let searchQuery = ac?.textFields?[0].text else { return }
//            self?.submit(searchQuery)
//        }
//        ac.addAction(submitAction)
//        present(ac, animated: true)
//
//    }
//
//    func submit(_ searchQuery: String) {
//        print(searchQuery)
//
//        for petition in petitions {
//            if petition.body.contains(searchQuery) {
//                queryResults.append(petition)
//                print(queryResults)
//                tableView.reloadData()
//        }
//        }
//
//
//    }
    func filterRowsForSearchedText(_ searchText: String) {
        filteredPetitions = petitions.filter({(petition : Petition) -> Bool in
            return
                petition.title.lowercased().contains(searchText.lowercased())||petition.body.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let term = searchController.searchBar.text{
            filterRowsForSearchedText(term)
        }
    }
    

    


}

