//
//  LibsManager.swift
//  CalendarDemo
//
//  Created by ice on 2022/4/16.
//

import Foundation
import IQKeyboardManagerSwift

class LibsManager: NSObject {

    /// The default singleton instance.
    static let shared = LibsManager()

    private override init() {
        super.init()
    }

    func setupLibs() {
        let libsManager = LibsManager.shared
        libsManager.setupCocoaLumberjack()
        libsManager.setupKeyboardManager()
    }

    func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }
    
    func setupCocoaLumberjack() {
        logInitail()
    }
}
