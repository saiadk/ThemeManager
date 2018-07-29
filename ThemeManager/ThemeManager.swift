//
//  ThemeManager.swift
//  ThemeManager
//
//  Created by Mangaraju, Venkata Maruthu Sesha Sai [GCB-OT NE] on 7/28/18.
//  Copyright © 2018 Sai. All rights reserved.
//

import Foundation
import UIKit

//Application Theme
enum Theme: String{

    case blue
    case green
    
    /** Get theme's default styles for all UI element **/
    
    func applyThemeDefaults(){
        
        guard let defaultTheme = ThemeManager.currentTheme["DefaultStyles"] as? [String:AnyObject] else{
            return
        }
        
        self.setUIElementDefaultTheme(defaultTheme)
        self.setNavigationBarDefaultTheme(defaultTheme)
        self.setViewDefaultTheme(defaultTheme)
        
    }
    
    
    /** Get theme's building blocks **/
    func getThemeBuildingBlocks()->(fonts:[String:String], sizes:[String:String], colors:[String:String]){
        
        var buildingBlocks:(fonts:[String:String], sizes:[String:String], colors:[String:String]) = ([:], [:], [:])
        
        guard let themeBuildingBlocks = ThemeManager.currentTheme["ThemeBuildingBlocks"] as? [String:[String:String]] else{
            return buildingBlocks
        }
        
        if let fonts = themeBuildingBlocks["fonts"],
           let sizes = themeBuildingBlocks["sizes"],
           let colors = themeBuildingBlocks["colors"]{
            buildingBlocks = (fonts, sizes, colors)
        }
        return buildingBlocks
    }
    
    
    
    /** Get theme's reusable style combinations **/
    
    func getThemeReusableStyleCombinations()->[String:[String:String]]{
        
        var reusableStyles = [String:[String:String]]()
        
        if let themeBuildingBlocks = ThemeManager.currentTheme["ReusableStyleCombinations"] as? [String:[String:String]] {
            reusableStyles = themeBuildingBlocks
        }
        return reusableStyles
    }
    
    
    
    func resetNavigationBarDefaultTheme(themeDefaults: [String:AnyObject]){
        self.setNavigationBarDefaultTheme(themeDefaults)
    }
    
    private func setUIElementDefaultTheme(_ themeDefaults: [String:AnyObject]){
        
        //UILabel
        if let labelStyles = themeDefaults["UILabel"]{
            UILabel.appearance().applyStyles(withStyleInfo: labelStyles)
        }
        
        //UITextfield
        if let textfieldStyles = themeDefaults["UITextField"]{
            
            UITextField.appearance().applyStyles(withStyleInfo: textfieldStyles)
        }
        
        //UITextview
        if let textviewStyles = themeDefaults["UITextView"]{
            UITextView.appearance().applyStyles(withStyleInfo: textviewStyles)
        }
        
        //UIButton
        if let buttonStyles = themeDefaults["UIButton"]{
            UIButton.appearance().applyStyles(withStyleInfo: buttonStyles)
        }
        
        //UIBarButtonItem
        if let barButtonStyles = themeDefaults["UIBarButtonItem"]{
            
            let barButtonStylesDict = ThemeManager.getStyleDict(fromStyleInfo: barButtonStyles)
            
            if let tintColor = barButtonStylesDict["tintColor"] {
                UIBarButtonItem.appearance().tintColor = UIColor.colorWithHexValue(tintColor as NSString)
            }
        }
        
        //UISwitch
        if let switchStyles = themeDefaults["UISwitch"]{
            UISwitch.appearance().applyStyles(withStyleInfo: switchStyles)
        }
        
    }
    
    private func setNavigationBarDefaultTheme(_ themeDefaults: [String:AnyObject]){
        if let navigationBarStyles = themeDefaults["UINavigationBar"]{
            UINavigationBar.appearance().applyStyles(withStyleInfo: navigationBarStyles)
            UIToolbar.appearance().applyStyles(withStyleInfo: navigationBarStyles)
        }
    }
    
