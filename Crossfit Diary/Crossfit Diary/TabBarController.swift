//
//  HomeController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/09.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        let calendarVC = CalendarViewController()
        let mapVC = MapViewController()
        
        calendarVC.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "calendar"), selectedImage: nil)
        mapVC.tabBarItem = UITabBarItem(title: "Boxes", image: UIImage(systemName: "mappin.and.ellipse"), selectedImage: nil)
        let calendarNav = UINavigationController(rootViewController: calendarVC)
        self.tabBar.backgroundColor = .systemBackground
        viewControllers = [calendarNav, mapVC]
    }
}
