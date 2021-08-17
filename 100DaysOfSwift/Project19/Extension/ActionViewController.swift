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
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(selectScript))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(savePopUp))
        
        guard let userDefaults = getUserDefaults() else { return }
        savedWebsites = userDefaults
        print(savedWebsites)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
//        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
//            if let itemProvider = inputItem.attachments?.first {
//                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) {
//                    [weak self] (dict, error) in
//                    // do stuff
//                    guard let itemDictionary = dict as? NSDictionary else {
//                        return
//                    }
//                    guard let javaScriptValues = itemDictionary [NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else {return}
//                    //                    print(javaScriptValues)
//                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
//                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
//                    // save pageURL as URL
//
//
//                    DispatchQueue.main.async {
//                        self?.title = self?.pageTitle
//                    }
//                }
//            }
//        }
        
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
        extensionContext?.completeRequest(returningItems: [item])
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
        
    }
    
    //    @objc func selectScript() {
    //        print("test")
    //
    //        let ac = UIAlertController(title: "Example Scripts", message: "Select example scripts", preferredStyle: .actionSheet)
    //
    //        let exampleScript1 = UIAlertAction(title: "Example 1", style: .default, handler:{
    //            (alert: UIAlertAction!) -> Void in
    //            self.script.text = "alert(document.title);"
    //        })
    //
    //        let exampleScript2 = UIAlertAction(title: "Example 2", style: .default, handler:{
    //            (alert: UIAlertAction!) -> Void in
    //            self.script.text = "alert(document.URL);"
    //        })
    //
    //        let exampleScript3 = UIAlertAction(title: "Example 3", style: .default, handler:{
    //            (alert: UIAlertAction!) -> Void in
    //            self.script.text = "alert(document.scripts);"
    //        })
    //
    //        ac.addAction(exampleScript1)
    //        ac.addAction(exampleScript2)
    //        ac.addAction(exampleScript3)
    //
    //        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
    //
    //        self.present(ac, animated: true, completion: nil)
    //
    //    }
    
    @objc func savePopUp(){
        print("inside savePopUp")
        print(pageURL)
        let ac = UIAlertController(title: "Save Website", message: "Enter name for saved website / js", preferredStyle: .alert)
        
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak self, weak ac] action in
            print("IS WEBSITE HERE    \(self?.pageURL)")
            guard let websiteName = ac?.textFields?[0].text else { return }
            guard let savepageURL = self?.pageURL else { return }
            print(savepageURL)
            guard let customjavaScript = self?.script.text else { return }
            
            
            self?.saveWebsite(name: websiteName, url: savepageURL, javaScript: customjavaScript)
            print("inside addAction")
            print("name: \(websiteName)"    , "url: \(savepageURL)"    , "javascript: \(customjavaScript)", separator: "-" )
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        
        self.present(ac, animated: true, completion: nil)
    }
    
    func saveWebsite(name: String, url: String, javaScript: String ){
        print("savedWebsite hello")
        print(url)
        guard let stringToURL = URL(string: url) else { return }
        print("stringToURL")
        let saveURL = SavedURL(name: name, url: stringToURL, customJavaScript: javaScript)
        print("saveURL")
        savedWebsites.append(saveURL)
        print("append")
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
                let websites = try? decoder.decode(ResponseData.self, from: data)
                
                return websites?.savedURL
            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        }
        return nil
    }
    
}