    private func setViewDefaultTheme(_ themeDefaults: [String:AnyObject]){
        
        if let viewStyles = themeDefaults["UIView"]{
            UIView.appearance().applyViewStyle(withStyleInfo: viewStyles)
        }
    }
}




////Application Theme
enum StyleTypes {
    
    /** This notation is to capture styles for Label, Textfield, Button */
    case UIElement(font:String, size:CGFloat, color:String)
    
    /** This notation is to capture styles for NavigationBar */
    case NavBar(tintColor:String, barTint:String, translucent:Bool)
    
    /** This notation is to capture styles for View */
    case UIView(backgroundColor:String)
}






/** ***********************     Color extension *********************************/

extension UIColor {
    
    class func colorWithHexValue(_ hexValue:NSString) -> UIColor {
        
        var c:UInt32 = 0xffffff
        
        if hexValue.hasPrefix("#") {
            Scanner(string: hexValue.substring(from: 1)).scanHexInt32(&c)
        }else{
            Scanner(string: hexValue as String).scanHexInt32(&c)
        }
        
        if hexValue.length > 7 {
            return UIColor(red: CGFloat((c & 0xff000000) >> 24)/255.0, green: CGFloat((c & 0xff0000) >> 16)/255.0, blue: CGFloat((c & 0xff00) >> 8)/255.0, alpha: CGFloat(c & 0xff)/255.0)
        }else{
            return UIColor(red: CGFloat((c & 0xff0000) >> 16)/255.0, green: CGFloat((c & 0xff00) >> 8)/255.0, blue: CGFloat(c & 0xff)/255.0, alpha: 1.0)
        }
    }
}


/** ***************************     Label Styles  *********************************/

extension UILabel {
    func applyStyles(withStyleInfo styleInfo: AnyObject) {
        
        let styleDict = ThemeManager.getStyleDict(fromStyleInfo: styleInfo)
        
        //Cannot check class as it is Private
        if self.isMember(of: UILabel.self){
            if let font = styleDict["fontName"],
               let size = styleDict["size"],
               let color = styleDict["color"]{
                    self.font = UIFont(name: ThemeManager.getThemeFont(forCode: font), size: ThemeManager.getThemeSize(forCode: size))
                    self.textColor = ThemeManager.getThemeColor(forCode: color)
            }
        } else {
            
            self.lineBreakMode = .byTruncatingMiddle
        }
    }
    
}


/** ***************************     Textfield Styles  *********************************/

extension UITextField {
    func applyStyles(withStyleInfo styleInfo: AnyObject) {
        
        let styleDict = ThemeManager.getStyleDict(fromStyleInfo: styleInfo)
        
        if let font = styleDict["fontName"],
           let size = styleDict["size"],
           let color = styleDict["color"]{
                self.font = UIFont(name: ThemeManager.getThemeFont(forCode: font), size: ThemeManager.getThemeSize(forCode: size))
                self.textColor = ThemeManager.getThemeColor(forCode: color)
        }
    }
}

/** ***************************     Textview Styles  *********************************/

extension UITextView {
    
    func applyStyles(withStyleInfo styleInfo: AnyObject) {
        
        let styleDict = ThemeManager.getStyleDict(fromStyleInfo: styleInfo)
        
        if let font = styleDict["fontName"],
           let size = styleDict["size"],
           let color = styleDict["color"]{
                self.font = UIFont(name: ThemeManager.getThemeFont(forCode: font), size: ThemeManager.getThemeSize(forCode: size))
                self.textColor = ThemeManager.getThemeColor(forCode: color)
        }
    }
}


/** ***************************     Button Styles  *********************************/

extension UIButton {
    
