//
//  Formater.swift
//  OnePlan
//
//  Created by Tcacenco Daniel on 5/30/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

extension Date {
    
    func dateFormaterFromDate() -> String  {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy HH:mm"
        let dateString = dateFormater.string(from: self)
        return dateString 
    }
    
    func dateFormaterFromServer(dateString: String) -> Date  {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        let date = dateFormater.date(from: dateString)
        return date!
    }
    
    func dateFormaterFromDateShort() -> String  {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormater.string(from: self)
        return dateString
    }
    
    func dateFormaterForServer() -> String  {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormater.string(from: self)
        return dateString
    }
    
}

extension String{
    
    func dateFormater() -> Date  {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy HH:mm"
        let date = dateFormater.date(from: self)
        return date!
    }
    
    func trasnformToDate() -> Date  {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMM dd, yyyy HH:mm"
        let date = dateFormater.date(from: self)
        return date!
    }
    
    func formatDate() -> Date  {
        let dateFormater = DateFormatter()
        //        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        dateFormater.dateFormat = "yyyy-MM-ddHH:mm:ss.SSSSSS"
        let date = dateFormater.date(from: self)
        return date!
    }
    
    func dateFormaterTime() -> String  {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormater.date(from: self)
        dateFormater.dateFormat = "HH:mm"
        let dateString = dateFormater.string(from: date!)
        return dateString
    }
    
    func dateFormaterShortDate() -> String  {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormater.date(from: self)
        dateFormater.dateFormat = "E, HH:mm"
        let dateString = dateFormater.string(from: date!)
        return dateString
    }
    
    func dateFormaterNormalDate() -> String  {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormater.date(from: self)
        dateFormater.dateFormat = "d MMMM, HH:mm"
        let dateString = dateFormater.string(from: date!)
        return dateString
    }
    
    func dateFormaterExpireDate() -> String  {
        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        dateFormater.dateFormat = "yyyy-MM-ddHH:mm:ss.SSSSSS"
        let date = dateFormater.date(from: self)
        dateFormater.dateFormat = "d MMMM yyyy"
        let dateString = dateFormater.string(from: date!)
        return dateString
    }
    
    func dateFormaterForServer() -> String  {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormater.date(from: self)
        dateFormater.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormater.string(from: date!)
        return dateString
    }
}

