//
//  ViewController.swift
//  Milestone Project 16-18
//
//  Created by Ryordan Panter on 15/8/21.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [Country?]()
    let fileName = "Countries.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let tempCountries = loadJson(filename: fileName) else { return }
        countries = tempCountries
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let country: Country
        country = countries[indexPath.row]!
        cell.textLabel?.text = country.countryName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = countries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func loadJson(filename fileName: String) -> [Country]? {
//        print("inside loadJson")
        if let filePath = Bundle.main.path(forResource: "Countries", ofType: "json") {
//            print("inside url")
            do {
                let fileUrl = URL(fileURLWithPath: filePath)
//                print(fileUrl)
                let data = try Data(contentsOf: fileUrl)
//                print(data)
                let decoder = JSONDecoder()
                let jsonData = try? decoder.decode(ResponseData.self, from: data)
                return jsonData?.country
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
}

