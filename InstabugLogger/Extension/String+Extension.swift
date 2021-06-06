//
//  String+Extension.swift
//  InstabugLogger
//
//  Created by Saber on 26/05/2021.
//

import Foundation

extension String{
    
    /// replaces the chars after the index 1000 with three dots
    /// - Parameter message: the log message
    /// - Returns: the input log message if the input message count <= 1000,and if the count is > 1000 it returns the first 1000 char and replaces the left with "..."
    func validate(above limit: Int = 1000) -> String {
        var turncatedMessage = self
        if self.count > limit{
            let messageLimitIndex = turncatedMessage.index(turncatedMessage.startIndex, offsetBy: limit)
            turncatedMessage.replaceSubrange(messageLimitIndex..<turncatedMessage.endIndex, with: "...")
        }
        return turncatedMessage
    }
}

