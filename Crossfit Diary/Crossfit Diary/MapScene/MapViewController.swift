//
//  MapViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/09.
//

import UIKit
import MapKit

class MapViewController: BaseViewController {
    lazy var button: UIButton = {
        
        let button = UIButton(type: .system)
        button.frame.origin = .init(x: view.center.x - 100, y: view.center.y - 100)
        button.frame.size = .init(width: 200, height: 200)
        button.setTitle("Pull-Down 메뉴 버튼", for: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        let favorite = UIAction(title: "평점입력", image: UIImage(systemName: "star"), state: .off, handler: { _ in print("평점입력") })
        button.menu = UIMenu(title: "타이틀",
                             image: UIImage(systemName: "heart"),
                             identifier: nil,
                             options: .displayInline,
                             children: [favorite])
        self.button.showsMenuAsPrimaryAction = true
        
    }
    


}
