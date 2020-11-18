//
//  SearchPortViewController.swift
//  PrinterTest
//
//  Created by aa on 2020/11/16.
//

import UIKit

class SearchPortViewController: UIViewController {
    enum CellParamIndex: Int {
        case portName = 0
        case modelName
        case macAddress
    }
    
    var ConnMethod = ""
   
    var portInfos = [equipmentInfo]()
    
    var currentSetting: PrinterSetting? = nil
    
    var selectedIndexPath: IndexPath!
    
    var portName:     String!
    var portSettings: String!
    var modelName:    String!
    var macAddress:   String!
    var paperSizeIndex: PaperSizeIndex? = nil
    
    var emulation: StarIoExtEmulation!
    
    var selectedModelIndex: ModelIndex?
    
    var selectedPrinterIndex: Int = 0
    
    
    @IBOutlet var LinkTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LinkTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let view = UIView()
        LinkTableView.tableFooterView = view
        
    }
    override func viewDidAppear(_ animated: Bool) {
        searchPort()
    }
    func searchPort(){
        var searchPrinterResult: [PortInfo]? = nil
        var type = ""
                
        switch ConnMethod {
            case "LAN"  :     // LAN
                type = "TCP:"
            case "Bluetooth"  :     // Bluetooth
                type = "BT:"
            case "Bluetooth Low Energy"  :     // Bluetooth Low Energy
                type = "BLE:"
            case "USB"  :     // USB
                type = "USB::"
            case "All"  :     // All
                type = "ALL:"
            default :
                break
            }
        
        do{
            searchPrinterResult = try SMPort.searchPrinter(target: type) as? [PortInfo]
        }catch{
            print(error)
        }
        
        
        if searchPrinterResult?.count == 0 {
            self.LinkTableView.reloadData()
            return
        }
        
        
        for portInfo: PortInfo in searchPrinterResult! {
            let equ = equipmentInfo()
            equ.portName = portInfo.portName
            equ.modelName = portInfo.modelName
            
            portInfos.append(equ)
        }
        
        self.LinkTableView.reloadData()
    }
    func didConfirmModel(_ equ:equipmentInfo) {
        self.portName   = equ.portName
        self.modelName  = equ.modelName
        self.macAddress = equ.macAddress
        
        guard let modelIndex = ModelCapability.modelIndex(of: self.modelName) else {
            fatalError()
        }
        
        self.portSettings = ModelCapability.portSettings(at: modelIndex)
        self.emulation = ModelCapability.emulation(at: modelIndex)
        self.selectedModelIndex = modelIndex
        
        if (selectedPrinterIndex != 0) {
            self.paperSizeIndex = AppDelegate.settingManager.settings[0]?.selectedPaperSize
        }
        
        if self.paperSizeIndex == nil {
            
            let alert = showAlert(title: "Select paper size.",
                           buttonTitles: ["2\" (384dots)", "3\" (576dots)", "4\" (832dots)"],
                           handler: { selectedButtonIndex in
                            self.didSelectPaperSize(buttonIndex: selectedButtonIndex)
                           // self.didSelectPaperSize(buttonIndex: selectedButtonIndex)
            })
            present(alert, animated: true, completion: nil)
        }
    }
    fileprivate func didSelectPaperSize(buttonIndex: Int) {
        switch buttonIndex {
        case 1:
            self.paperSizeIndex = .twoInch
        case 2:
            self.paperSizeIndex = .threeInch
        case 3:
            self.paperSizeIndex = .fourInch
        default:
            fatalError()
        }
        
        guard let modelIndex = self.selectedModelIndex else {
            fatalError()
        }
        
        if ModelCapability.supportedExternalCashDrawer(at: modelIndex) == true {
            let alert = showAlert(title: "Select CashDrawer Open Status.",
                           buttonTitles: ["High when Open", "Low when Open"],
                           handler: { selectedButtonIndex in
                            self.didSelectCashDrawerOpenActiveHigh(buttonIndex: selectedButtonIndex)
            })
            present(alert, animated: true, completion: nil)
        }
        else {
            self.saveParams(portName: self.portName,
                            portSettings: self.portSettings,
                            modelName: self.modelName,
                            macAddress: self.macAddress,
                            emulation: self.emulation,
                            isCashDrawerOpenActiveHigh: true,
                            modelIndex: self.selectedModelIndex,
                            paperSizeIndex: self.paperSizeIndex)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    fileprivate func didSelectCashDrawerOpenActiveHigh(buttonIndex: Int) {
        let isCashDrawerOpenActiveHigh: Bool
        
        if buttonIndex == 1 {     // High when Open
            isCashDrawerOpenActiveHigh = true
        }
        else if buttonIndex == 2 {     // Low when Open
            isCashDrawerOpenActiveHigh = false
        } else {
            fatalError()
        }
        
        self.saveParams(portName: self.portName,
                        portSettings: self.portSettings,
                        modelName: self.modelName,
                        macAddress: self.macAddress,
                        emulation: self.emulation,
                        isCashDrawerOpenActiveHigh: isCashDrawerOpenActiveHigh,
                        modelIndex: self.selectedModelIndex,
                        paperSizeIndex: self.paperSizeIndex)
        
        self.navigationController!.popViewController(animated: true)
    }
    
    fileprivate func saveParams(portName: String,
                                portSettings: String,
                                modelName: String,
                                macAddress: String,
                                emulation: StarIoExtEmulation,
                                isCashDrawerOpenActiveHigh: Bool,
                                modelIndex: ModelIndex?,
                                paperSizeIndex: PaperSizeIndex?) {
        if let modelIndex = modelIndex,let paperSizeIndex = paperSizeIndex {
            let allReceiptsSetting = AppDelegate.settingManager.settings[selectedPrinterIndex]?.allReceiptsSettings ?? 0x07
            
            
            AppDelegate.settingManager.settings[selectedPrinterIndex] = PrinterSetting(portName: portName,
                                                                                       portSettings: portSettings,
                                                                                       macAddress: macAddress,
                                                                                       modelName: modelName,
                                                                                       emulation: emulation,
                                                                                       cashDrawerOpenActiveHigh: isCashDrawerOpenActiveHigh,
                                                                                       allReceiptsSettings: allReceiptsSetting,
                                                                                       selectedPaperSize: paperSizeIndex,
                                                                                       selectedModelIndex: modelIndex)
            
            AppDelegate.settingManager.save()
        } else {
            fatalError()
        }
    }
}
extension SearchPortViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return portInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        
        cell.textLabel!.text = portInfos[indexPath.row].portName
        
        
        
        cell.textLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
                
        cell.accessoryType = UITableViewCell.AccessoryType.none
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didConfirmModel(portInfos[indexPath.row])
    }
    
}
