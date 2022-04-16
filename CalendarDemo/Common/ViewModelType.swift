//
//  ViewModelType.swift
//  CalendarDemo
//
//  Created by ice on 2022/4/16.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
