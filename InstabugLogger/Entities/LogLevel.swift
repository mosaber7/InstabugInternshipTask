//
//  LogLevel.swift
//  InstabugLogger
//
//  Created by Saber on 26/05/2021.
//  Copyright © 2021 Instabug. All rights reserved.
//

import Foundation

public enum LogLevel: Int16 {
    case TRACE = 0
    case DEBUG
    case INFO
    case WARN
    case ERROR
    case FATAL
    
    func levelName() -> String {
        switch self {
        case .TRACE:
            return "TRACE"
        case .DEBUG:
            return "DEBUG"
        case .INFO:
            return "INFO"
        case .WARN:
            return "WARN"
        case .ERROR:
            return "ERROR"
        case .FATAL:
            return "FATAL"
        }
    }
}
