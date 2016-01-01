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
import SideMenu


class ViewController: UIViewController {
    
    let url = "http://jsonplaceholder.typicode.com/posts/1"
    
    private var selectedIndex = 0
    private var transitionPoint: CGPoint!
    private var navigator: UINavigationController!
    lazy private var menuAnimator : MenuTransitionAnimator! = MenuTransitionAnimator(mode: .Presentation, shouldPassEventsOutsideMenu: false) { [unowned self] in
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier, segue.destinationViewController) {
        case (.Some("menuNavigator"), let menu as MenuViewController):
            menu.selectedItem = selectedIndex
            menu.delegate = self
            menu.transitioningDelegate = self
            menu.modalPresentationStyle = .Custom
        case (.Some("embeddedNavigator"), let navigator as UINavigationController):
            self.navigator = navigator
            self.navigator.delegate = self
        default:
            super.prepareForSegue(segue, sender: sender)
        }
    }
    
    func prepareForSegue1(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier);
        print("-------------------------------");
        switch (segue.identifier, segue.destinationViewController) {
        case (.Some("menuNavigator"), let menu as MenuViewController):
            print("Selected presentMenu")
        case (.Some("embeddedNavigator"), let navigator as UINavigationController):
            print("Selected embedded navigator")
        default:
            print("Selected default")
            super.prepareForSegue(segue, sender: sender)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
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
    */
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

extension ViewController: MenuViewControllerDelegate {
    func menu(_: MenuViewController, didSelectItemAtIndex index: Int, atPoint point: CGPoint) {
//        contentType = !contentType
//        transitionPoint = point
//        selectedIndex = index
//        
//        let content = storyboard!.instantiateViewControllerWithIdentifier("Content") as! ContentViewController
//        content.type = contentType
//        self.navigator.setViewControllers([content], animated: true)
//        
//        dispatch_async(dispatch_get_main_queue()) {
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
    }
    
    func menuDidCancel(_: MenuViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ViewController: UINavigationControllerDelegate {
    func navigationController(_: UINavigationController, animationControllerForOperation _: UINavigationControllerOperation,
        fromViewController _: UIViewController, toViewController _: UIViewController) -> UIViewControllerAnimatedTransitioning? {            
            return CircularRevealTransitionAnimator(center: transitionPoint)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController _: UIViewController,
        sourceController _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return menuAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuTransitionAnimator(mode: .Dismissal)
    }
    
}

