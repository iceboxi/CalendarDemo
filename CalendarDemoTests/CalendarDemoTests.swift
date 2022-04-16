//
//  CalendarDemoTests.swift
//  CalendarDemoTests
//
//  Created by ice on 2022/4/16.
//

import XCTest
@testable import CalendarDemo
import Moya
import RxMoya
import ObjectMapper
import NSObject_Rx

class CalendarDemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testScheduleAPI() throws {
        let provider = MoyaProvider<CalendarAPI>(stubClosure: MoyaProvider.immediatelyStub)
        provider.rx.request(.getSchedule(week: 1))
            .mapObject(Schedule.self)
            .subscribe(onSuccess: { list in
                XCTAssertEqual(list.available.count, 5)
            })
            .disposed(by: rx.disposeBag)
    }
    
    func testExpandSchedule() throws {
        let json = """
            {
              "available": [
                {
                  "start": "2022-04-23T08:30:00Z",
                  "end": "2022-04-23T10:00:00Z"
                }
              ],
              "booked": [
              ]
            }
            """
        let model = Schedule(JSONString: json)
        let result = model?.expandSchedule()
        XCTAssertEqual(result?.keys.count, 1)
        XCTAssertEqual(result?.keys.first, "2022/04/23")
        XCTAssertEqual(result?[(result?.keys.first)!]?.count, 3)
    }
    
    func testTestJsonFile() throws {
        let dataUrl = R.file.scheduleJson()
        if let url = dataUrl, let data = try? Data(contentsOf: url), let json = String(data: data, encoding: .utf8) {
            let model = Schedule(JSONString: json)
            let result = model?.expandSchedule()
            XCTAssertEqual(result?.keys.count, 6)
        }
    }
    
    func testAppendDictionary() throws {
        let json = """
            {
              "available": [
                {
                  "start": "2022-04-23T08:30:00Z",
                  "end": "2022-04-23T10:00:00Z"
                }
              ],
              "booked": [
              ]
            }
            """
        let model = Schedule(JSONString: json)
        var result = model?.expandSchedule() ?? [:]
        
        let json2 = """
            {
              "available": [
                {
                  "start": "2022-04-24T08:30:00Z",
                  "end": "2022-04-24T10:00:00Z"
                }
              ],
              "booked": [
              ]
            }
            """
        let model2 = Schedule(JSONString: json2)
        let result2 = model2?.expandSchedule() ?? [:]
        
        result += result2
        
        XCTAssertEqual(result.keys.count, 2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
