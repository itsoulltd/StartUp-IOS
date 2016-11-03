//
//  SimulatorUtility.swift
//  Jamahook
//
//  Created by Towhid on 12/20/15.
//  Copyright © 2015 Hoxro Ltd, 207 Regent Street, London, W1B 3HN. All rights reserved.
//

import Foundation

public class SimulatorUtility: NSObject{
    
    public class var running: Bool{
        return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
    }
    
}