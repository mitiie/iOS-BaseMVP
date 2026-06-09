//
//  DateHelper.swift
//  SwiftCommon
//
//  Created by mitie on 20/02/2023.
//

import UIKit
import Foundation

///    @discussion DateHelper
///
///    Using for converting date to string or string to date. With timezone and locale. Default timezone and locale are getting from device settings. You can change the locale or timezone with two functions below:
///
///    public func update(locale: String?) for changing locale
///
///    public func update(timezone: TimeZone) for changing current timezone. We can also the function of SwiftDate for quickly. Example Zones.asiaHoChiMinh.toTimezone()
///
///    You can setup in AppDelegate.swift for all function in your project
///

public enum DateFormatStyle: String {
    case full                   = "yyyy-MM-ddTHH:mm:ss.SSS'Z'"
    
    case yyyy_MM_dd             = "yyyy-MM-dd"
    case yyyy_MM_ddHHmm         = "yyyy-MM-dd HH:mm"
    case yyyy_MM_ddHHmma        = "yyyy-MM-dd HH:mm a"
    case yyyy_MM_ddHHmmss       = "yyyy-MM-dd HH:mm:ss"
    case yyyyMMdd               = "yyyy/MM/dd"
    case yyyyMMddHHmm           = "yyyy/MM/dd HH:mm"
    case yyyyMMddHHmma          = "yyyy/MM/dd HH:mm a"
    case yyyyMMddHHmmss         = "yyyy/MM/dd HH:mm:ss"
    
    case ddMMYYYY               = "dd/MM/yyyy"
    case ddMMYYYYHHmm           = "dd/MM/yyyy HH:mm"
    case ddMMYYYYHHmma          = "dd/MM/yyyy HH:mm a"
    case ddMMYYYYHHmmss         = "dd/MM/yyyy HH:mm:ss"
    case dd_MM_yyyy             = "dd-MM-yyyy"
    case dd_MM_YYYYHHmm         = "dd-MM-yyyy HH:mm"
    case dd_MM_YYYYHHmma        = "dd-MM-yyyy HH:mm a"
    case dd_MM_YYYYHHmmss       = "dd-MM-yyyy HH:mm:ss"

    case hhmmdd_MM_YYYY         = "HH:mm dd-MM-yyyy"
    case hhmmadd_MM_YYYY        = "HH:mm a dd-MM-yyyy"
    case hhmmssdd_MM_YYYY       = "HH:mm:ss dd-MM-yyyy"
    case hhmmddMMYYYY           = "HH:mm dd/MM/yyyy"
    case hhmmaddMMYYYY          = "HH:mm a dd/MM/yyyy"
    case hhmmssddMMYYYY         = "HH:mm:ss dd/MM/yyyy"
    
    case hhmm                   = "HH:mm"
    case hhmmss                 = "HH:mm:ss"
    case hhmma                  = "HH:mm a"
}

public class DateHelper: NSObject {

    public static var shared: DateHelper = DateHelper()
    
    //Locale for the formatted string. If it is null then will use the device language.
    private var locale: Locale = Locale.autoupdatingCurrent
    private var timezone: TimeZone = TimeZone.current
    
    func currentTimezone() -> TimeZone {
        return self.timezone
    }
    
    func currentLocale() -> Locale {
        return self.locale
    }
    
    public func update(locale: String?) {
        if let newLocale = locale, !newLocale.isEmpty {
            self.locale = Locale(identifier: newLocale)
        }
    }
    
    public func update(timezone: TimeZone) {
        self.timezone = timezone
    }
}

extension Date {
    public func serverUTCString() -> String {
        self.toString(style: .full, timezone: TimeZone(identifier: "UTC"))
    }
    
    public func toString(style: DateFormatStyle, timezone: TimeZone? = nil, locale: String? = nil) -> String {
        return self.toString(format: style.rawValue, timezone: timezone, locale: locale)
    }
    
    public func toString(format: String, timezone: TimeZone? = nil, locale: String? = nil) -> String {
        var currentLocale = DateHelper.shared.currentLocale()
        if let newLocale = locale {
            currentLocale = Locale(identifier: newLocale)
        }
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = timezone ?? DateHelper.shared.currentTimezone()
        formatter.locale = currentLocale
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    public func serverUTCDate() -> Date? {
        self.toDate(style: .full, timezone: TimeZone(identifier: "UTC"))
    }
    
    public func toDate(style: DateFormatStyle, timezone: TimeZone? = nil) -> Date? {
        return self.toDate(format: style.rawValue, timezone: timezone)
    }
    
    public func toDate(format: String, timezone: TimeZone? = nil) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = timezone ?? DateHelper.shared.currentTimezone()
        formatter.dateFormat = format
        let date = formatter.date(from: self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        return date
    }
}
