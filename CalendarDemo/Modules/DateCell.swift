//
//  DateCell.swift
//  CalendarDemo
//
//  Created by ice on 2022/4/16.
//

import UIKit
import JTAppleCalendar

class DateCell: JTACDayCell {
    @IBOutlet weak var dayColor: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        eventStack.removeAllArrangedSubviews()
    }
    
    func configure(with cellState: CellState, lectures: [Lecture]?) {
        dateLabel.text = cellState.text
        dayLabel.text = cellState.day.desription
        
        setDayColor(with: cellState)
        stackLectureTime(with: lectures)
    }
    
    private func stackLectureTime(with lectures: [Lecture]?) {
        lectures?.forEach({ lecture in
            let lbl = getCutsomLabel()
            lbl.text = lecture.start.stringFormat("HH:mm")
            lbl.textColor = lecture.booked ? .lightGray : .green
            eventStack.addArrangedSubview(lbl)
        })
    }
    
    private func getCutsomLabel() -> UILabel {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lbl.contentMode = .center
        return lbl
    }
    
    private func setDayColor(with cellState: CellState) {
        if isExpire(cellState.date) {
            setAsExpire()
        } else {
            setAsVaild()
        }
    }
    
    private func isExpire(_ date: Date) -> Bool {
        return date < Date().startOfDay
    }
    
    private func setAsExpire() {
        dayColor.backgroundColor = .lightGray
        dayLabel.textColor = .lightGray
        dateLabel.textColor = .lightGray
    }
    
    private func setAsVaild() {
        dayColor.backgroundColor = .green
        dayLabel.textColor = .black
        dateLabel.textColor = .black
    }
}

extension DaysOfWeek {
    var desription: String {
        switch self {
        case .monday:
            return "Mon"
        case .sunday:
            return "Sun"
        case .tuesday:
            return "Tue"
        case .wednesday:
            return "Wed"
        case .thursday:
            return "Thu"
        case .friday:
            return "Fri"
        case .saturday:
            return "Sat"
        }
    }
}
