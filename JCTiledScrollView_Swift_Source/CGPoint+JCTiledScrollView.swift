//
//  CGPoint+JCTiledScrollView.swift
//  JCTiledScrollView-Swift
//
//  Created by Yichi on 25/01/2015.
//  Copyright (c) 2015 Yichi Zhang. All rights reserved.

import UIKit

extension CGPoint{
	
	func jc_isWithinBounds(bounds:CGRect) -> Bool{
		return CGRectContainsPoint(CGRectInset(bounds, -25.0, -25.0), self)
	}
	
}