//
//  main.swift
//  Domain Modeling
//
//  Created by iGuest on 10/14/15.
//  Copyright (c) 2015 Jia Yu. All rights reserved.
//

import Foundation

protocol CustomStringConvertible{
    
    var description:String{get set}
    
}

protocol Mathematics{
    
    func add(money:[Money]) -> Money
    
    func sub(money:[Money]) -> Money
    
}

extension Double{
    
    var USD: Money {return Money(amount: self, currency: .USD)}
    
    var GBP: Money {return Money(amount: self, currency: .GBP)}
    
    var EUR: Money {return Money(amount: self, currency: .EUR)}
    
    var CAN: Money {return Money(amount: self, currency: .CAN)}
    
}

struct Money: CustomStringConvertible, Mathematics{
    
    enum Currency: String{
        
        case USD = "USD"
        
        case GBP = "GBP"
        
        case EUR = "EUR"
        
        case CAN = "CAN"
        
    }
    
    var amount:Double
    
    var currency:Currency
    
    var description:String
    
    init (amount: Double,currency: Currency){
        
        self.amount = amount
        
        self.currency = currency
        
        self.description = currency.rawValue + String(amount)
        
    }
    
    func convert(convC: Currency) -> Money{
        
        let U2G = 0.5
        
        let U2E = 1.5
        
        let U2C = 1.25
        
        var amount:Double = self.amount
        
        if self.currency != convC{
        
        switch (self.currency, convC){
            
        case (.USD, .GBP):
            
            amount = amount * U2G
            
        case (.GBP, .USD):
            
            amount = amount * 1.0/U2G
            
        case (.USD, .EUR):
            
            amount = amount * U2E
            
        case (.EUR, .USD):
            
            amount = amount * 1.0/U2E
            
        case (.USD, .CAN):
            
            amount = amount * U2C
            
        case (.CAN, .USD):
            
            amount = amount * 1.0/U2C
            
        case (.GBP, .EUR):
            
            amount = amount * 1.0/U2G*U2E
            
        case (.GBP, .CAN):
            
            amount = amount * 1.0/U2G*U2C
            
        case (.EUR, .GBP):
            
            amount = amount * 1.0/U2E*U2G
            
        case (.EUR, .CAN):
            
            amount = 1.0/U2E*U2C
            
        case (.CAN, .GBP):
            
            amount = 1.0/U2C*U2G
            
        case (.CAN, .EUR):
            
            amount = 1.0/U2C*U2E
            
        default:
            
            print("Please enter one of the four currencies.")
            
            }
            
        }
        
        let m = Money(amount: amount, currency: convC)
        
        return m
    }
    
    func add(money: [Money]) -> Money{
        
        var amount = money[0].amount
        
        for index in 1...money.count-1{
            
            amount = amount + money[index].convert(self.currency).amount
            
        }
        
        let m = Money(amount:amount, currency: self.currency)
        
        return m
    
    }
    
    func sub(money: [Money]) -> Money{
        
        var amount = money[0].amount
        
        for index in 1...money.count-1{
            
            amount = amount - money[index].convert(self.currency).amount
            
        }
        
        let m = Money(amount: amount, currency: self.currency)
        
        return m
        
    }
    
}

struct Salary:CustomStringConvertible{
    
    enum Per:String{
        
        case hour = " per hour"
        
        case year = " per year"
    }
    
    var s: Money
    
    var per: Per
    
    var description: String
    
    init(s: Money, per: Per){
        
        self.s = s
        
        self.per = per
        
        self.description = s.description + per.rawValue
    }
}

class Job:CustomStringConvertible{
    
    var title:String
    
    var salary: Salary
    
    var description: String
    
    init(title:String, salary: Salary){
        
        self.title = title
        
        self.salary = salary
        
        self.description = title + " " + salary.description
        
    }
    
    func calculateIncome(hours: Double) ->Money{
        
        var amount = self.salary.s.amount
        
        if self.salary.per == .hour{
            
            amount = amount * hours
        }
        
        let m = Money(amount: amount, currency: self.salary.s.currency)
        
        return m
    }
    
    func raise(percent: Double) -> Salary{
        
        let amount = self.salary.s.amount * (1 + percent)
        
        let sal = Salary(s: Money(amount: amount, currency: self.salary.s.currency), per: self.salary.per)
        
        return sal
    }
}

