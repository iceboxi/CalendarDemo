//
//  MainViewModel.swift
//  CalendarDemo
//
//  Created by ice on 2022/4/16.
//

import Foundation
import RxCocoa
import RxSwift
import Moya
import RxMoya

class MainViewModel: NSObject, ViewModelType {
    struct Input {
        let forward: Observable<Void>
        let backward: Observable<Void>
    }
    
    struct Output {
        let items: BehaviorRelay<[String: [Lecture]]>
    }
    
    var week = 0    // may today week, 0 as this week, 1 backward, -1 forward
    let malSelected = PublishSubject<URL>()
    
    let provider = MoyaProvider<CalendarAPI>(stubClosure: MoyaProvider.immediatelyStub)
    
    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[String: [Lecture]]>(value: [:])
        
        input.forward
            .flatMapLatest({ [weak self] _ -> Observable<[String: [Lecture]]> in
                guard let self = self else { return Observable.just([:]) }
                self.week += 1
                return self.request()
            })
            .subscribe(onNext: { list in
                var all = elements.value
                all += list
                elements.accept(all)
            })
            .disposed(by: rx.disposeBag)
        
        input.backward
            .flatMapLatest({ [weak self] _ -> Observable<[String: [Lecture]]> in
                guard let self = self else { return Observable.just([:]) }
                self.week -= 1
                return self.request()
            })
            .subscribe(onNext: { list in
                var all = elements.value
                all += list
                elements.accept(all)
            })
            .disposed(by: rx.disposeBag)

        return Output(items: elements)
    }
    
    func request() -> Observable<[String: [Lecture]]> {
        return provider.rx.request(.getSchedule(week: week))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapObject(Schedule.self)
            .map({ schedule in
                return schedule.expandSchedule()
            })
    }
}

extension Dictionary {
    static func +=(lhs: inout Self, rhs: Self) {
        lhs.merge(rhs) { _ , new in new }
    }
    
    static func +=<S: Sequence>(lhs: inout Self, rhs: S) where S.Element == (Key, Value) {
        lhs.merge(rhs) { _ , new in new }
    }
}
