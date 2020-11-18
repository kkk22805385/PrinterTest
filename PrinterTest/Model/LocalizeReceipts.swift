//
//  LocalizeReceipts.swift
//  PrinterTest
//
//  Created by aa on 2020/11/18.
//

import Foundation

class LocalizeReceipts {
    static func createLocalizeReceipts(paperSizeIndex: PaperSizeIndex) -> ILocalizeReceipts {
        
        let localizeReceipts = ILocalizeReceipts()
    
        switch paperSizeIndex {
        case PaperSizeIndex.twoInch :
            localizeReceipts.paperSize = "2\""
            localizeReceipts.scalePaperSize = "3\""     // 3inch -> 2inch
        case PaperSizeIndex.threeInch,
             PaperSizeIndex.escPosThreeInch,
             PaperSizeIndex.dotImpactThreeInch :
            localizeReceipts.paperSize      = "3\""
            localizeReceipts.scalePaperSize = "4\""     // 4inch -> 3inch
//      case PaperSizeIndex.fourInch :
        default                      :
            localizeReceipts.paperSize      = "4\""
            localizeReceipts.scalePaperSize = "3\""     // 3inch -> 4inch
        }
        
        localizeReceipts.paperSizeIndex = paperSizeIndex
        
        return localizeReceipts
    }
    
}

class ILocalizeReceipts {
    fileprivate var paperSizeIndex: PaperSizeIndex!
    
    var languageCode:   String!
    var paperSize:      String!
    var scalePaperSize: String!
    var characterCode:  StarIoExtCharacterCode!
    
    func appendTextReceiptData(_ builder: ISCBBuilder, utf8: Bool) {
        switch self.paperSizeIndex! {
        case PaperSizeIndex.twoInch :
            self.append2inchTextReceiptData         (builder, utf8: utf8)
        case PaperSizeIndex.threeInch :
            self.append3inchTextReceiptData         (builder, utf8: utf8)
        case PaperSizeIndex.fourInch :
            self.append4inchTextReceiptData         (builder, utf8: utf8)
        case PaperSizeIndex.escPosThreeInch :
            self.appendEscPos3inchTextReceiptData   (builder, utf8: utf8)
//      case PaperSizeIndex.dotImpactThreeInch :
        default                                :
            self.appendDotImpact3inchTextReceiptData(builder, utf8: utf8)
        }
    }
    
    func createRasterReceiptImage() -> UIImage? {
        let image: UIImage?
        
        switch self.paperSizeIndex! {
        case PaperSizeIndex.twoInch :
            image = self.create2inchRasterReceiptImage()!
        case PaperSizeIndex.threeInch :
            image = self.create3inchRasterReceiptImage()!
        case PaperSizeIndex.fourInch :
            image = self.create4inchRasterReceiptImage()!
        case PaperSizeIndex.escPosThreeInch :
            image = self.createEscPos3inchRasterReceiptImage()!
//      case PaperSizeIndex.dotImpactThreeInch :
        default                                :
            image = nil
        }
        
        return image
    }
    
    func createScaleRasterReceiptImage() -> UIImage? {
        let image: UIImage?
        
        switch self.paperSizeIndex! {
        case PaperSizeIndex.twoInch :
            image = self.create3inchRasterReceiptImage()!      // 3inch -> 2inch
        case PaperSizeIndex.threeInch,
             PaperSizeIndex.escPosThreeInch :
            image = self.create4inchRasterReceiptImage()!      // 4inch -> 3inch
        case PaperSizeIndex.fourInch :
            image = self.create3inchRasterReceiptImage()!      // 3inch -> 4inch
//      case PaperSizeIndex.dotImpactThreeInch :
        default                                :
            image = nil
        }
        
        return image
    }
    
