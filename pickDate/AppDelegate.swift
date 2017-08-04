//
//  AppDelegate.swift
//  pickDate
//
//  Created by nickLin on 2017/8/4.
//  Copyright © 2017年 nickLin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame:UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainVC()

        return true
    }



}

public struct OptionalEdge {
    public var top: CGFloat?
    public var left: CGFloat?
    public var bottom: CGFloat?
    public var right: CGFloat?
    public init(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil){
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
}

// MARK:- extension UIView - With AutoLayout
extension UIView {

    @discardableResult func mLay(_ attribute:NSLayoutAttribute,_ relatedBy:NSLayoutRelation,_ toItem:Any?,_ attribute1:NSLayoutAttribute , multiplier: CGFloat , constant: CGFloat)->NSLayoutConstraint{
        self.translatesAutoresizingMaskIntoConstraints = false
        let layout = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relatedBy, toItem: toItem, attribute: attribute1, multiplier: multiplier, constant: constant)
        layout.isActive = true
        return layout
    }

    @discardableResult func mLay(_ attribute:NSLayoutAttribute,_ relatedBy:NSLayoutRelation,_ toItem:Any?)->NSLayoutConstraint{
        return mLay(attribute, relatedBy, toItem, attribute, multiplier:1, constant:0)
    }

    @discardableResult func mLay(_ attribute:NSLayoutAttribute,_ constant: CGFloat)->NSLayoutConstraint{
        return mLay(attribute, .equal, nil, attribute,multiplier: 1, constant:constant)
    }

    @discardableResult func mLay(_ attribute:NSLayoutAttribute,_ relatedBy:NSLayoutRelation,_ toItem:Any?, multiplier: CGFloat, constant: CGFloat)->NSLayoutConstraint{
        return mLay(attribute, relatedBy , toItem, attribute, multiplier:multiplier, constant:constant)
    }

    @discardableResult func mLay(_ attribute:NSLayoutAttribute,_ relatedBy:NSLayoutRelation,_ toItem:Any?,  constant: CGFloat)->NSLayoutConstraint{
        return mLay(attribute, relatedBy , toItem, attribute, multiplier:1, constant:constant)
    }

    @discardableResult func mLay(_ attribute:NSLayoutAttribute,_ relatedBy:NSLayoutRelation,_ toItem:Any?,_ attribute1:NSLayoutAttribute ,constant: CGFloat)->NSLayoutConstraint{
        return mLay(attribute, relatedBy , toItem, attribute1, multiplier:1, constant:constant)
    }

    @discardableResult func mLay(pin:UIEdgeInsets,to view:UIView? = nil)->[NSLayoutConstraint]{
        assert(view != nil || superview != nil, "can't add Constraint to nil , superview and parmater view is nil")
        return [  mLay(.top    , .equal , view ?? superview! , constant:  pin.top    ),
                  mLay(.left   , .equal , view ?? superview! , constant:  pin.left   ),
                  mLay(.bottom , .equal , view ?? superview! , constant: -pin.bottom ),
                  mLay(.right  , .equal , view ?? superview! , constant: -pin.right  )]
    }

    @discardableResult func mLayEqualSuper()->[NSLayoutConstraint]{
        return mLay(pin: .zero)
    }

    @discardableResult func mLay(pin:OptionalEdge,to view:UIView? = nil)->[NSLayoutConstraint]{
        assert(view != nil || superview != nil, "can't add Constraint to nil , superview and parmater view is nil")
        var arr : [NSLayoutConstraint] = []
        if let top    = pin.top   {  arr.append( mLay(.top    , .equal , view ?? superview!, constant:  top    ) ) }
        if let left   = pin.left  {  arr.append( mLay(.left   , .equal , view ?? superview!, constant:  left   ) ) }
        if let bottom = pin.bottom{  arr.append( mLay(.bottom , .equal , view ?? superview!, constant: -bottom ) ) }
        if let right  = pin.right {  arr.append( mLay(.right  , .equal , view ?? superview!, constant: -right  ) ) }
        return arr
    }

    @discardableResult func mLayCenterXY(to view:UIView? = nil)->[NSLayoutConstraint]{
        assert(view != nil || superview != nil, "can't add Constraint to nil , superview and parmater view is nil")
        return [ mLay(.centerY, .equal, view ?? superview! ),
                 mLay(.centerX, .equal, view ?? superview! )]
    }

    @discardableResult func mLay(size:CGSize)->[NSLayoutConstraint]{
        return [ mLay(.height, size.height),
                 mLay(.width , size.width)]
    }
}

extension NSLayoutConstraint {

    @discardableResult func priority(_ pri: UILayoutPriority)->NSLayoutConstraint
    {
        self.priority = pri
        return self
    }
    
}

// MARK: - 列印出程式碼的檔案名 Func 名 列數 及原本的名稱
public func print<T>(msg: T,file: String = #file,method: String = #function,line: Int = #line)
{
    // build setting - Other Swift Flags - Debug  Add ( -D  DEBUG )
    #if DEBUG
        Swift.print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(msg)")
    #endif
}

// MARK:- UIPopoverPresentationControllerDelegate
extension UIViewController : UIPopoverPresentationControllerDelegate {


    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    public func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool{
        // popoverPresentationController.presentedViewController 被推出來的 viewController
        return false
    }

    func popover(pop:UIViewController,size:CGSize,arch:UIView,Direction:UIPopoverArrowDirection){
        pop.modalPresentationStyle = .popover
        pop.popoverPresentationController?.delegate = self
        pop.popoverPresentationController?.sourceView = arch
        pop.popoverPresentationController?.sourceRect = arch.bounds
        pop.preferredContentSize = size
        pop.popoverPresentationController?.permittedArrowDirections = Direction
        self.present(pop, animated: true, completion: nil)
    }
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }

}


extension UICollectionView {
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        let className = cellType.className
        register(cellType, forCellWithReuseIdentifier: className)
    }

    func register<T: UICollectionViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { register(cellType: $0) }
    }


    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }
}


extension NSObject {
    @nonobjc class var className: String {
        return String(describing: self)
    }

    @nonobjc var className: String {
        return type(of: self).className
    }
}

extension Date {
    func add(_ number: Int ,_ component : Calendar.Component) -> Date{
        return Calendar.current.date(byAdding: component, value: number, to: self)!
    }

    // 取得年份
    @nonobjc var year : Int{
        get{
            let df = DateFormatter()
            df.dateFormat = "yyyy"
            return df.string(from: self).intValue
        }
    }
    // 取得月份
    @nonobjc var month : Int{
        get{
            let df = DateFormatter()
            df.dateFormat = "MM"
            return df.string(from: self).intValue
        }
    }
    // 取得日期
    @nonobjc var day : Int{
        get{
            let df = DateFormatter()
            df.dateFormat = "dd"
            return df.string(from: self).intValue
        }
    }

}

extension String {
    @nonobjc var intValue : Int {
        return (self as NSString).integerValue
    }
}

extension Int {
    @nonobjc var stringValue : String {
        return "\(self)"
    }
}