    func applyStyles(withStyleInfo styleInfo: AnyObject) {
        
        if self.isMember(of:UIButton.self){
            
            let styleDict = ThemeManager.getStyleDict(fromStyleInfo: styleInfo)
            
            if let font = styleDict["fontName"],
               let size = styleDict["size"],
               let color = styleDict["color"]{
                
                    self.setTitleColor(ThemeManager.getThemeColor(forCode: color), for: .normal)
                    self.setTitleColor(ThemeManager.getThemeColor(forCode: color), for: .highlighted)
                    self.setTitleColor(ThemeManager.getThemeColor(forCode: color), for: .selected)
                    self.titleLabel?.font = UIFont(name: ThemeManager.getThemeFont(forCode: font), size: ThemeManager.getThemeSize(forCode: size))
                
            }
            
        }
    }
}

/** ***************************     NavigationBar Styles  *********************************/


extension UINavigationBar {
    
    func applyStyles(withStyleInfo styleInfo: AnyObject) {
        
        let styleDict = ThemeManager.getStyleDict(fromStyleInfo: styleInfo)
        
         if let tintColor = styleDict["tintColor"],
            let barTint = styleDict["barTint"],
            let translucent = styleDict["translucent"],
            let titleColor = styleDict["titleColor"]{
            
                self.tintColor = ThemeManager.getThemeColor(forCode: tintColor)
                self.barTintColor = ThemeManager.getThemeColor(forCode: barTint)
                self.isTranslucent = (translucent == "true")
                self.titleTextAttributes = [NSAttributedStringKey.foregroundColor: ThemeManager.getThemeColor(forCode: titleColor)]
        }
    }
}

/** ***************************     UIToolbar Styles  *********************************/

extension UIToolbar {
    
    func applyStyles(withStyleInfo styleInfo: AnyObject) {
        
        let styleDict = ThemeManager.getStyleDict(fromStyleInfo: styleInfo)
        
         if let tintColor = styleDict["tintColor"],
            let barTint = styleDict["barTint"],
            let translucent = styleDict["translucent"]{
            
                self.tintColor = ThemeManager.getThemeColor(forCode: tintColor)
                self.barTintColor = ThemeManager.getThemeColor(forCode: barTint)
                self.isTranslucent = (translucent == "true")
        }
    }
}


/** ***************************     UISwitch Styles  *********************************/

extension UISwitch {
    
    func applyStyles(withStyleInfo styleInfo: AnyObject) {
        
        let styleDict = ThemeManager.getStyleDict(fromStyleInfo: styleInfo)
        
         if let tintColor = styleDict["tintColor"],
            let onTintColor = styleDict["onTintColor"],
            let thumbTintColor = styleDict["thumbTintColor"]{
            
                self.tintColor = ThemeManager.getThemeColor(forCode: tintColor)
                self.onTintColor = ThemeManager.getThemeColor(forCode: onTintColor)
                self.thumbTintColor = ThemeManager.getThemeColor(forCode: thumbTintColor)
        }
    }
}


/** ***************************     UIView Styles  *********************************/

extension UIView {
    
    func applyViewStyle(withStyleInfo styleInfo: AnyObject) {
        
        guard let viewController = self.next else{
            return
        }
        if self.isMember(of: UIView.self) && viewController.isKind(of: UIViewController.self){
            
            let styleDict = ThemeManager.getStyleDict(fromStyleInfo: styleInfo)
            
            if let bgColor = styleDict["backgroundColor"]{
                self.backgroundColor = ThemeManager.getThemeColor(forCode: bgColor)
            }
        }
    }
}



class ThemeManager {
    
    
    //App Theme
    fileprivate static var appTheme : Theme = .blue
    
    //Theme's Building Blocks
    private static var themeBuildingBlocks:(fonts:[String:String], sizes:[String:String], colors:[String:String]) = appTheme.getThemeBuildingBlocks()
    
    //Theme's reusable style combinations
    private static var themeReusableStyles:[String:[String:String]] = appTheme.getThemeReusableStyleCombinations()
    
