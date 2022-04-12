//
//  ViewController.swift
//  Milestone Project 19-21
//
//  Created by Ryordan Panter on 3/2/2022.
//

import UIKit

class ViewController: UITableViewController {
    var notes = [Note]()
    let fileName = "Notes.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        guard let tempNotes = loadJson(filename: fileName) else { return}
        notes = tempNotes
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.text = "\(notes.count) Notes"
        label.center = CGPoint(x: view.frame.midX, y: view.frame.height)
        label.textAlignment = NSTextAlignment.center
        label.textColor = .systemGray
        label.font = UIFont(name: "System", size: 8)
        
        let toolbarTitle = UIBarButtonItem(customView: label)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let createNewNote = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeNewNote))
        
        createNewNote.tintColor = .systemYellow
        toolbarItems = [spacer, toolbarTitle, spacer, createNewNote]
        navigationController?.isToolbarHidden = false
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        let note: Note
        note = notes[indexPath.item]
        cell.textLabel?.text = note.name
        cell.detailTextLabel?.text = note.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.detailNote = notes[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func loadJson(filename fileName: String) -> [Note]? {
        //        print("inside loadJson")
        if let filePath = Bundle.main.path(forResource: "Notes", ofType: "json") {
            //            print("inside url")
            do {
                let fileUrl = URL(fileURLWithPath: filePath)
                //                print(fileUrl)
                let data = try Data(contentsOf: fileUrl)
                //                print(data)
                let decoder = JSONDecoder()
                let jsonData = try? decoder.decode(ResponseData.self, from: data)
                return jsonData?.note
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    @objc func composeNewNote(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.newNote = true
            vc.textViewTitle = false
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
}

