//
//  NetworkManager.swift
//  zalon
//
//  Created by el rs on 12/23/15.
//  Copyright © 2015 hap. All rights reserved.
//

import Foundation
import XCGLogger
import ReachabilitySwift

class NetworkManager {
    static let sharedInstance = NetworkManager()
    
    let _log = XCGLogger.defaultInstance()
    
    // network status
    var _status:Reachability.NetworkStatus = Reachability.NetworkStatus.NotReachable;
    var _connected:Bool = false;
    
    private init() {
        _log.debug("initialise")
        initReachability()
    }
    
    /* check network connection & init reachability lib
    */
    private func initReachability() {
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            _log.error("Unable to create Reachability")
            return
        }
        self._status = reachability.currentReachabilityStatus
        reachability.whenReachable = { reachability in
            self._status = reachability.currentReachabilityStatus
            if reachability.isReachableViaWiFi() {
                self._log.info("Reachable via WiFi")
            } else {
                self._log.info("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { reachability in
            self._status = reachability.currentReachabilityStatus
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            self._log.info("Not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            _log.error("Unable to start notifier")
        }
    }

    deinit {
        _log.debug("deinitialise")
    }
}