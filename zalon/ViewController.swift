//
//  ViewController.swift
//  zalon
//
//  Created by el rs on 12/22/15.
//  Copyright © 2015 hap. All rights reserved.
//

import UIKit
import Realm
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    let url = "http://jsonplaceholder.typicode.com/posts/1"

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.sharedInstance
        LocationManager.sharedInstance
        
        // Do any additional setup after loading the view, typically from a nib.
        _ = RLMRealm.defaultRealm()
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                }
            case .Failure(let error):
                print(error)
            }
        }
        /*
            realm.beginWriteTransaction()
            for (_, subJson) : (String, JSON) in entries {
                let entry : Entry = Mapper<Entry>().map(subJson.dictionaryObject)!
                realm.addOrUpdateObject(entry)
            }
            realm.commitWriteTransaction()
        */
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

