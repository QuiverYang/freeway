//
//  LocalCSVLoaderTest.swift
//  free wayTests
//
//  Created by Menglin Yang on 2022/8/25.
//

import XCTest
import free_way


class LocalCSVLoaderTest: XCTestCase {
    func test_initWithCorrectLocalURL() {
        let sut = makeSUT()
        XCTAssertNotNil(sut.data)
    }
    
    func test_getTitles() {
        let sut = makeSUT()
        let titles = sut.getTitles()
        XCTAssertFalse(titles.isEmpty)
        // 項次,編號,道路編號,道路方向,里程數_公里,速限_公里_小時,X座標,Y座標,WGS84東經_度,WGS84北緯_度,備註
    }
    
    func test_getCSVRowOutOfBound_shouldReturnNil() {
        let sut = makeSUT()
        let row = sut.getRow(at: Int.max)
        XCTAssertNil(row)
    }
    
    func test_CSVContentAndTitleShouldBeEqualLenth() {
        let sut = makeSUT()
        let titleLength = sut.getTitles().count
        for i in 0..<sut.getDataCount() {
            XCTAssertEqual(sut.getRow(at: i)?.count, titleLength, "index:\(i) has different length of titles")
        }
    }
    
    func test_loadCorrectSpeedCameraFromCSV() {
        let sut = makeSUT()
        let contents = sut.getCSVContentRows()
        let cameras = SpeedCamerMapper.map(rows: contents)
        for (index, camera) in cameras.enumerated() {
            XCTAssertEqual(camera.id, contents[index][1], "")
        }
        
    }
    
    private func makeSUT() -> LocalCSVLoader {
        LocalCSVLoader(url : Bundle.main.url(forResource: "location", withExtension: "csv")!)
    }

}
