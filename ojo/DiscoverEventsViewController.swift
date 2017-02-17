//
//  DiscoverEventsViewController.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import UIKit


class DiscoverEventsViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var myViewControllers = Array(repeating:UIViewController(), count: 3)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventsViewController = EventsViewController(frame: self.view.frame, type:EventsType.EVENT_TYPE_UPCOMING);
//        self.view.addSubview(eventsViewController.view)
        
        let eventsViewControllerAll = EventsViewController(frame: self.view.frame, type:EventsType.EVENT_TYPE_ALL);
//        self.view.addSubview(eventsViewControllerAll.view)
        
        
        let eventsViewControllerDiscover = EventsViewController(frame: self.view.frame, type:EventsType.EVENT_TYPE_FEATURED);
//        self.view.addSubview(eventsViewControllerDiscover.view)
        
        
        
//        let pvc = UIPageViewController()
        self.dataSource = self
        
        
        myViewControllers = [eventsViewController, eventsViewControllerAll, eventsViewControllerDiscover]
        
        self.setViewControllers([myViewControllers[1]], direction:.forward, animated:true, completion:nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = self.myViewControllers.index(of: viewController)! + 1
        if currentIndex >= self.myViewControllers.count {
            return nil
        }
        return self.myViewControllers[currentIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        var currentIndex = index(ofAccessibilityElement:(self.myViewControllers, viewController))!+1
//        var currentIndex =  indexOf(self.myViewControllers, viewController)!-1
        let currentIndex = self.myViewControllers.index(of: viewController)! - 1

        if currentIndex < 0 {
            return nil
        }
        return self.myViewControllers[currentIndex]
    }
    
//}


override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

}
