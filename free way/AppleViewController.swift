//
//  ViewController.swift
//  free way
//
//  Created by Menglin Yang on 2021/12/26.
//

import UIKit
import MapKit

class AppleViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myLocation: UIButton!
    let coordinates = [
        (lng: 121.724738, lat: 25.106857),
        (lng: 121.624945, lat: 25.066725),
        (lng: 121.536862, lat: 25.07305)
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func myLocationClicked(_ sender: UIButton) {
    }
    

}

