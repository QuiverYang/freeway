//
//  ViewController.swift
//  free way
//
//  Created by Menglin Yang on 2021/12/26.
//

import UIKit
import MapKit

class AppleViewController: UIViewController {
    @IBOutlet weak var buttonCollections: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    var viewModel = MapViewModel()
    var radius = 1000.0
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        buttonCollections.delegate = self
        buttonCollections.dataSource = self
        buttonCollections.register(ButtonCell.nib(), forCellWithReuseIdentifier: ButtonCell.identifier)
        buttonCollections.backgroundColor = .clear
        buttonCollections.collectionViewLayout = UICollectionViewFlowLayout()
        if let layout = buttonCollections.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.showsUserLocation = true
        addMapTrackingButton()
        
        
    }
    
    private func draw(on road: String) {
        resetMapView()
        setUpAnnotation(on : road)
        drawCircle(on: road)
//        drawPath(on: road)
    }
    
    private func resetMapView() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
    }
    
    private func setUpAnnotation(on road : String) {
        
        var annotations = [MKPointAnnotation]()
        for (key, value) in viewModel.roadCameras {
            if key != road || value.isEmpty {continue}
            value.forEach {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longtitude)
                annotation.title = "\($0.limit)"
                annotation.subtitle = $0.memo
                annotations.append(annotation)
            }

        }
        mapView.addAnnotations(annotations)
    }
    private func drawCircle(on road : String) {
        for (key, value) in viewModel.roadCameras {
            if key != road || value.isEmpty {continue}
            for camera in value {

                let cicle = MKCircle(center: CLLocationCoordinate2D(latitude: camera.latitude, longitude: camera.longtitude), radius: radius)
                cicle.color = UIColor(red: 252/256, green: 236/256, blue: 3/256, alpha: 0.4)
                mapView.addOverlay(cicle)
            }
        }
    }
    private func drawPath(on road : String) {
        for (key,value) in viewModel.roadCameras {
            if !key.contains(road) || value.isEmpty {continue}
            print(key)
            var startCamera = value[0]
            var destinationCamera = value[0]
            for i in 1..<value.count {
                destinationCamera = value[i]
                let startLocation = CLLocationCoordinate2D(latitude: startCamera.latitude, longitude: startCamera.longtitude)
                let startMarker = MKPlacemark(coordinate: startLocation)
                
                let destinationLocation = CLLocationCoordinate2D(latitude: destinationCamera.latitude, longitude: destinationCamera.longtitude)
                let destinationMarker = MKPlacemark(coordinate: destinationLocation)
                
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: startMarker)
                request.destination = MKMapItem(placemark: destinationMarker)
                request.transportType = .automobile
                let directions = MKDirections(request: request)
                
                directions.calculate { [weak self] (res, error) in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    guard let res = res else {return}
                    for route in res.routes {
                        
//                    let route = res.routes.first!
                        let polyline = route.polyline
                        polyline.color = .blue
                        self?.mapView.addOverlay(polyline)
                    }
                    
                }
                startCamera = destinationCamera
            }
            
            
            
        }
    }
    private func addMapTrackingButton(){
        let buttonItem = MKUserTrackingButton(mapView: mapView)
        view.addSubview(buttonItem)
        buttonItem.translatesAutoresizingMaskIntoConstraints = false
        buttonItem.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -25).isActive = true
        buttonItem.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -15).isActive = true
    }
    

}


extension AppleViewController : MKMapViewDelegate {

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = overlay.color
            return renderer
        }
        if let overlay = overlay as? MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = overlay.color
            return renderer
        }
        return MKOverlayRenderer()
    }
}


extension MKShape {
    struct ColorHolder {
        static var _color: UIColor?
    }
    var color: UIColor? {
        get {
            return ColorHolder._color
        }
        set(newValue) {
            ColorHolder._color = newValue
        }
    }
}

extension AppleViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        draw(on : viewModel.allRoads[indexPath.row])
    }
}

extension AppleViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ButtonCell
        cell.label.text = viewModel.allRoads[indexPath.row]
        //cell背景顏色
        cell.backgroundColor = UIColor.lightGray
        //圓角
        cell.clipsToBounds = true
        cell.layer.cornerRadius = cell.frame.height/2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.allRoads.count
    }
}

extension AppleViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}
