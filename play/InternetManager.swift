
//
//  InternetManager.swift
//  
//
//  Created by Alexandru-Mihai Manolescu on 08/09/2019.
//

import Foundation
import Network
import Firebase
import FirebaseDatabase
import FirebaseAuth

var isDeviceOnline = false

func checkConnection()
{
    let monitor = NWPathMonitor()
    let prntmsgg = "CI: guqoq3ou4q34g4gheah running checkConnection()"
    
    monitor.pathUpdateHandler = { path in
        if path.status == .satisfied {
            print("\(prntmsgg) We're connected!")
            isDeviceOnline=true
        } else {
            print("\(prntmsgg) No connection.")
            isDeviceOnline=false
        }
        
        //print(path.isExpensive)
    }
    
    let queue = DispatchQueue(label: "Monitor")
    monitor.start(queue: queue)
}

