//
//  ViewController.swift
//  Project16
//
//  Created by Ryordan Panter on 24/3/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(mapSelect))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.", url: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.", url: "https://en.wikipedia.org/wiki/Oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.", url: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", url: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.", url: "https://en.wikipedia.org/wiki/Washington_(state)")
        
        // mapView.addAnnotation(london)
        // mapView.addAnnotation(oslo)
        // mapView.addAnnotation(paris)
        // mapView.addAnnotation(rome)
        // mapView.addAnnotation(washington)
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        //        mapView.mapType = .satellite
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // If the annotation isn't from a capital city, it must return nil so iOS uses a default view.
        guard annotation is Capital else {return nil}
        // Define a reuse identifier. This is a string that will be used to ensure we reuse annotation views as much as possible.
        let identifier = "Capital"
        // Try to dequeue an annotation view from the map view's pool of unused views.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            // If it isn't able to find a reusable view, create a new one using MKPinAnnotationView and sets its canShowCallout property to true. This triggers the popup with the city name.
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            // Create a new UIButton using the built-in .detailDisclosure type. This is a small blue "i" symbol with a circle around it.
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            // If it can reuse a view, update that view to use a different annotation.
            
            annotationView?.annotation = annotation
            
        }
        if let pinView = annotationView as? MKPinAnnotationView {
            pinView.pinTintColor = .yellow
        }
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeUrl = capital.url
        // setup new view controller
        // send user to new view controller
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? WebViewController {
            vc.website = placeUrl
            navigationController?.pushViewController(vc, animated: true)
        }
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
    }
    
    @objc func mapSelect () {
        let ac = UIAlertController(title: "Choose Map View", message: "Pick MapView", preferredStyle: .actionSheet)
        // standard
        let standardBtn = UIAlertAction(title: "Standard Map", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.mapView.mapType = .standard
        })
        // satellite
        let satelliteBtn = UIAlertAction(title: "Satellite Map", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.mapView.mapType = .satellite
        })
        // hybrid
        let hybridBtn = UIAlertAction(title: "Hybrid Map", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.mapView.mapType = .hybrid
        })
        // sateliteFlyover
        let sateliteFlyoverBtn = UIAlertAction(title: "SateliteFlyover Map", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.mapView.mapType = .satelliteFlyover
        })
        // hybridFlyover
        let hybridFlyoverBtn = UIAlertAction(title: "HybridFlyover Map", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.mapView.mapType = .hybridFlyover
        })
        // mutedStandard
        let mutedStandardBtn = UIAlertAction(title: "MutedStandard Map", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.mapView.mapType = .mutedStandard
        })
        // cancel
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(standardBtn)
        ac.addAction(satelliteBtn)
        ac.addAction(hybridBtn)
        ac.addAction(sateliteFlyoverBtn)
        ac.addAction(hybridFlyoverBtn)
        ac.addAction(mutedStandardBtn)
        ac.addAction(cancelBtn)
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(ac, animated: true)
    }
}

