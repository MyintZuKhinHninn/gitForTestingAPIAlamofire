//
//  CentralBankClass.swift
//  TestingAPIAlamofire
//
//  Created by khinhninmyintzu on 5/20/19.
//  Copyright © 2019 khinhninmyintzu. All rights reserved.
//

import Foundation
import ObjectMapper

class CentralBankClass {
    
    var id : Int!
    var info : String!
    var description : String!
    var timestamp : Int!

    
    required init?()
    {
        
    }
    
    required init(id : Int, info : String, description : String, timestamp : Int){
        self.id = id
        self.info = info
        self.description = description
        self.timestamp = timestamp
    }
}
