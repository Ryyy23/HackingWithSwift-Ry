//
//  DetailViewController.swift
//  Milestone Project 16-18
//
//  Created by Ryordan Panter on 15/8/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var detailItem: Country?
    
    var countryNameLabel: UILabel!
    var countryCapitalLabel: UILabel!
    var countryPopulationLabel: UILabel!
    var countrySizeLabel: UILabel!
    var countryCurrencyLabel: UILabel!
    var countryFactLabel: UILabel!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        guard let detailItem = detailItem else { return }
        
        countryNameLabel = UILabel()
        countryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        countryNameLabel.textAlignment = .center
        countryNameLabel.font = UIFont.systemFont(ofSize: 24)
        countryNameLabel.textColor = .black
        countryNameLabel.text = "\(detailItem.countryName)"
        view.addSubview(countryNameLabel)
        
        countryCapitalLabel = UILabel()
        countryCapitalLabel.translatesAutoresizingMaskIntoConstraints = false
        countryCapitalLabel.textAlignment = .center
        countryCapitalLabel.font = UIFont.systemFont(ofSize: 24)
        countryCapitalLabel.textColor = .black
        countryCapitalLabel.text = "\(detailItem.capitalCity)"
        view.addSubview(countryCapitalLabel)
        
        countryPopulationLabel = UILabel()
        countryPopulationLabel.translatesAutoresizingMaskIntoConstraints = false
        countryPopulationLabel.textAlignment = .center
        countryPopulationLabel.font = UIFont.systemFont(ofSize: 24)
        countryPopulationLabel.textColor = .black
        countryPopulationLabel.text = "\(detailItem.population)"
        view.addSubview(countryPopulationLabel)
        
        countrySizeLabel = UILabel()
        countrySizeLabel.translatesAutoresizingMaskIntoConstraints = false
        countrySizeLabel.textAlignment = .center
        countrySizeLabel.font = UIFont.systemFont(ofSize: 24)
        countrySizeLabel.textColor = .black
        countrySizeLabel.text = "\(detailItem.size) km2"
        view.addSubview(countrySizeLabel)
        
        countryCurrencyLabel = UILabel()
        countryCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        countryCurrencyLabel.textAlignment = .center
        countryCurrencyLabel.font = UIFont.systemFont(ofSize: 24)
        countryCurrencyLabel.textColor = .black
        countryCurrencyLabel.text = "\(detailItem.currency)"
        view.addSubview(countryCurrencyLabel)
        
        countryFactLabel = UILabel()
        countryFactLabel.translatesAutoresizingMaskIntoConstraints = false
        countryFactLabel.textAlignment = .center
        countryFactLabel.font = UIFont.systemFont(ofSize: 24)
        countryFactLabel.textColor = .black
        countryFactLabel.text = "\(detailItem.fact)"
        view.addSubview(countryFactLabel)
        
        
        NSLayoutConstraint.activate([
            countryNameLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
//            countryNameLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            countryNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            countryCapitalLabel.topAnchor.constraint(equalTo: countryNameLabel.bottomAnchor, constant: 20),
//            countryCapitalLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            countryCapitalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            countryPopulationLabel.topAnchor.constraint(equalTo: countryCapitalLabel.bottomAnchor, constant: 20),
//            countryPopulationLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            countryPopulationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            countrySizeLabel.topAnchor.constraint(equalTo: countryPopulationLabel.bottomAnchor, constant: 20),
//            countrySizeLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            countrySizeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            countryCurrencyLabel.topAnchor.constraint(equalTo: countrySizeLabel.bottomAnchor, constant: 20),
//            countryCurrencyLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            countryCurrencyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            countryFactLabel.topAnchor.constraint(equalTo: countryCurrencyLabel.bottomAnchor, constant: 20),
//            countryFactLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            countryFactLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
