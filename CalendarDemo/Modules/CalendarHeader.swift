//
//  CalendarHeader.swift
//  CalendarDemo
//
//  Created by ice on 2022/4/16.
//

import UIKit
import JTAppleCalendar

class CalendarHeader: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var backward: UIButton!
    @IBOutlet weak var forward: UIButton!
    @IBOutlet weak var timeRange: UILabel!
    @IBOutlet weak var zone: UILabel! {
        didSet {
            let localName = TimeZone.current.localizedName(for: .shortGeneric, locale: Locale.current) ?? ""
            let abbr = TimeZone.current.abbreviation() ?? ""
            zone.text = String(format: "*time with %@(%@)", localName, abbr)
        }
    }
    
    func configure(_ calendar: JTACMonthView, and visibleDates: DateSegmentInfo) {
        setupTimeRange(visibleDates)
        setupHeaderButton(calendar)
    }
    
    func setupHeaderButton(_ calendar: JTACMonthView) {
        let status = isButtonEnable(calendar)
        setupBackwardButton(status.forward)
        setupForwardButton(status.backward)
    }
    
    private func isButtonEnable(_ calendar: JTACMonthView) -> (forward: Bool, backward: Bool) {
        return (!(calendar.contentOffset.x <= 0),
                !(calendar.contentOffset.x >= calendar.contentSize.width - UIScreen.main.bounds.width))
    }
}

// MARK: - Private
extension CalendarHeader {
    private func setupBackwardButton(_ enable: Bool) {
        backward.isEnabled = enable
        backward.tintColor = enable ? .darkGray : .lightGray
    }
    
    private func setupForwardButton(_ enable: Bool) {
        forward.isEnabled = enable
        forward.tintColor = enable ? .darkGray : .lightGray
    }
    
    private func setupTimeRange(_ visibleDates: DateSegmentInfo) {
        let (start, end) = visibleDates.getDisplayDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd - "
        
        var str = formatter.string(from: start)
        formatter.dateFormat = "dd"
        str.append(formatter.string(from: end))
        
        timeRange.text = str
    }
}

extension DateSegmentInfo {
    func getDisplayDate() -> (start: Date, end: Date) {
        var startDate = monthDates.first?.date
        var endDate = monthDates.last?.date
        if let date = indates.first?.date {
            startDate = date
        }
        if let date = outdates.last?.date {
            endDate = date
        }
        return (startDate ?? Date(), endDate ?? Date())
    }
}
