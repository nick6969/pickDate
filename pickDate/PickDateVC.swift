//
//  ViewController.swift
//  pickDate
//
//  Created by nickLin on 2017/8/4.
//  Copyright © 2017年 nickLin. All rights reserved.
//

import UIKit

class PickDateVC : UIViewController {

    fileprivate let yearSelect : ThereSelectView = {
        let select = ThereSelectView()
        select.backgroundColor = UIColor.init(netHex: 0xf3a528)
        return select
    }()

    fileprivate let monthSelect : ThereSelectView = {
        let select = ThereSelectView()
        select.backgroundColor = UIColor.init(netHex: 0xf3a528)
        return select
    }()

    fileprivate let layout : UICollectionViewFlowLayout = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()

    fileprivate lazy var dayCollection : UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.init(netHex: 0xf4f4f4)
        collection.register(cellTypes: [WeekDayCell.self,DayCell.self])
        return collection
    }()

    fileprivate let weekDayString = Calendar.current.veryShortStandaloneWeekdaySymbols
    fileprivate var dateInfos : [dateInfo] = []

    var selectDate : Date = Date() {
        didSet{
            reloadView()
        }
    }
    fileprivate let monthDic : [Int:String] = [1:"一月",2:"二月",3:"三月",4:"四月",5:"五月",6:"六月",7:"七月",8:"八月",9:"九月",10:"十月",11:"十一月",12:"十二月"]


    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
        selectDate = Date()
    }

    fileprivate func setupUI()
    {
        view.backgroundColor = .white
        view.addSubview(yearSelect)
        view.addSubview(monthSelect)
        view.addSubview(dayCollection)

        yearSelect.mLay(pin: .init(top: 20, left: 0, right: 0))
        yearSelect.mLay(.height, 60)

        monthSelect.mLay(.width, .equal, view)
        monthSelect.mLay(.centerX, .equal, view)
        monthSelect.mLay(.top, .equal, yearSelect , .bottom , constant:5)
        monthSelect.mLay(.height, 60)

        dayCollection.mLay(.top, .equal, monthSelect , .bottom , constant:5)
        dayCollection.mLay(pin: .init(left: 0, bottom: 0, right: 0))

        yearSelect.delegate = self
        monthSelect.delegate = self

    }

    fileprivate func reloadView()
    {

        guard let startDay = DateComponents.init(calendar: .current, timeZone: .current, year: selectDate.year, month: selectDate.month, day: 1).date else {
            return
        }
        let endDay = startDay.add(1, .month).add(-1, .day)
        dateInfos.removeAll()

        // set Year
        yearSelect.dataArray = [selectDate.add(-1, .year).year.stringValue , selectDate.year.stringValue , selectDate.add(1, .year).year.stringValue]

        // set month
        monthSelect.dataArray = [monthDic[selectDate.add(-1, .month).month]! , monthDic[selectDate.month]! , monthDic[selectDate.add(1, .month).month]!]


        // set Day
        let weekSatrtDay = Calendar.current.component(.weekday, from: startDay)
        for i in 1..<weekSatrtDay{
            let showDay = startDay.add(-(weekSatrtDay-i), .day).day
            dateInfos.append(dateInfo(day: showDay, isThisMonth: false , isSelectDay : false))
        }

        for i in 0..<endDay.day{
            let showDay = startDay.add(i, .day).day
            dateInfos.append(dateInfo(day: showDay, isThisMonth: true , isSelectDay : showDay == selectDate.day))
        }

        let weekEndDay = Calendar.current.component(.weekday, from: endDay)
        for i in 0..<(7-weekEndDay){
            let showDay = endDay.add(i+1, .day).day
            dateInfos.append(dateInfo(day: showDay, isThisMonth: false , isSelectDay : false))
        }

        dayCollection.reloadData()

    }

}

extension PickDateVC : UICollectionViewDataSource , UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return section == 0 ? weekDayString.count : dateInfos.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.section == 0
        {
            let cell = collectionView.dequeueReusableCell(with: WeekDayCell.self, for: indexPath)
            cell.label.text = weekDayString[indexPath.item]
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(with: DayCell.self, for: indexPath)
            let data = dateInfos[indexPath.item]
            cell.configCell(data)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.section == 1 {
            let data = dateInfos[indexPath.item]
            if data.isThisMonth
            {
                guard let newDay = DateComponents.init(calendar: .current, timeZone: .current, year: selectDate.year, month: selectDate.month, day: data.day).date else {
                    return
                }
                selectDate = newDay
            }
            else
            {
                if indexPath.item > dateInfos.count - 7
                {
                    let newDate = selectDate.add(1, .month)
                    guard let newDay = DateComponents.init(calendar: .current, timeZone: .current, year: newDate.year, month: newDate.month, day: data.day).date else {
                        return
                    }
                    selectDate = newDay
                }
                else
                {
                    let newDate = selectDate.add(-1, .month)
                    guard let newDay = DateComponents.init(calendar: .current, timeZone: .current, year: newDate.year, month: newDate.month, day: data.day).date else {
                        return
                    }
                    selectDate = newDay
                }
            }
        }
    }

}

