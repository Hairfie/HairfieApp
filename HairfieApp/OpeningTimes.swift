//
//  OpeningTimes.swift
//  HairfieApp
//
//  Created by Ghislain on 06/08/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

import Foundation

@objc class OpeningTimes : NSObject {
    
    @objc func printTest(name: String) {
        println("Hello " + name)
    }
    
    @objc func isOpen(timetables: NSDictionary) -> Bool {
        let today = NSDate(), dateFormatter = NSDateFormatter(), format = "EEEE", timeZone = NSTimeZone.localTimeZone()

        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format
        let todayStr:String? = dateFormatter.stringFromDate(today)
        
        if(timetables[todayStr]) {
            return true
        }
        else {
            return false
        }
    }
}