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

