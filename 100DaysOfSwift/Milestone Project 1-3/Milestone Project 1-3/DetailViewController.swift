//
//  DetailViewController.swift
//  Milestone Project 1-3
//
//  Created by Ryordan Panter on 18/6/20.
//  Copyright © 2020 Ryordan Panter. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View Title
        title = selectedImage?.replacingOccurrences(of: "@3x.png", with: "").capitalized
        
        // Remove Large View Title
        navigationItem.largeTitleDisplayMode = .never
        
        //Share Button in Navigation Bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareCountryButton))
        
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareCountryButton() {
        guard let image = imageView.image?.jpegData(compressionQuality: 1) else {
            print("No image found")
            return
        }
        let countryName : String? = selectedImage?.replacingOccurrences(of: "@3x.png", with: "").capitalized
        
        
        let vc = UIActivityViewController(activityItems: [image, countryName ?? "No Country Name Found"], applicationActivities: [])
        //Ipad popover
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
