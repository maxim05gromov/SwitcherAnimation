//
//  ViewController.swift
//  SwitcherAnimation
//
//  Created by Максим Громов on 07.08.2024.
//

import UIKit

class ViewController: UIViewController {
    lazy var switcher = DayNightSwitcher(frame: .init(x: (view.frame.width - 343) / 2, y: (view.frame.height - 140) / 2, width: 343, height: 140))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(switcher)
        switcher.addTarget(self, action: #selector(switched), for: .valueChanged)
    }
    @objc func switched(){
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = self.switcher.isOn ? UIColor.darkGray : UIColor.white
        }
    }

}