    func append2inchTextReceiptData(_ builder: ISCBBuilder, utf8: Bool) {     // abstract!!!
        let encoding: String.Encoding
        encoding = String.Encoding.utf8
        builder.append(SCBCodePageType.UTF8)
        
        builder.appendCharacterSpace(0) //間距
        
        builder.appendAlignment(SCBAlignmentPosition.center) //對齊方式
        
        builder.appendEmphasis(true)   //true:粗體 false:原本的樣子
        
        builder.appendData(withMultiple: "Star Micronics\n".data(using: encoding),width: 2, height: 8)
        
        builder.appendEmphasis(false)
        
        builder.append("--------------------------------\n".data(using: encoding))
        
        builder.appendData(withMultiple: (
            "電子發票證明聯\n" +
            "103年01-02月\n" +
            "EV-99999999\n").data(using: encoding), width: 2, height: 2)
        
        builder.appendAlignment(SCBAlignmentPosition.left)
        
        builder.append((
            "2014/01/15 13:00\n" +
            "隨機碼 : 9999    總計 : 999\n" +
            "賣方 : 99999999\n" +
            "\n").data(using: encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        
//      builder.appendQrCodeData("http://www.star-m.jp/eng/index.html".data(using: encoding),              model: SCBQrCodeModel.No2, level: SCBQrCodeLevel.Q, cell: 5)
        builder.appendQrCodeData("http://www.star-m.jp/eng/index.html".data(using: String.Encoding.ascii), model: SCBQrCodeModel.no2, level: SCBQrCodeLevel.Q, cell: 5)
        
    }
    
    func append3inchTextReceiptData(_ builder: ISCBBuilder, utf8: Bool) {     // abstract!!!
    }
    
    func append4inchTextReceiptData(_ builder: ISCBBuilder, utf8: Bool) {     // abstract!!!
    }
    
    func create2inchRasterReceiptImage() -> UIImage? {     // abstract!!!
        return nil
    }
    
    func create3inchRasterReceiptImage() -> UIImage? {     // abstract!!!
        return nil
    }
    
    func create4inchRasterReceiptImage() -> UIImage? {     // abstract!!!
        return nil
    }
    
    func createCouponImage() -> UIImage? {     // abstract!!!
        return nil
    }
    
    func createEscPos3inchRasterReceiptImage() -> UIImage? {     // abstract!!!
        return nil
    }
    
    func appendEscPos3inchTextReceiptData(_ builder: ISCBBuilder, utf8: Bool) {     // abstract!!!
    }
    
    func appendDotImpact3inchTextReceiptData(_ builder: ISCBBuilder, utf8: Bool) {     // abstract!!!
    }
    
    func appendTextLabelData(_ builder: ISCBBuilder, utf8: Bool) {     // abstract!!!
    }
    
    func createPasteTextLabelString() -> String? {     // abstract!!!
        return nil
    }
    
    func appendPasteTextLabelData(_ builder: ISCBBuilder, pasteText: String, utf8: Bool) {     // abstract!!!
    }
    
    static func imageWithString(_ string: String, font: UIFont, width: CGFloat) -> UIImage {
        let attributeDic: NSDictionary = NSDictionary(dictionary: [NSAttributedString.Key.font : font])
        
        let stringDrawingOptions: NSStringDrawingOptions = [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.truncatesLastVisibleLine]
        
        let size: CGSize = (string.boundingRect(with: CGSize(width: width, height: 10000), options: stringDrawingOptions, attributes: attributeDic as? [NSAttributedString.Key : Any], context: nil)).size
        
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) {
            if UIScreen.main.scale == 2.0 {
                UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
            } else {
                UIGraphicsBeginImageContext(size)
            }
        } else {
            UIGraphicsBeginImageContext(size)
        }
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        UIColor.white.set()
        
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width + 1, height: size.height + 1)
        
        context.fill(rect)
        
        let attributes: NSDictionary = NSDictionary(dictionary: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : font])
        
        string.draw(in: rect, withAttributes: attributes as? [NSAttributedString.Key : Any])
        
        let imageToPrint: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return imageToPrint
    }
}
