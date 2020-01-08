//
//  CurrencyClass.swift
//  TestingAPIAlamofire
//
//  Created by khinhninmyintzu on 5/17/19.
//  Copyright © 2019 khinhninmyintzu. All rights reserved.
//

import UIKit

class RateClass  {
        var id : Int!
        var currency : String!
        var rate : AnyObject!
        var cbid : Int!
    
        required init?()
        {
            
        }
        
    required init(currency: String?, rate: AnyObject, idx : Int) {
        self.currency = currency
        self.rate = rate
        self.cbid = idx
        }
    
}
