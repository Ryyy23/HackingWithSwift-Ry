//
//  DetailViewController.swift
//  Milestone Project 19-21
//
//  Created by Ryordan Panter on 8/2/2022.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var textView: UITextView!
    var detailNote: Note?
    var noteTitle: String?
    var noteBody: String?
    
    let shareRightBarButton = UIBarButtonItem(title: "Share" , style: .plain, target: self, action: #selector(sharePopUP))
    let doneRightBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
    
    // Title & Body text styles
    let boldFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 35)]
    let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
    
    // TextView has title
    var textViewTitle : Bool?
    var newNote : Bool?
    
    var keyboardOpen = false {
        didSet {
            print(keyboardOpen == true ? "Keyboard = True" : "Keyboard = False")
            if keyboardOpen == true {
                // Share & Done
                navigationItem.setRightBarButtonItems([doneRightBarButton, shareRightBarButton], animated: true)
                doneRightBarButton.isEnabled = true
                doneRightBarButton.tintColor = UIColor.systemYellow
            } else {
                // Share
                navigationItem.setRightBarButtonItems([shareRightBarButton, doneRightBarButton], animated: true)
                doneRightBarButton.isEnabled = false
                doneRightBarButton.tintColor = UIColor.clear
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.rightBarButtonItem = shareRightBarButton
        
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        
        textView.alwaysBounceVertical = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        
        // Monitor keyboard open/close
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if newNote == true {
            // create new note
            createNewNote()
        } else {
            // load saved note
            loadSavedNote()
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func insertText(noteTitle: String, noteBody: String) {
        //        let boldFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 35)]
        //        let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        
        let noteTileAttributed = NSMutableAttributedString(string: noteTitle, attributes: boldFontAttributes)
        let noteBodyAttributed = NSMutableAttributedString(string: noteBody, attributes: normalFontAttributes)
        let newLineAttributted = NSMutableAttributedString(string: "\n",attributes: normalFontAttributes)
        
        let combination = NSMutableAttributedString()
        
        combination.append(noteTileAttributed)
        combination.append(newLineAttributted)
        combination.append(noteBodyAttributed)
        self.textView.attributedText = combination
        
    }
    
    func insertTitleText(noteTitle: String) {
        
        let noteTileAttributed = NSMutableAttributedString(string: noteTitle, attributes: boldFontAttributes)
        let newLineAttributted = NSMutableAttributedString(string: "\n",attributes: normalFontAttributes)
        let combination = NSMutableAttributedString()
        
        combination.append(noteTileAttributed)
        combination.append(newLineAttributted)
        self.textView.attributedText = combination
        
    }
    // checking if 'return has been pressed, then chnages first line to title and bolds text
    func textView(_ textView: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
        let resultRange = text.rangeOfCharacter(from: CharacterSet.newlines, options: .backwards)
        if text.count == 1 && resultRange != nil && textViewTitle == false {
            // Do any additional stuff here
            print("Return Pressed")
            print(textView.text ?? "Error")
            noteTitle = textView.text
            insertTitleText(noteTitle: textView.text)
            textViewTitle = true
            return false
        }
        return true
    }
    
    func createNewNote() {
        self.textView.becomeFirstResponder()
        textView.font = UIFont.boldSystemFont(ofSize: 35)
    }
    
    func loadSavedNote() {
        // load saved note
        guard let detailNote = detailNote else {
            return
        }
        noteTitle = detailNote.name
        noteBody = detailNote.body
        insertText(noteTitle: detailNote.name, noteBody: detailNote.body)
    }
    
    func saveNote(){
        
    }
    
    
    @objc func doneEditing() {
        self.textView.endEditing(true)
        
//        if newNote == true {
//            // new note
//            guard let noteTitleCount = noteTitle?.count else {
//                return
//            }
//            var temp = textView.text.dropFirst(noteTitleCount)
//            print(temp)
//            
//        } else {
//            // old note
//        }
    }
    @objc func sharePopUP() {
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        switch notification.name {
        case UIResponder.keyboardWillHideNotification:
            textView.contentInset = UIEdgeInsets.zero
            print("Keyboard Hide")
            keyboardOpen = false
            
        case UIResponder.keyboardDidShowNotification:
            print("Keyboard Show")
            keyboardOpen = true
        default:
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    
}

