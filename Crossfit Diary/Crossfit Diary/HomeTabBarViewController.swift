//
//  HomeTabBarViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/09.
//

class HomeTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let calendarTab = CalendarViewController()
        let mapTab = MapViewController()
        let calendarTabBarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "calendar"), selectedImage: nil)
        let mapTabBarItem = UITabBarItem(title: "Box", image: UIImage(systemName: "mappin.and.ellipse"), selectedImage: nil)
        
        calendarTab.tabBarItem = calendarTabBarItem
        mapTab.tabBarItem = mapTabBarItem
        setViewControllers([calendarTab, mapTab], animated: true)
    }
    

    

}
