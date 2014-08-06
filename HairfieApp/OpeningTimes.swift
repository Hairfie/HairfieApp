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
        let today = NSDate(), dateFormatter = NSDateFormatter(), format = "e", timeZone = NSTimeZone.localTimeZone()

        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format
        let todayInt:Int? = dateFormatter.stringFromDate(today).toInt()
        
        let weekDays:[Int: String] = [1: "Dimanche", 2: "Lundi", 3: "Mardi", 4: "Mercredi", 5: "Jeudi", 6: "Vendredi", 7: "Samedi"]
        let todayFr = weekDays[todayInt!];
        
        if(timetables[todayFr]) {
            return true
        }
        else {
            return false
        }
    }
}