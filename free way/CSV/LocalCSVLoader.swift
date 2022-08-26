//
//  LocalCSVLoader.swift
//  free way
//
//  Created by Menglin Yang on 2022/8/25.
//

import Foundation


public class LocalCSVLoader {
    public var data: Data?
    var url : URL
    private(set) var csv = [[String]]()
    public init(url : URL) {
        self.url = url
        if let data = try? Data(contentsOf: url) {
            self.data = data
            let str = String(decoding: data, as: UTF8.self)
            let rows = str.components(separatedBy: "\n")
            for (index, row) in rows.enumerated() {
                if index >= csv.count {
                    csv.append([])
                }
                let columns = row.components(separatedBy: ",")
                for col in columns {
                    csv[index].append(col)
                }
            }
            csv.removeLast()
        }
    }
    func load(completion : @escaping (Result<[SpeedCamera],Error>)->Void){}
    public func getTitles() -> [String]{
        csv.first ?? []
    }
    public func getCSVContentRows() -> [[String]] {
        var content = csv
        content.removeFirst()
        return content
    }
    
    public func getRow(at num: Int) -> [String]?{
        if num >= csv.count - 1 {
            return nil
        }
        return csv[num + 1]
    }
    public func getDataCount() -> Int {
        return csv.count - 1
    }
}
