//
//  MapViewModel.swift
//  free way
//
//  Created by Menglin Yang on 2022/8/26.
//

import Foundation

class MapViewModel {
    init(){
        camerasCache = SpeedCamerMapper.map(rows: csvLoader.getCSVContentRows())
        camerasCache.forEach { camera in
            if roadCameras[camera.road] == nil {
                roadCameras[camera.road] = [camera]
            } else {
                roadCameras[camera.road]!.append(camera)
            }
        }
    }
    private var csvLoader = LocalCSVLoader(url: Bundle.main.url(forResource: "location", withExtension: "csv")!)
    
    var camerasCache : [SpeedCamera]
    
    private(set) var roadCameras = [String:[SpeedCamera]]()
    
    var allCameras : [SpeedCamera] {
        camerasCache
    }
    
    var allRoads : [String] {
        roadCameras.keys.map{$0}
    }
    
    func cameras(on road : String, of direction: Direction) -> [SpeedCamera]{
        camerasCache.filter{$0.direction == direction}.sorted{$0.roadMarker > $1.roadMarker}
    }
}
