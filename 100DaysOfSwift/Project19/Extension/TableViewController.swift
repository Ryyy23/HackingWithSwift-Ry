//
//  TableViewController.swift
//  Extension
//
//  Created by Ryordan Panter on 17/8/21.
//

import UIKit

class TableViewController: UITableViewController {
    
    var savedWebsites = [SavedURL?]()
    weak var delegate: ActionViewController!
    var selectedPageSavedName: String?
    var selectedPageURL: URL?
    var selectedPageCustomJavascript: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedWebsites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        let savedURL: SavedURL
        savedURL = savedWebsites[indexPath.row]!
        cell.textLabel?.text = savedURL.name
        cell.detailTextLabel?.text = savedURL.url.host
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tempselectedPageCustomJavascript = savedWebsites[indexPath.row]?.customJavaScript else {
            return
        }
        guard let tempselectedPageURL = savedWebsites[indexPath.row]?.url else {
            return
        }
        selectedPageURL = tempselectedPageURL
        selectedPageCustomJavascript = tempselectedPageCustomJavascript
        // todo
        // push url, title & custom js to root view controller
        delegate.updateSelectedPage(selectedPageCustomJavascript: selectedPageCustomJavascript!)
        self.navigationController?.popToRootViewController(animated: true)
        
    }
}
