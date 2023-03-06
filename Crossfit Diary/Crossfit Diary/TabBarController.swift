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
        
        // notification
        NotificationManager.shared.requestNotificationAuth { error in
            let alert = UIAlertController(title: "푸쉬알람 등록에 실패했습니다", message: "다시 시도해주세요", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
    }
}
