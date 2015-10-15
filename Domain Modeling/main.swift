//
//  main.swift
//  Domain Modeling
//
//  Created by iGuest on 10/14/15.
//  Copyright (c) 2015 Jia Yu. All rights reserved.
//

import Foundation

enum Currency{
    
    case USD
    
    case GBP
    
    case EUR
    
    case CAN
    
}

struct Money{
    
    var amount:Double
    
    var currency:Currency
    
    func convert(convC: Currency) -> Money{
        
        let U2G = 0.5
        
        let U2E = 1.5
        
        let U2C = 1.25
        
        let U2U = 1.0
        
        var amount:Double = self.amount
        
        if self.currency != convC{
        
        switch (self.currency, convC){
            
        case (.USD, .GBP):
            
            amount = U2G
            
        case (.GBP, .USD):
            
            amount = 1.0/U2G
            
        case (.USD, .EUR):
            
            amount = U2E
            
        case (.EUR, .USD):
            
            amount = 1.0/U2E
            
        case (.USD, .CAN):
            
            amount = U2C
            
        case (.CAN, .USD):
            
            amount = 1.0/U2C
            
        case (.GBP, .EUR):
            
            amount = 1.0/U2G*U2E
            
        case (.GBP, .CAN):
            
            amount = 1.0/U2G*U2C
            
        case (.EUR, .GBP):
            
            amount = 1.0/U2E*U2G
            
        case (.EUR, .CAN):
            
            amount = 1.0/U2E*U2C
            
        case (.CAN, .GBP):
            
            amount = 1.0/U2C*U2G
            
        case (.CAN, .EUR):
            
            amount = 1.0/U2C*U2E
            
        default:
            
            println("Please enter one of the four currencies.")
            
            }
            
        }
        
        var m = Money(amount: amount, currency: convC)
        
        return m
    }
    
    func add(money: [Money]) -> Money{
        
        var amount = self.amount
        
        for index in 0...money.count{
            
            amount = amount + money[index].convert(self.currency).amount
            
        }
        
        let m = Money(amount: amount, currency: self.currency)
        
        return m
    
    }
    
    func sub(money: [Money]) -> Money{
        
        var amount = self.amount
        
        for index in 1...money.count{
            
            amount = amount - money[index].convert(self.currency).amount
            
        }
        
        var m = Money(amount: amount, currency: self.currency)
        
        return m
        
    }
    
}

enum Per{
    
    case hour
    
    case year
}


struct Salary{
    
    var s: Money
    
    var per: Per
}

class Job{
    
    var title:String
    
    var salary: Salary
    
    init(title:String, salary: Salary){
        
        self.title = title
        
        self.salary = salary
        
    }
    
    func calculateIncome(hours: Double) ->Money{
        
        var amount = self.salary.s.amount
        
        if self.salary.per == .hour{
            
            amount = amount * hours
        }
        
        var m = Money(amount: amount, currency: self.salary.s.currency)
        
        return m
    }
    
    func raise(percent: Double) -> Salary{
        
        var amount = self.salary.s.amount * (1 + percent)
        
        var sal = Salary(s: Money(amount: amount, currency: self.salary.s.currency), per: self.salary.per)
        
        return sal
    }
}

class Person{
    
    var firstName: String
    
    var lastName: String
    
    var age: Int
    
    var job: Job
    
    
}