    //Currently applied theme
    fileprivate static var currentTheme: [String:AnyObject] = [:]

    class func getAppTheme() -> Theme
    {
        return appTheme
    }
    
    class func setAppTheme(_ obj:Theme)
    {
        ThemeManager.currentTheme = [:]
        appTheme = obj
        if let themesJSON = Bundle.main.path(forResource: appTheme.rawValue, ofType: "json"){
            if let jsonData = NSData(contentsOfFile: themesJSON){
                do{
                    currentTheme = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                }catch _{
                    print("Unable to load theme JSON file")
                }
                
            }
        }
        appTheme.applyThemeDefaults()        
        
    }
    
    
    /** Apply screen specific styles here  **/
    class func applyScreenSpecificStyles(_ viewController:AnyObject){
        
        let className = NSStringFromClass(type(of: viewController)).components(separatedBy: ".")[1]
        guard let screenStyles = ThemeManager.currentTheme[className] as? [String:AnyObject] else{
            return
        }
        
        for (elementName, stylesInfo) in screenStyles{

            if let UIElement = viewController.value(forKeyPath: elementName){
                self.setStyleAttributes(forView: UIElement as AnyObject, stylesInfo: stylesInfo)
            }
        }
        
    }
    
    /* Set UIElement styles   */
    class func setStyleAttributes(forView element:AnyObject, stylesInfo:AnyObject){
        
        switch element {
        case let UIElement where UIElement.isMember(of: UIView.self):
            (UIElement as! UIView).applyViewStyle(withStyleInfo: stylesInfo)
            
        case let UIElement where UIElement.isKind(of: UITextField.self):
            (UIElement as! UITextField).applyStyles(withStyleInfo: stylesInfo)
            
        case let UIElement where UIElement.isKind(of: UIButton.self):
            (UIElement as! UIButton).applyStyles(withStyleInfo: stylesInfo)
            
        case let UIElement where UIElement.isKind(of: UINavigationBar.self):
            (UIElement as! UINavigationBar).applyStyles(withStyleInfo: stylesInfo)
            
        case let UIElement where UIElement.isKind(of: UIBarButtonItem.self):
            let stylesDict = ThemeManager.getStyleDict(fromStyleInfo: stylesInfo)
            if let tintColor = stylesDict["tintColor"]{
                (UIElement as! UIBarButtonItem).tintColor = UIColor.colorWithHexValue(tintColor as NSString)
            }
        case let UIElement where UIElement.isKind(of: UITableViewCell.self):
            let stylesDict = ThemeManager.getStyleDict(fromStyleInfo: stylesInfo)
            if let bgColor = stylesDict["backgroundColor"]{
                (UIElement as! UITableViewCell).backgroundColor = UIColor.colorWithHexValue(bgColor as NSString)
            }
            
        default:
            if element.isMember(of: UILabel.self){
                (element as! UILabel).applyStyles(withStyleInfo: stylesInfo)
            }
        }
        
    }
    
    /* Get theme font name for a given color code */
    class func getThemeFont(forCode code:String)-> String{
        return self.themeBuildingBlocks.fonts[code]!
    }
    
    /* Get theme hexadecimal color code for a given color code key */
    class func getThemeColor(forCode code:String)-> UIColor{
        if let colorCode = self.themeBuildingBlocks.colors[code] as NSString?{
            return UIColor.colorWithHexValue(colorCode)
        }
        return .clear
    }
    
    /* Get theme color hexa string for a given color code */
    class func getThemeSize(forCode code:String) -> CGFloat{
        return CGFloat(truncating: NumberFormatter().number(from: self.themeBuildingBlocks.sizes[code]!)!)
    }
    
    class func getStyleDict(fromStyleInfo styleInfo:AnyObject) -> [String:String]{
        
        guard let styleInfoKey = styleInfo as? String else{
            return styleInfo as! [String : String]
        }
        return self.themeReusableStyles[styleInfoKey]!
    }
}
