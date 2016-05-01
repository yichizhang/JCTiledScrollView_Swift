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

    public class func drawString(string: String)
    {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// Text Drawing
        let textRect = CGRectMake(0, 0, 25, 25)
        let textTextContent = NSString(string: string)
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.Center

        let textFontAttributes = [NSFontAttributeName: DemoStyleKit.mainFont, NSForegroundColorAttributeName: UIColor.blackColor(), NSParagraphStyleAttributeName: textStyle]

        let textTextHeight: CGFloat = textTextContent.boundingRectWithSize(CGSizeMake(textRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, textRect)
        textTextContent.drawInRect(CGRectMake(textRect.minX, textRect.minY + (textRect.height - textTextHeight) / 2, textRect.width, textTextHeight), withAttributes: textFontAttributes)
        CGContextRestoreGState(context)
    }

    //// Generated Images

    public class func imageOfString(string: String) -> UIImage
    {
        if let image = Cache.imageDict[string] {
            return image
        }

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(25, 25), false, 0)
        DemoStyleKit.drawString(string)

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        Cache.imageDict[string] = image

        return image
    }
}