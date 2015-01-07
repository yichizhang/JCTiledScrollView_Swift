//
//  JCAnnotation.swift
//  JCTiledScrollView-Swift
//
//  Created by Yichi on 7/01/2015.
//  Copyright (c) 2015 Yichi Zhang. All rights reserved.
//

import UIKit

@objc protocol JCAnnotation : NSObjectProtocol {
	
	var contentPosition:CGPoint {get set}
	
}