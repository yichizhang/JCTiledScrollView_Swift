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
    func pdfPageForTiledView(_ tiledView: JCPDFTiledView!, rect: CGRect, pageNumber: UnsafeMutablePointer<Int>, pageSize: UnsafeMutablePointer<CGSize>) -> CGPDFPage?

    func pdfDocumentForTiledView(_ tiledView: JCPDFTiledView!) -> CGPDFDocument
}

class JCPDFTiledView: JCTiledView
{
    override func draw(_ rect: CGRect)
    {
        let ctx = UIGraphicsGetCurrentContext()

        UIColor.white.setFill()
        ctx?.fill((ctx?.boundingBoxOfClipPath)!)

        var pageNumber = Int(0)
        var pageSize = CGSize.zero

        guard let delegate = self.delegate as? JCPDFTiledViewDelegate else {
            return
        }
        guard let page: CGPDFPage = delegate.pdfPageForTiledView(self,
                                                                 rect: rect,
                                                                 pageNumber: &pageNumber,
                                                                 pageSize: &pageSize) else {
            return
        }
        ctx?.translateBy(x: 0.0, y: CGFloat(pageNumber) * pageSize.height)

        ctx?.scaleBy(x: 1.0, y: -1.0)
        ctx?.setRenderingIntent(CGColorRenderingIntent.defaultIntent)
        ctx!.interpolationQuality = CGInterpolationQuality.default

        ctx?.drawPDFPage(page)
    }
}
