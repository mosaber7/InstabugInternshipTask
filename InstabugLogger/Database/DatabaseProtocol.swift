//
//  DataBaseProtocol.swift
//  InstabugLogger
//
//  Created by Saber on 26/05/2021.
//  Copyright © 2021 Instabug. All rights reserved.
//

import Foundation

protocol DatabaseProtocol {
   func saveLog(message: String, logLevel: LogLevel)
   func fetchAllLogs()->[Log]
   func removeAllLogs()
}

