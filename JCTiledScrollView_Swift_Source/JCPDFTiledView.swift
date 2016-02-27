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

@objc protocol JCPDFTiledViewDelegate
{
	func pdfPageForTiledView(tiledView: JCPDFTiledView!) -> CGPDFPage?

	func pdfDocumentForTiledView(tiledView: JCPDFTiledView!) -> CGPDFDocument
}

class JCPDFTiledView: JCTiledView
{

	override var tileSize: CGSize
	{
		return CGSizeMake(256, 256)
		//return CGSizeMake(kDefaultTileSize, kDefaultTileSize)
	}

	override func drawRect(rect: CGRect)
	{
		let ctx = UIGraphicsGetCurrentContext()

		UIColor.whiteColor().setFill()
		CGContextFillRect(ctx, CGContextGetClipBoundingBox(ctx))

		if let page: CGPDFPage = (self.delegate as! JCPDFTiledViewDelegate).pdfPageForTiledView(self) {

			CGContextTranslateCTM(ctx, 0.0, self.bounds.size.height)
			CGContextScaleCTM(ctx, 1.0, -1.0)
			CGContextConcatCTM(
			ctx,
			CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, self.bounds, 0, true)
			)

			CGContextSetRenderingIntent(ctx, kCGRenderingIntentDefault)
			CGContextSetInterpolationQuality(ctx, kCGInterpolationDefault)

			CGContextDrawPDFPage(ctx, page)

		}

	}
}
