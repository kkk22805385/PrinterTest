//
//  ClassModel.swift
//  PrinterTest
//
//  Created by aa on 2020/11/17.
//

import Foundation

//MARK:變數
let sm_true:  UInt32 = 1     // SM_TRUE
let sm_false: UInt32 = 0     // SM_FALSE


//MARK:方法
func MakePrettyFunction(_ filePath: String = #file, line: Int = #line, funcName: String = #function) -> String {
 let fileName: String = filePath.components(separatedBy: "/").last!
 
 return "-[\(fileName)(\(line)) \(funcName):]"
}

func showAlert(title: String, buttonTitles: [String], handler: ((Int) -> Void)?) -> UIAlertController {
    let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
    
    for i: Int in 0..<buttonTitles.count {
        alert.addAction(UIAlertAction(title: buttonTitles[i], style: .default, handler: { _ in
            DispatchQueue.main.async {
                handler?(i + 1)
            }
        }))
    }
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    return alert
}

//列印發票
func createTextReceiptData(_ emulation: StarIoExtEmulation, localizeReceipts: ILocalizeReceipts, utf8: Bool) -> Data {
    let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
    
    builder.beginDocument()
    
    localizeReceipts.appendTextReceiptData(builder, utf8: utf8)
    
    builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
    
    builder.endDocument()
    
    return builder.commands.copy() as! Data
}

//開收銀機
func createData(_ emulation: StarIoExtEmulation, channel: SCBPeripheralChannel) -> Data {
    let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
    
    builder.beginDocument()
    
    builder.appendPeripheral(channel)
    
    builder.endDocument()
    
    return builder.commands.copy() as! Data
}
//MARK:物件
@objcMembers class equipmentInfo : NSObject{
    var portName = ""
    var macAddress = ""
    var modelName = ""
}

class GlobalQueueManager {
    static let shared = GlobalQueueManager()
    
    var serialQueue = DispatchQueue(label: "jp.star-m.swiftsdk")
}

