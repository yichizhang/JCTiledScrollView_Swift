//
//  UIScrollView+JCTiledScrollView.swift
//  JCTiledScrollView-Swift
//
//  Created by Yichi on 23/01/2015.
//  Copyright (c) 2015 Yichi Zhang. All rights reserved.
//

import Foundation

extension UIScrollView {
	
	func jc_zoomScaleByZoomingIn(numberOfLevels:CGFloat) -> CGFloat {
		
		let newZoom = CGFloat(
			min(
				powf( 2, Float( log2(self.zoomScale) + numberOfLevels ) ),
				Float( self.maximumZoomScale )
			)
		)
		return newZoom
	}
	
	func jc_zoomScaleByZoomingOut(numberOfLevels:CGFloat) -> CGFloat {
		
		let newZoom = CGFloat(
			max(
				powf( 2, Float( log2(self.zoomScale) - numberOfLevels ) ),
				Float( self.minimumZoomScale )
			)
		)
		return newZoom
	}
}