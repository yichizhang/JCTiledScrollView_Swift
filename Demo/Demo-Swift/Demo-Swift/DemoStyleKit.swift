//
//  Copyright (c) 2015-present Yichi Zhang
//  https://github.com/yichizhang
//  zhang-yi-chi@hotmail.com
//
//  This source code is licensed under MIT license found in the LICENSE file
//  in the root directory of this source tree.
//  Attribution can be found in the ATTRIBUTION file in the root directory 
//  of this source tree.
//

import UIKit

public class DemoStyleKit: NSObject
{
    class var mainFont: UIFont
    {
        return UIFont(name: "HelveticaNeue-Bold", size: 14)!
    }

    //// Cache

    private struct Cache
    {
        static var imageDict: [String:UIImage] = Dictionary()
        //        static var oneTargets: [AnyObject]?
    }

    //// Drawing Methods

    public class func draw(string: String)
    {
        //// General Declarations
        guard let context = UIGraphicsGetCurrentContext() else { return }

        //// Text Drawing
        let textRect = CGRect(x: 0, y: 0, width: 25, height: 25)
        let textTextContent = NSString(string: string)
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.center

        let textFontAttributes = [NSAttributedStringKey.font: DemoStyleKit.mainFont, NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.paragraphStyle: textStyle]

        let textTextHeight: CGFloat = textTextContent.boundingRect(with: CGSize(width: textRect.width, height: CGFloat.infinity), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size.height
        context.saveGState()
      
        context.clip(to: textRect)
        textTextContent.draw(in: CGRect(x: textRect.minX, y: textRect.minY + (textRect.height - textTextHeight) / 2, width: textRect.width, height: textTextHeight), withAttributes: textFontAttributes)
        context.restoreGState()
    }

    //// Generated Images

    public class func image(string: String) -> UIImage
    {
        if let image = Cache.imageDict[string] {
            return image
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 25, height: 25), false, 0)
        DemoStyleKit.draw(string: string)

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        Cache.imageDict[string] = image

        return image
    }
}
