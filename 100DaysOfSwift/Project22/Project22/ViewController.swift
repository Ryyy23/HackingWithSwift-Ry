//
//  ViewController.swift
//  Project22
//
//  Created by Ryordan Panter on 20/9/2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var connectedUUID: UILabel!
    @IBOutlet var distanceCircle: UIView!
    var locationManager: CLLocationManager?
    var beaconFirstConnection = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
        distanceCircle.transform = CGAffineTransform(scaleX: 0.001 , y: 0.001 )
        distanceCircle.layer.cornerRadius = 128
        distanceCircle.layer.borderWidth = 2
        distanceCircle.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        distanceCircle.backgroundColor = .gray
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    func startScanning(){
        // UUID's  E2C56DB5-DFFB-48D2-B060-D0F5A71096E0
        // UUID's  74278BDA-B644-4520-8F0C-720EAF059935
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        //let beaconRegion1 = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        let beaconIdentity = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: beaconIdentity, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconIdentity)
        
    }
    
    func update(distance: CLProximity){
        UIView.animate(withDuration: 1){
            switch distance {
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceCircle.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.distanceCircle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceCircle.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.distanceCircle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceCircle.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.distanceCircle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceCircle.backgroundColor = .gray
                self.distanceReading.text = "UNKOWN"
                self.distanceCircle.transform = CGAffineTransform(scaleX: 0.001 , y: 0.001 )
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
            connectedUUID.text = beacon.uuid.uuidString
            if beaconFirstConnection == false {
                beaconFirstConnection = true
                let alert = UIAlertController(title: "Beacon Connected", message: "Beacon first connected", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        } else {
            update(distance: .unknown)
        }
    }
}

