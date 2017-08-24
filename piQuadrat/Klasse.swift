//
//  Klasse.swift
//  JsonTest
//
//  Created by pau on 8/3/17.
//  Copyright © 2017 pau. All rights reserved.
//


class Klasse {
    
    //MARK: Properties
    
    var name: String
    init(name: String) {
        if name.isEmpty {self.name = "empty"; return}
        self.name = name
    }
    
}
