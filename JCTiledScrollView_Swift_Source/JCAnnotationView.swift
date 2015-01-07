//
//  JCAnnotationView.swift
//  JCTiledScrollView-Swift
//
//  Created by Yichi on 7/01/2015.
//  Copyright (c) 2015 Yichi Zhang. All rights reserved.
//

import UIKit

@objc class JCAnnotationView: UIView {
	
	private var _position:CGPoint = CGPointZero
	private var _centerOffset:CGPoint = CGPointZero
	
	var annotation:JCAnnotation?
	var reuseIdentifier:NSString = ""
	var position:CGPoint {
		get {
			return _position
		}
		set {
			if ( !CGPointEqualToPoint(_position, newValue) ){
				_position = newValue
				adjustCenter()
			}
		}
	}
	var centerOffset:CGPoint {
		get {
			return _centerOffset
		}
		set {
			if ( !CGPointEqualToPoint(_centerOffset, newValue) ){
				_centerOffset = newValue
				adjustCenter()
			}
		}
	}
	
	convenience init(frame: CGRect, annotation:JCAnnotation, reuseIdentifier:NSString) {
		
		self.init(frame: frame)
		
		self.annotation = annotation
		self.reuseIdentifier = reuseIdentifier
	}
	
	private func adjustCenter(){
		center = CGPointMake(position.x + centerOffset.x, position.y + centerOffset.y)
	}
}
