//
//  JCPDFTiledView.swift
//  JCTiledScrollView-Swift
//
//  Created by Yichi on 13/01/2015.
//  Copyright (c) 2015 Yichi Zhang. All rights reserved.
//

import Foundation

@objc protocol JCPDFTiledViewDelegate{
	func pdfPageForTiledView(tiledView: JCPDFTiledView!) -> CGPDFPage?
	func pdfDocumentForTiledView(tiledView: JCPDFTiledView!) -> CGPDFDocument
}

class JCPDFTiledView : JCTiledView{
	
	override var tileSize:CGSize{
		return CGSizeMake(256, 256)
		//return CGSizeMake(kDefaultTileSize, kDefaultTileSize)
	}
	
	override func drawRect(rect: CGRect) {
		let ctx = UIGraphicsGetCurrentContext()
		
		UIColor.whiteColor().setFill()
		CGContextFillRect(ctx, CGContextGetClipBoundingBox(ctx))
		
		if let page:CGPDFPage = (self.delegate as JCPDFTiledViewDelegate).pdfPageForTiledView(self) {
			
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