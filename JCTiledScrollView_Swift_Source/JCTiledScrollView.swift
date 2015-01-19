//
//  JCTiledScrollView.swift
//  campusmap-swift
//
//  Created by Yichi on 19/01/2015.
//  Copyright (c) 2015 Yichi Zhang. All rights reserved.
//

import Foundation

extension JCTiledScrollView{
	
	
	func t_viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return self.tiledView
	}
	
	func t_scrollViewDidZoom(scrollView: UIScrollView) {
		self.tiledScrollViewDelegate.tiledScrollViewDidZoom?(self)
	}
	
	func t_scrollViewDidScroll(scrollView: UIScrollView) {
		self.correctScreenPositionOfAnnotations()
		
		self.tiledScrollViewDelegate.tiledScrollViewDidScroll?(self)
	}
	
	func t_singleTapReceived(gestureRecognizer:UITapGestureRecognizer) {
		
		if gestureRecognizer.isKindOfClass(ADAnnotationTapGestureRecognizer.self) {
			
			let annotationGestureRecognizer = gestureRecognizer as ADAnnotationTapGestureRecognizer
			
			previousSelectedAnnotationTuple = currentSelectedAnnotationTuple
			currentSelectedAnnotationTuple = annotationGestureRecognizer.tapAnnotation
			
			if nil == annotationGestureRecognizer.tapAnnotation {
				
				if previousSelectedAnnotationTuple != nil {
					self.tiledScrollViewDelegate.tiledScrollView?(self, didDeselectAnnotationView: previousSelectedAnnotationTuple.view!)
				} else if self.centerSingleTap {
					self.setContentCenter(gestureRecognizer.locationInView(self.tiledView), animated: true)
				}
				
				self.tiledScrollViewDelegate.tiledScrollView?(self, didReceiveSingleTap: gestureRecognizer)
			} else {
				if previousSelectedAnnotationTuple != nil {
					var oldSelectedAnnotationView = previousSelectedAnnotationTuple.view
					
					if oldSelectedAnnotationView == nil {
						oldSelectedAnnotationView = self.tiledScrollViewDelegate.tiledScrollView(self, viewForAnnotation: previousSelectedAnnotationTuple.annotation)
					}
					self.tiledScrollViewDelegate.tiledScrollView?(self, didDeselectAnnotationView: oldSelectedAnnotationView)
				}
				if currentSelectedAnnotationTuple != nil {
					var currentSelectedAnnotationView = annotationGestureRecognizer.tapAnnotation.view
					self.tiledScrollViewDelegate.tiledScrollView?(self, didSelectAnnotationView: currentSelectedAnnotationView)
				}
			} // if nil == annotationGestureRecognizer.tapAnnotation
		} //  if gestureRecognizer.isKindOfClass(ADAnnotationTapGestureRecognizer.self)
	} // end of fuction
	
}
