//
//  String+Extension.swift
//  NearMe
//
//  Created by Ankit Rouniyar on 13/01/24.
//

import Foundation

extension String {
    
    var formatForPhoneCall: String {
        self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}
