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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
