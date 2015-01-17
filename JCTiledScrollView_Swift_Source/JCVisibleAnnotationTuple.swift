//
//  JCVisibleAnnotationTuple.swift
//  JCTiledScrollView-Swift
//
//  Created by Yichi on 17/01/2015.
//  Copyright (c) 2015 Yichi Zhang. All rights reserved.
//

import UIKit

class JCVisibleAnnotationTuple: NSObject {
	var annotation:JCAnnotation!
	var view:JCAnnotationView!
	
	class func instanceWithAnnotation(annotation:JCAnnotation, view:JCAnnotationView) -> JCVisibleAnnotationTuple{
		return JCVisibleAnnotationTuple(annotation: annotation, view: view)
	}
	
	convenience init(annotation:JCAnnotation, view:JCAnnotationView){
		self.init()
		self.annotation = annotation
		self.view = view
	}
}

extension NSSet {
	
	func visibleAnnotationTupleForAnnotation(annotation:JCAnnotation) -> JCVisibleAnnotationTuple? {
		for obj in self {
			if let t = obj as? JCVisibleAnnotationTuple {
				if t.annotation === annotation{
					return t
				}
			}
		}
		return nil;
	}
	
	func visibleAnnotationTupleForView(view:JCAnnotationView) -> JCVisibleAnnotationTuple? {
		for obj in self {
			if let t = obj as? JCVisibleAnnotationTuple {
				if t.view === view{
					return t
				}
			}
		}
		return nil;
	}
	
}