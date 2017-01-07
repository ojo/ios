//
//  StationsVCFactory.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/28/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit

class StationsViewControllerFactory {
    // returns a VC implementation depending on the number of stations
    static func make(withStations stations: [Station], bounds: CGRect) -> UIViewController {
        // we special-case 3 stations because we expect to have three stations for a long time.
        // If it is any other number, we simply fall back to default collection behavior.
        if stations.count == 3 {
            return Stations3ViewController(stations: stations)
        }
        return StationsCollectionViewController(withStations: stations, rect: bounds)
    }
}
