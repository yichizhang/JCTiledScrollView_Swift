/*

 JCTiledScrollView_Swift

 Based on the code by:

 Jesse Collis (jessedc)
 Julius Oklamcak (vfr)
 Pete Hare (petehare)
 Anthony Damotte (adamotte)



 Copyright (c) 2015 Yichi Zhang
 https://github.com/yichizhang
 zhang-yi-chi@hotmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import UIKit
import QuartzCore

@objc protocol JCTiledViewDelegate
{

}

@objc protocol JCTiledBitmapViewDelegate: JCTiledViewDelegate
{
    func tiledView(tiledView: JCTiledView, imageForRow row: Int, column: Int, scale: Int) -> UIImage!
}

let kJCDefaultTileSize: CGFloat = 256.0

class JCTiledView: UIView
{
    weak var delegate: JCTiledViewDelegate?

    var tileSize: CGSize = CGSizeMake(kJCDefaultTileSize, kJCDefaultTileSize)
    {
        didSet
        {
            let scaledTileSize = CGSizeApplyAffineTransform(self.tileSize, CGAffineTransformMakeScale(self.contentScaleFactor, self.contentScaleFactor))
            self.tiledLayer().tileSize = scaledTileSize
        }
    }

    var shouldAnnotateRect: Bool = false

    var numberOfZoomLevels: size_t
    {
        get
        {
            return self.tiledLayer().levelsOfDetailBias
        }
        set
        {
            self.tiledLayer().levelsOfDetailBias = newValue
        }
    }

    func tiledLayer() -> JCTiledLayer
    {
        return self.layer as! JCTiledLayer
    }

    override class func layerClass() -> AnyClass
    {
        return JCTiledLayer.self
    }

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        let scaledTileSize = CGSizeApplyAffineTransform(self.tileSize, CGAffineTransformMakeScale(self.contentScaleFactor, self.contentScaleFactor))
        self.tiledLayer().tileSize = scaledTileSize
        self.tiledLayer().levelsOfDetail = 1
        self.numberOfZoomLevels = 3
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect)
    {
        let ctx = UIGraphicsGetCurrentContext()
        let scale = CGContextGetCTM(ctx).a / self.tiledLayer().contentsScale

        let col = Int(rect.minX * scale / self.tileSize.width)
        let row = Int(rect.minY * scale / self.tileSize.height)

        let tileImage = (self.delegate as! JCTiledBitmapViewDelegate).tiledView(self, imageForRow: row, column: col, scale: Int(scale))
        tileImage.drawInRect(rect)

        if (self.shouldAnnotateRect) {
            self.annotateRect(rect, inContext: ctx!)
        }
    }

    // Handy for Debug
    func annotateRect(rect: CGRect, inContext ctx: CGContextRef)
    {
        let scale = CGContextGetCTM(ctx).a / self.tiledLayer().contentsScale
        let lineWidth = 2.0 / scale
        let fontSize = 16.0 / scale

        UIColor.whiteColor().set()
        NSString.localizedStringWithFormat(" %0.0f", log2f(Float(scale))).drawAtPoint(
        CGPointMake(rect.minX, rect.minY),
        withAttributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(fontSize)]
        )

        UIColor.redColor().set()
        CGContextSetLineWidth(ctx, lineWidth)
        CGContextStrokeRect(ctx, rect)
    }
}

