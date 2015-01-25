//
//  JCAnnotationTapGestureRecognizer.swift
//  JCTiledScrollView-Swift
//
//  Created by Yichi on 25/01/2015.
//  Copyright (c) 2015 Yichi Zhang. All rights reserved.
//

import UIKit

class JCAnnotationTapGestureRecognizer: UITapGestureRecognizer {
	var tapAnnotation:JCVisibleAnnotationTuple?
	
	override init(target: AnyObject, action: Selector) {
		super.init(target: target, action: action)
	}
}
