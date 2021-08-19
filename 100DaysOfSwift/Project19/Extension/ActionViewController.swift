//
//  ActionViewController.swift
//  Extension
//
//  Created by Ryordan Panter on 16/8/21.
//
import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    var savedWebsites = [SavedURL?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let share = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(websiteBookmark))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(savePopUp))
        navigationItem.leftBarButtonItems = [add, share]
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(savePopUp))
        
        guard let userDefaults = getUserDefaults() else { return }
        savedWebsites = userDefaults
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [unowned self] (dict, error) in
                    let itemDictionary = dict as! NSDictionary
                    let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary
                    
                    self.pageTitle = javaScriptValues["title"] as! String
                    self.pageURL = javaScriptValues["URL"] as! String
                    
                    DispatchQueue.main.async {
                        self.title = self.pageTitle
                    }
                }
            }
        }
    }
    
    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        extensionContext!.completeRequest(returningItems: [item])
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = UIEdgeInsets.zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @objc func savePopUp(){
        let ac = UIAlertController(title: "Save Website", message: "Enter name for saved website / js", preferredStyle: .alert)
        
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak self, weak ac] action in
            guard let websiteName = ac?.textFields?[0].text else { return }
            guard let savepageURL = self?.pageURL else { return }
            guard let customjavaScript = self?.script.text else { return }
            
            
            self?.saveWebsite(name: websiteName, url: savepageURL, javaScript: customjavaScript)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        
        self.present(ac, animated: true, completion: nil)
    }
    
    func saveWebsite(name: String, url: String, javaScript: String ){
        guard let stringToURL = URL(string: url) else { return }
        let saveURL = SavedURL(name: name, url: stringToURL, customJavaScript: javaScript)
        savedWebsites.append(saveURL)
        do{
            // Create JSON Encoder
            let encoder = JSONEncoder()
            
            // Encode saveURL
            //            let data = try encoder.encode(saveURL)
            let data = try encoder.encode(savedWebsites)
            // Write/ Set Data
            UserDefaults.standard.setValue(data, forKey: "SavedURL")
            
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    func getUserDefaults() -> [SavedURL]? {
            // Read/Get Data from UserDefaults
            if let data = UserDefaults.standard.data(forKey: "SavedURL") {
                do {
                    let decoder = JSONDecoder()
                    
                    // try storing decoded data as struct ResponseData which stores an array [] of SavedURL struct
                    let websites = try? decoder.decode([SavedURL].self, from: data)
                    
                    return websites
                } catch {
                    print("Unable to Decode Notes (\(error))")
                }
            }
            return nil
        }
    
    @objc func websiteBookmark(){
        let vc = TableViewController()
        vc.savedWebsites = savedWebsites
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    func updateSelectedPage(selectedPageCustomJavascript: String){
        script.text = selectedPageCustomJavascript
        
    }
}
