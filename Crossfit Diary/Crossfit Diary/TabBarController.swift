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
        let rmVC = RMViewController()
        rmVC.tabBarItem = UITabBarItem(title: "PR", image: UIImage(systemName: "chart.bar.xaxis"), selectedImage: nil)
        calendarVC.tabBarItem = UITabBarItem(title: "기록", image: UIImage(systemName: "note.text"), selectedImage: nil)
        mapVC.tabBarItem = UITabBarItem(title: "주변 박스", image: UIImage(systemName: "mappin.and.ellipse"), selectedImage: nil)
        let calendarNav = UINavigationController(rootViewController: calendarVC)
        let rmNav = UINavigationController(rootViewController: rmVC)
        self.tabBar.tintColor = .mainColor
        self.tabBar.backgroundColor = .systemBackground
        viewControllers = [calendarNav, rmNav, mapVC]
    }
}