class Person:CustomStringConvertible{
    
    var firstName: String
    
    var lastName: String
    
    var age: Int
    
    var job: Job?
    
    var spouse: Person?
    
    var description: String
    
    init(first: String, last: String, age: Int, job: Job?, spouse: Person?){
        
        firstName = first
        
        lastName = last
        
        self.age = age
        
        self.job = job
        
        self.spouse = spouse
        
        if self.age < 16{
            
            if self.job != nil{
                
                self.job = nil
                
                print("This person can't have a job yet!")
                
            }
            
        }
        
        if self.age < 18{
            
            if self.spouse != nil{
            
            self.spouse = nil
            
            print("This person can't get married yet!")
                
            }
        }
        
        self.description = self.firstName + " " + self.lastName + " " + "age:" + " " + String(self.age) 
    
        if self.job != nil{
            
            self.description = self.description + " " + "job:" + self.job!.description

        }
        
        if self.spouse != nil{
            
            self.description = self.description + " " + "spouse:" + self.spouse!.description
        }
        
    }
    
    
    func toString(){
        
        print(self.description)
        
    }
    
}

class Family:CustomStringConvertible{
    
    var members:[Person]
    
    var description:String
    
    init(members: [Person]){
        
        self.members = members
        
        self.description = ""
        
        var isFamily = false
        
        for index in 0...self.members.count - 1{
        
            if self.members[index].age > 21{
                
                isFamily = true
                
            }
            
            self.description = self.description + self.members[index].description
        }
        
        if !isFamily{
            
            print("This is not a family!")
            
        }

    }
    
    func householdIncome() -> Money{
        
        var mon = [Money]()
        
        for index in 0...members.count - 1{
            
            if members[index].job != nil{
            
            mon.append(members[index].job!.salary.s)
            }
        }
        
        return (members[0].job?.salary.s.add(mon))!
        
    }
    
    func haveChild() -> Family{
        
        self.members.append(Person(first:"NA", last: "NA", age:0, job: nil, spouse: nil))
        
        return self
        
    }
}

var a = Money(amount: 3, currency: .EUR)

var b = Money(amount: 5.6, currency: .USD)

var c = Money(amount: 2.3, currency: .GBP)

var d = Money(amount: 1.0, currency: .CAN)

//Testing the extension for Double

print(a.amount.USD.description)

print(3.56.EUR.description)

//Testing CustomStringConvertible protocol for Money

print(a.description)

print(b.description)

print(c.description)

print(d.description)

//Testing Mathematics protocol

print("The total amount is:", a.add([a,b,c,d]).description)

print("The amount after subtract is:", a.sub([a,b,c,d]).description)

var saa = Salary(s: a, per: .year)

var sa = Salary(s: b, per: .hour)

var j1 = Job(title: "sde", salary: sa)

var j = Job(title: "worker", salary: saa)

//Testing functions and protocols for job

print("The salary after raising is:", j.raise(0.5).description)

print("The salary after raising is:", j1.raise(0.2).description)

print("The income is:", j.calculateIncome(4.2).description)

print("The income is:", j1.calculateIncome(2.1).description)

var p1 = Person(first: "jia", last: "yu", age: 17, job: j1, spouse: nil)

var p2 = Person(first: "xxx", last: "xx", age: 20, job: j1, spouse: p1)

var p3 = Person(first: "ww", last: "aa", age: 15, job: j, spouse: p2)

var p4 = Person(first: "ws", last: "as", age: 25, job: j, spouse: p2)

var f1 = Family(members: [p1,p2,p3])

var f2 = Family(members: [p1,p4])

//Testing protocol for person

print("p1:" + p1.description)

print("p2:" + p2.description)

print("p3:" + p3.description)

print("p4:" + p4.description)

//Testing toString function for person

p1.toString()

p2.toString()

//Testing functions and protocols for family

print("How many members are there in f1?", f1.members.count)

print(f1.description)

print(f2.description)

f1.haveChild()

print("How many members are there after having a child in f1?", f1.members.count)

print(f1.description)

print("The total income of f1:", f1.householdIncome().description)

print("The total income of f2:", f2.householdIncome().description)











