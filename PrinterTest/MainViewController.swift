//
//  MainViewController.swift
//  PrinterTest
//
//  Created by aa on 2020/11/16.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet var textLink: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let text = AppDelegate.settingManager.settings[0]?.portName{
            textLink.text = text
        }
    }

    @IBAction func btnLink(_ sender: Any) {
        let alert = UIAlertController(title: "Select Interface.",
                                      message: nil,
                                      preferredStyle: .alert)
        let buttonTitles = ["LAN", "Bluetooth", "Bluetooth Low Energy", "USB", "All","Manual"]
        for i in 0..<buttonTitles.count {
            alert.addAction(UIAlertAction(title: buttonTitles[i], style: .default, handler: { _ in
                let vc = SearchPortViewController(nibName: "SearchPortViewController", bundle: nil)
                vc.modalPresentationStyle = .formSheet
                vc.ConnMethod = buttonTitles[i]
                self.present(vc, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnPrint(_ sender: Any) {
        doPrint()
    }
    @IBAction func btnCashDrawer(_ sender: Any) {
        let commands = createData(AppDelegate.getEmulation(), channel: SCBPeripheralChannel.no1)
        
        let portName:     String = AppDelegate.getPortName()
        let portSettings: String = AppDelegate.getPortSettings()
        let timeout:      UInt32 = 10000                             // 10000mS!!!
        
        GlobalQueueManager.shared.serialQueue.async {
            _ = Communication.sendCommandsDoNotCheckCondition(commands,
                                                              portName: portName,
                                                              portSettings: portSettings,
                                                              timeout: timeout,
                                                              completionHandler: { (communicationResult: CommunicationResult) in
                                                                DispatchQueue.main.async {
                                                                    self.showSimpleAlert(title: "Communication Result",
                                                                                         message: Communication.getCommunicationResultMessage(communicationResult),
                                                                                         buttonTitle: "OK",
                                                                                         buttonStyle: .cancel)
                                                                    
                                                                }
                                                                
            })
        }
    }
    
    func doPrint(){
        
        let emulation: StarIoExtEmulation = AppDelegate.getEmulation()
        
        let width: Int = AppDelegate.getSelectedPaperSize().rawValue
        
        let localizeReceipts: ILocalizeReceipts = LocalizeReceipts.createLocalizeReceipts( paperSizeIndex: AppDelegate.getSelectedPaperSize())
        
        let commands = createTextReceiptData(emulation, localizeReceipts: localizeReceipts, utf8: false)
        
        let portName: String = AppDelegate.getPortName()
        let portSettings: String = AppDelegate.getPortSettings()
        GlobalQueueManager.shared.serialQueue.async {
            _ = Communication.sendCommands(commands,
                                           portName: portName,
                                           portSettings: portSettings,
                                           timeout: 10000,  // 10000mS!!!
                                           completionHandler: { (communicationResult: CommunicationResult) in
                                            DispatchQueue.main.async {
                                                self.showSimpleAlert(title: "Communication Result",
                                                                     message: Communication.getCommunicationResultMessage(communicationResult),
                                                                     buttonTitle: "OK",
                                                                     buttonStyle: .cancel)

                                            }
            })
        }
    }
    
    func showSimpleAlert(title: String?,
                         message: String?,
                         buttonTitle: String?,
                         buttonStyle: UIAlertAction.Style,
                         completion: ((UIAlertController) -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonTitle, style: buttonStyle, handler: nil)
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.async {
            completion?(alertController)
        }
    }
}
