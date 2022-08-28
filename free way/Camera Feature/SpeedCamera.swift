//
//  SpeedCamera.swift
//  free way
//
//  Created by Menglin Yang on 2022/8/25.
//

import Foundation
public enum Direction : String, CaseIterable {
    case north = "北向"
    case south = "南向"
    case east = "東向"
    case west = "西向"
    case northSouth = "南北向"
    case esatWest = "東西向"
    case empty = "無"
}

public struct SpeedCamera {
    public var id : String
    public var longtitude : Double
    public var latitude : Double
    public var memo : String
    public var direction : Direction
    public var road : String
    public var roadMarker : Double
    public var limit : Int
}
