//
//  JCTiledView.swift
//  JCTiledScrollView-Swift
//
//  Created by Yichi on 8/01/2015.
//  Copyright (c) 2015 Yichi Zhang. All rights reserved.
//

import UIKit
import QuartzCore

@objc protocol JCTiledViewDelegate {
	
}

@objc protocol JCTiledBitmapViewDelegate: JCTiledViewDelegate {
	func tiledView(tiledView:JCTiledView, imageForRow row:Int, column:Int, scale:Int) -> UIImage
	func fuckYou()
}

class JCTiledView: UIView {
	
	var delegate:JCTiledViewDelegate?
	private(set) var tileSize:CGSize = CGSizeZero
	var shouldAnnotateRect:Bool = false
	
	var numberOfZoomLevels:size_t {
		get{
			return self.tiledLayer.levelsOfDetailBias
		}
		set{
			self.tiledLayer.levelsOfDetailBias = newValue
		}
	}
	var tiledLayer:JCTiledLayer{
		return self.layer as JCTiledLayer
	}
	
	let kDefaultTileSize:CGFloat = 256.0
	
	override class func layerClass() -> AnyClass{
		return JCTiledLayer.self
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		let scaledTileSize = CGSizeApplyAffineTransform(self.tileSize, CGAffineTransformMakeScale(self.contentScaleFactor, self.contentScaleFactor))
		self.tiledLayer.tileSize = scaledTileSize
		self.tiledLayer.levelsOfDetail = 1
		self.numberOfZoomLevels = 3
		self.shouldAnnotateRect = false
		self.tileSize = CGSizeMake(kDefaultTileSize, kDefaultTileSize)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func drawRect(rect: CGRect) {
		let ctx = UIGraphicsGetCurrentContext()
		let scale = CGContextGetCTM(ctx).a / self.tiledLayer.contentsScale
		
		let col = Int( CGRectGetMinX(rect) * scale / self.tileSize.width )
		let row = Int( CGRectGetMinY(rect) * scale / self.tileSize.height )
		
		let tileImage = (self.delegate as JCTiledBitmapViewDelegate).tiledView(self, imageForRow:row, column:col, scale:Int(scale) )
		tileImage.drawInRect(rect)
		
	}
	
	// Handy for Debug
	func annotateRect(rect:CGRect, inContext ctx:CGContextRef){
		
		let scale = CGContextGetCTM(ctx).a / self.tiledLayer.contentsScale
		let lineWidth = 2.0 / scale
		let fontSize = 16.0 / scale
		
		UIColor.whiteColor().set()
		NSString.localizedStringWithFormat(" %0.0f", log2f( Float(scale) )).drawAtPoint(
			CGPointMake(rect.minX, rect.minY),
			withAttributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(fontSize)]
		)
		
		UIColor.redColor().set()
		CGContextSetLineWidth(ctx, lineWidth)
		CGContextStrokeRect(ctx, rect)
		
	}
}
