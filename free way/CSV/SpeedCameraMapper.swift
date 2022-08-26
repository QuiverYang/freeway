//
//  SpeedCameraMapper.swift
//  free way
//
//  Created by Menglin Yang on 2022/8/25.
//

import Foundation
public class SpeedCamerMapper {
    public static func map(rows : [[String]]) -> [SpeedCamera] {
        rows.map{SpeedCameraCSVAdaptor(rowData: $0).speedCamera}
    }
    
}
private struct SpeedCameraCSVAdaptor {
    var rowData : [String]
    // 項次,編號,道路編號,道路方向,里程數_公里,速限_公里_小時,X座標,Y座標,WGS84東經_度,WGS84北緯_度,備註
    // 0,  1    2      3       4         5           6     7     8          9           10
    var speedCamera : SpeedCamera {
        let id = rowData[1]
        let longtitude = Double(rowData[8]) ?? 0
        let latitude = Double(rowData[9]) ?? 0
        let memo = rowData[10]
        let direction = Direction(rawValue: rowData[3]) ?? Direction.empty
        let road = rowData[2]
        let roadMarker = Double(rowData[4]) ?? -99
        
        return SpeedCamera(id: id,
                           longtitude: longtitude,
                           latitude: latitude,
                           memo: memo,
                           direction: direction,
                           road: road,
                           roadMarker: roadMarker)
    }
}
