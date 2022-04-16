//
//  ViewController.swift
//  CalendarDemo
//
//  Created by ice on 2022/4/16.
//

import UIKit
import JTAppleCalendar
import NSObject_Rx
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var header: CalendarHeader! 
    
    private var visibleDates: DateSegmentInfo?
    private var currectOffsetX: CGFloat = 0
    
    var course: [String: [Lecture]]?
    
    let viewModel = MainViewModel()
    let backwardTrigger = PublishSubject<Void>()
    let forwardTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        setupCalendar()
        bindViewModel()
    }

    func bindViewModel() {
        let trigger = Observable.of(Observable.just(()), forwardTrigger).merge()
        let input = MainViewModel.Input(forward: trigger,
                                        backward: backwardTrigger.asObservable())
        let output = viewModel.transform(input: input)
        
        output.items.asDriver(onErrorJustReturn: [:])
            .drive(onNext: { [weak self] dict in
                self?.course = dict
                self?.calendarView.reloadData()
            })
            .disposed(by: rx.disposeBag)
        
        header.backward.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {
                    return
                }
                
                self.scrollForward()
                if self.canScrollForward() {
                    self.backwardTrigger.onNext(())
                }
            })
            .disposed(by: rx.disposeBag)
        
        header.forward.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else {
                    return
                }
                
                self.scrollBackward()
                self.forwardTrigger.onNext(())
            })
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - JTACMonthViewDataSource
extension MainViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let startDate: Date = Date()
        let endDate: Date = Date().dateByAddDays(365)
        
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       numberOfRows: 1,
                                       generateInDates: .forAllMonths,
                                       generateOutDates: .tillEndOfRow,
                                       firstDayOfWeek: .sunday)
    }
}

// MARK: - JTACMonthViewDelegate
extension MainViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath)
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    private func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? DateCell else { return }
        let lectures = getLectures(cellState)
        cell.configure(with: cellState, lectures: lectures)
    }
    
    private func getLectures(_ cellState: CellState) -> [Lecture]? {
        let dateString = cellState.date.startOfDay.stringFormat("yyyy/MM/dd")
        return course?[dateString]
    }
    
    func calendarDidScroll(_ calendar: JTACMonthView) {
        header.setupHeaderButton(calendar)
    }
    
    func calendar(_ calendar: JTACMonthView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        if isForwardDirect(calendar.contentOffset.x) {
            forwardTrigger.onNext(())
        } else {
            backwardTrigger.onNext(())
        }
        
        currectOffsetX = calendar.contentOffset.x
    }
    
    private func isForwardDirect(_ x: CGFloat) -> Bool {
        return currectOffsetX > x
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        header.configure(calendar, and: visibleDates)
        self.visibleDates = visibleDates
    }
}

// MARK: - Private
extension MainViewController {
    private func setupCalendar() {
        calendarView.scrollDirection = .horizontal
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.allowsMultipleSelection = false
    }
    
    private func canScrollForward() -> Bool {
        guard let visibleDates = visibleDates else {
            return false
        }
        
        let currect = visibleDates.getDisplayDate().start.dateByAddDays(-7)
        if currect < Date().startOfDay {
            return false
        }
        
        return true
    }
    
    private func scrollForward() {
        guard let visibleDates = visibleDates else {
            return
        }
        
        if canScrollForward() {
            let currect = visibleDates.getDisplayDate().start.dateByAddDays(-7)
            self.calendarView.scrollToDate(currect, animateScroll: true)
        } else {
            self.calendarView.scrollToDate(Date(), animateScroll: true)
        }
    }
    
    private func scrollBackward() {
        guard let visibleDates = visibleDates else {
            return
        }
        
        let currect = visibleDates.getDisplayDate().end.dateByAddDays(1)
        calendarView.scrollToDate(currect, animateScroll: true)
    }
}
