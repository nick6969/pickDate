//
//  MainVC.swift
//  pickDate
//
//  Created by nickLin on 2017/8/4.
//  Copyright © 2017年 nickLin. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(button)
        button.setTitle("選擇日期", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(showPickDate), for: .touchUpInside)

        button.mLay(size: CGSize(width: 100, height: 50))
        button.mLayCenterXY()
    }

    func showPickDate()
    {
        let vc = PickDateVC()
        self.present(vc, animated: true, completion: nil)
    }

}
