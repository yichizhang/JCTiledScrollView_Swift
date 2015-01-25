//
//  DemoAnnotationView.swift
//  Demo-Swift
//
//  Created by Yichi on 13/12/2014.
//  Copyright (c) 2014 Yichi Zhang. All rights reserved.
//

import UIKit

@objc class DemoAnnotationView: JCAnnotationView {
	
	var imageView:UIImageView!
	
	convenience init(frame: CGRect, annotation:JCAnnotation, reuseIdentifier:NSString) {
		
		self.init(frame: frame)
		
		self.annotation = annotation
		self.reuseIdentifier = reuseIdentifier
	
		imageView = UIImageView()
		addSubview(imageView)
		
	}
	
	override func sizeThatFits(size: CGSize) -> CGSize {
		return CGSizeMake(max(imageView.image!.size.width,30), max(imageView.image!.size.height,30));
	}
	
	override func layoutSubviews() {
		
		imageView.sizeToFit();
		imageView.frame = imageView.bounds
	}
	
}
