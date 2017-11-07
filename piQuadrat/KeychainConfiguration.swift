//
//  Credentials.swift
//  piQuadrat
//
//  Created by pau on 10/13/17.
//  Copyright © 2017 pau. All rights reserved.
//

import Foundation
struct KeychainConfiguration {
    static let serviceName = "PiQuadratService"
    
    /*
     Specifying an access group to use with `KeychainPasswordItem` instances
     will create items shared accross both apps.
     
     For information on App ID prefixes, see:
     https://developer.apple.com/library/ios/documentation/General/Conceptual/DevPedia-CocoaCore/AppID.html
     and:
     https://developer.apple.com/library/ios/technotes/tn2311/_index.html
     */
    
    static let accessGroup: String? = nil
    

}
