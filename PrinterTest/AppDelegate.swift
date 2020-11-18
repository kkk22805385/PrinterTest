//
//  AppDelegate.swift
//  PrinterTest
//
//  Created by aa on 2020/11/16.
//  需要在info裡面 新增 Supported external accessory protocols -> jp.star-m.starpro 才能搜尋印表機
//  framework則是用右邊的六個,ExternalAccessory是搜尋印體的

import UIKit


enum PaperSizeIndex: Int {
    case twoInch = 384
    case threeInch = 576
    case fourInch = 832
    case escPosThreeInch = 512
    case dotImpactThreeInch = 210
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    static let settingManager = SettingManager()
    
    var portName:     String!
    var portSettings: String!
    var modelName:    String!
    var macAddress:   String!
    
    var emulation:                StarIoExtEmulation!
    var cashDrawerOpenActiveHigh: Bool!
    var allReceiptsSettings:      Int!
    var selectedIndex:            Int!
    var selectedPaperSize:        Int?
    var selectedModelIndex:       Int?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.loadParam()
        
        let rootVC = MainViewController(nibName: String(describing: MainViewController.self), bundle: nil)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
                
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    fileprivate func loadParam() {
        AppDelegate.settingManager.load()
    }
    static func getPortName() -> String {
        return settingManager.settings[0]?.portName ?? ""
    }
    
    static func setPortName(_ portName: String) {
        settingManager.settings[0]?.portName = portName
        settingManager.save()
    }
    
    static func getPortSettings() -> String {
        return settingManager.settings[0]?.portSettings ?? ""
    }
    
    static func setPortSettings(_ portSettings: String) {
        settingManager.settings[0]?.portSettings = portSettings
        settingManager.save()
    }
    
    static func getModelName() -> String {
        return settingManager.settings[0]?.modelName ?? ""
    }
    
    static func setModelName(_ modelName: String) {
        settingManager.settings[0]?.modelName = modelName
        settingManager.save()
    }
    
    static func getMacAddress() -> String {
        return settingManager.settings[0]?.macAddress ?? ""
    }
    
    static func setMacAddress(_ macAddress: String) {
        settingManager.settings[0]?.macAddress = macAddress
        settingManager.save()
    }
    
    static func getEmulation() -> StarIoExtEmulation {
        return settingManager.settings[0]?.emulation ?? .starPRNT
    }
    
    static func setEmulation(_ emulation: StarIoExtEmulation) {
        settingManager.settings[0]?.emulation = emulation
        settingManager.save()
    }
    
    static func getCashDrawerOpenActiveHigh() -> Bool {
        return settingManager.settings[0]?.cashDrawerOpenActiveHigh ?? true
    }
    
    static func setCashDrawerOpenActiveHigh(_ activeHigh: Bool) {
        settingManager.settings[0]?.cashDrawerOpenActiveHigh = activeHigh
        settingManager.save()
    }
    
    static func getAllReceiptsSettings() -> Int {
        return settingManager.settings[0]?.allReceiptsSettings ?? 0x07
    }
    
    static func setAllReceiptsSettings(_ allReceiptsSettings: Int) {
        settingManager.settings[0]?.allReceiptsSettings = allReceiptsSettings
        settingManager.save()
    }
    
    static func getSelectedIndex() -> Int {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.selectedIndex!
    }
    
    static func setSelectedIndex(_ index: Int) {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.selectedIndex = index
    }
    
    static func getSelectedPaperSize() -> PaperSizeIndex {
        return AppDelegate.settingManager.settings[0]?.selectedPaperSize ?? .threeInch
    }
    
    static func setSelectedPaperSize(_ index: PaperSizeIndex) {
        AppDelegate.settingManager.settings[0]?.selectedPaperSize = index
        settingManager.save()
    }
    
    static func getSelectedModelIndex() -> ModelIndex? {
        return AppDelegate.settingManager.settings[0]?.selectedModelIndex
    }
    
    static func setSelectedModelIndex(_ modelIndex: ModelIndex?) {
        settingManager.settings[0]?.selectedModelIndex = modelIndex ?? .none
        settingManager.save()
    }


}




