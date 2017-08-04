//
//  Cell.swift
//  pickDate
//
//  Created by nickLin on 2017/8/4.
//  Copyright © 2017年 nickLin. All rights reserved.
//

import UIKit

class DayCell : UICollectionViewCell {

    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setUI(frame: CGRect){
        contentView.addSubview(label)
        label.mLay(pin: .zero, to: contentView)
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width / 20)
        label.textAlignment = .center
        contentView.layer.borderColor = UIColor.init(netHex: 0xd8d8d8).cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 4
    }

    func configCell(_ model:dateInfo)
    {

        if model.isThisMonth
        {
            if model.isSelectDay
            {
                label.textColor = .white
                contentView.backgroundColor = UIColor.init(netHex: 0xf3a528)
            }
            else
            {
                label.textColor = UIColor.init(netHex: 0xb7b7b7)
                contentView.backgroundColor = .white
            }
        }
        else
        {
            label.textColor = UIColor.init(netHex: 0xe0e0e0)
            contentView.backgroundColor = UIColor.init(netHex: 0xf0f0f0)
        }
        label.text = "\(model.day)"
    }

}

class WeekDayCell : UICollectionViewCell {

    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setUI(frame: CGRect){
        contentView.addSubview(label)
        label.mLay(pin: .zero, to: contentView)
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width / 20)
        label.textAlignment = .center
        contentView.backgroundColor = .clear
    }
}
