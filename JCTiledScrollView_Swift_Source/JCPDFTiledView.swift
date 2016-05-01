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

@objc protocol JCPDFTiledViewDelegate
{
    func pdfPageForTiledView(tiledView: JCPDFTiledView!, rect: CGRect, pageNumber: UnsafeMutablePointer<Int>, pageSize: UnsafeMutablePointer<CGSize>) -> CGPDFPage?

    func pdfDocumentForTiledView(tiledView: JCPDFTiledView!) -> CGPDFDocument
}

class JCPDFTiledView: JCTiledView
{
    override func drawRect(rect: CGRect)
    {
        let ctx = UIGraphicsGetCurrentContext()

        UIColor.whiteColor().setFill()
        CGContextFillRect(ctx, CGContextGetClipBoundingBox(ctx))

        var pageNumber = Int(0)
        var pageSize = CGSizeZero

        guard let delegate = self.delegate as? JCPDFTiledViewDelegate else {
            return
        }
        guard let page: CGPDFPage = delegate.pdfPageForTiledView(self,
                                                                 rect: rect,
                                                                 pageNumber: &pageNumber,
                                                                 pageSize: &pageSize) else {
            return
        }
        CGContextTranslateCTM(ctx, 0.0, CGFloat(pageNumber) * pageSize.height)

        CGContextScaleCTM(ctx, 1.0, -1.0)
        CGContextSetRenderingIntent(ctx, CGColorRenderingIntent.RenderingIntentDefault)
        CGContextSetInterpolationQuality(ctx, CGInterpolationQuality.Default)

        CGContextDrawPDFPage(ctx, page)
    }
}