extension PickDateVC : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.section == 0
        {
            return CGSize(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.12)
        }
        else
        {
            return CGSize(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.18)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return .init(top: 8, left: 8, bottom: 0, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 8
    }

}

extension PickDateVC : ThereSelectViewDelegate {

    func tapRightButton(sender:ThereSelectView)
    {
        if sender == yearSelect
        {
            selectDate = selectDate.add(1, .year)
        }
        else
        {
            selectDate = selectDate.add(1, .month)
        }
    }

    func tapLeftButton(sender:ThereSelectView)
    {
        if sender == yearSelect
        {
            selectDate = selectDate.add(-1, .year)
        }
        else
        {
            selectDate = selectDate.add(-1, .month)
        }
    }

}

struct dateInfo {
    var day : Int
    var isThisMonth : Bool
    var isSelectDay : Bool
}

protocol ThereSelectViewDelegate {
    func tapRightButton(sender:ThereSelectView)
    func tapLeftButton(sender:ThereSelectView)
}

class ThereSelectView : UIView {
    var delegate : ThereSelectViewDelegate?

    var dataArray : [String] = ["","",""] {
        didSet{
            guard dataArray.count == 3 else {
                fatalError("輸入文字數量錯誤")
            }
            leftShowButton.label.text = dataArray[0]
            centerShowButton.label.text = dataArray[1]
            rightShowButton.label.text = dataArray[2]
        }
    }

    let leftShowButton      = SelectButton()
    let centerShowButton    = SelectButton()
    let rightShowButton     = SelectButton()

    let rightButton = UIButton()
    let leftButton = UIButton()


    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(leftShowButton)
        addSubview(centerShowButton)
        addSubview(rightShowButton)

        leftButton.mLay(.width, .equal, self, multiplier: 1/8, constant: 0)
        leftButton.mLay(.centerY, .equal, self)
        leftButton.mLay(.height, .equal, self, constant: -8)
        leftButton.mLay(.centerX, .equal, self, multiplier: 1/8, constant: 0)

        rightButton.mLay(.width, .equal, self, multiplier: 1/8, constant: 0)
        rightButton.mLay(.centerY, .equal, self)
        rightButton.mLay(.height, .equal, self, constant: -8)
        rightButton.mLay(.centerX, .equal, self, multiplier: 15/8, constant: 0)

        leftShowButton.mLay(.width, .equal, self, multiplier: 1/4, constant: 0)
        leftShowButton.mLay(.centerY, .equal, self)
        leftShowButton.mLay(.height, .equal, self, constant: -8)
        leftShowButton.mLay(.centerX, .equal, self, multiplier: 4/8, constant: 0)

        centerShowButton.mLay(.width, .equal, self, multiplier: 1/4, constant: 0)
        centerShowButton.mLay(.centerY, .equal, self)
        centerShowButton.mLay(.height, .equal, self, constant: -8)
        centerShowButton.mLay(.centerX, .equal, self, multiplier: 8/8, constant: 0)

        rightShowButton.mLay(.width, .equal, self, multiplier: 1/4, constant: 0)
        rightShowButton.mLay(.centerY, .equal, self)
        rightShowButton.mLay(.height, .equal, self, constant: -8)
        rightShowButton.mLay(.centerX, .equal, self, multiplier: 12/8, constant: 0)

        centerShowButton.isSelected = true

        leftButton.imageEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        rightButton.imageEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        leftButton.setImage(UIImage(named:"icon_anchor_left"), for: .normal)
        rightButton.setImage(UIImage(named:"icon_anchor_right"), for: .normal)

        leftButton.addTarget(self, action: #selector(tapLeft), for: .touchUpInside)
        leftShowButton.addTarget(self, action: #selector(tapLeft), for: .touchUpInside)

        rightButton.addTarget(self, action: #selector(tapRight), for: .touchUpInside)
        rightShowButton.addTarget(self, action: #selector(tapRight), for: .touchUpInside)

    }

    func tapLeft()
    {
        delegate?.tapLeftButton(sender: self)
    }

    func tapRight()
    {
        delegate?.tapRightButton(sender: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

class SelectButton : UIControl {
    let label = UILabel()
    override var isSelected: Bool {
        get{
            return false
        }
        set{
            if newValue
            {
                label.layer.borderColor = UIColor.white.cgColor
                label.layer.borderWidth = 1
                label.font = UIFont.systemFont(ofSize: 16)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.mLayEqualSuper()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
