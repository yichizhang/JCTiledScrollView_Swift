//
//  JCTiledScrollView.swift
//  JCTiledScrollView-Swift
//
//  Created by Yichi on 19/01/2015.
//  Copyright (c) 2015 Yichi Zhang. All rights reserved.
//

import Foundation

let kJCTiledScrollViewAnimationTime = NSTimeInterval(0.1)

extension JCTiledScrollView{
	var levelsOfZoom:UInt{
		set {
			t__levelsOfZoom = newValue
			
			self.scrollView.maximumZoomScale = pow( 2.0, max(0.0, CGFloat(levelsOfZoom)) )
		}
		get {
			return t__levelsOfZoom
		}
	}
	var levelsOfDetail:UInt{
		set {
			t__levelsOfDetail = newValue
			
			if levelsOfDetail == 1 {
				println("Note: Setting levelsOfDetail to 1 causes strange behaviour")
			}
			self.tiledView.numberOfZoomLevels = levelsOfDetail
		}
		get {
			return t__levelsOfDetail
		}
	}
	var zoomScale:CGFloat {
		set {
			self.setZoomScale(newValue, animated: false)
		}
		get {
			return scrollView.zoomScale
		}
	}
	var muteAnnotationUpdates:Bool {
		set {
			
			// FIXME: Jesse C - I don't like overloading this here, but the logic is in one place
			t__muteAnnotationUpdates = newValue
			
			self.userInteractionEnabled = !self.muteAnnotationUpdates
			if !self.muteAnnotationUpdates {
				self.correctScreenPositionOfAnnotations()
			}
		}
		get {
			return t__muteAnnotationUpdates
		}
	}
	
	// MARK: - Mute Annotation Updates
	func makeMuteAnnotationUpdatesTrueFor(time:NSTimeInterval){
		
		self.muteAnnotationUpdates = true
		
		let popTime = dispatch_time(
			DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)) )
		dispatch_after(popTime, dispatch_get_main_queue(), {
			self.muteAnnotationUpdates = false
		})
	}
	
	// MARK: Gesture Support
	
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
	} // end of singleTapReceived(gestureRecognizer:UITapGestureRecognizer)
	
	func t_doubleTapReceived(gestureRecognizer:UITapGestureRecognizer) {
		if self.zoomsInOnDoubleTap{
			
			let newZoom = self.scrollView.jc_zoomScaleByZoomingIn(1.0)
			
			self.makeMuteAnnotationUpdatesTrueFor(kJCTiledScrollViewAnimationTime)
			
			if self.zoomsToTouchLocation {
				let bounds = scrollView.bounds
				let pointInView = CGPointApplyAffineTransform(
					gestureRecognizer.locationInView(scrollView),
					CGAffineTransformMakeScale(1 / scrollView.zoomScale, 1 / scrollView.zoomScale)
				)
				let newSize = CGSizeApplyAffineTransform(
					bounds.size,
					CGAffineTransformMakeScale(1 / newZoom, 1 / newZoom)
				)
				
				scrollView.zoomToRect(CGRectMake(pointInView.x - (newSize.width / 2),
					pointInView.y - (newSize.height / 2), newSize.width, newSize.height), animated: true)
			} else {
				scrollView.setZoomScale(newZoom, animated: true)
			}
			// if self.zoomsToTouchLocation
			
		} // if self.zoomsInOnDoubleTap
		
		self.tiledScrollViewDelegate.tiledScrollView?(self, didReceiveDoubleTap: gestureRecognizer)
	} // end of doubleTapReceived(gestureRecognizer:UITapGestureRecognizer)
	
	func t_twoFingerTapReceived(gestureRecognizer:UITapGestureRecognizer) {
		if self.zoomsOutOnTwoFingerTap{
			
			let newZoom = self.scrollView.jc_zoomScaleByZoomingOut(1.0)
			
			self.makeMuteAnnotationUpdatesTrueFor(kJCTiledScrollViewAnimationTime)
			
			scrollView.setZoomScale(newZoom, animated: true)
		}
		
		self.tiledScrollViewDelegate.tiledScrollView?(self, didReceiveTwoFingerTap: gestureRecognizer)
	}
	
	func t_screenPositionForAnnotation(annotation: JCAnnotation) -> CGPoint{
		var position = CGPointZero
		position.x = (annotation.contentPosition.x * self.zoomScale) - scrollView.contentOffset.x
		position.y = (annotation.contentPosition.y * self.zoomScale) - scrollView.contentOffset.y
		return position
	}
	
	// MARK: JCTiledScrollView
	func setZoomScale(zoomScale:CGFloat, animated:Bool) {
		scrollView.setZoomScale(zoomScale, animated: animated)
	}
	
	func t_setContentCenter(center:CGPoint, animated:Bool) {
		scrollView.jc_setContentCenter(center, animated: animated)
	}
	
	// MARK: JCTileSource
	func t_tiledView(tiledView:JCTiledView, imageForRow row:Int, column:Int, scale:Int) -> UIImage{
		return self.dataSource.tiledScrollView(self, imageForRow: row, column: column, scale: scale)
	}
	
	// MARK: UIGestureRecognizerDelegate
	
	/** Catch our own tap gesture if it is on an annotation view to set annotation. Return NO to only recognize single tap on annotation
	*/
	func t_gestureRecognizerShouldBegin(gestureRecognizer:UIGestureRecognizer) -> Bool {
		
		let location = gestureRecognizer.locationInView(self.canvasView)

		(gestureRecognizer as? ADAnnotationTapGestureRecognizer)?.tapAnnotation = nil
		
		for obj in self.visibleAnnotations{
			let t = obj as JCVisibleAnnotationTuple
			if CGRectContainsPoint(t.view.frame, location){
				
				(gestureRecognizer as? ADAnnotationTapGestureRecognizer)?.tapAnnotation = t
				return true
			}
		}
		
		// Deal with all tap gesture
		return true
	}
	
	// MARK: Annotation Recycling
	
	func dequeueReusableAnnotationViewWithReuseIdentifier(reuseIdentifier:String) -> JCAnnotationView? {
		var viewToReturn:JCAnnotationView? = nil
		
		for obj in self.recycledAnnotationViews {
			let v = obj as JCAnnotationView
			if v.reuseIdentifier == reuseIdentifier {
				viewToReturn = v
				break
			}
		}
		
		if viewToReturn != nil{
			self.recycledAnnotationViews.removeObject(viewToReturn!)
			
		}
		
		return viewToReturn
	}
	
	// MARK: Annotations
	
	func point(point:CGPoint, isWithinBounds bounds:CGRect) -> Bool{
		return CGRectContainsPoint(CGRectInset(bounds, -25.0, -25.0), point)
	}
	
	func refreshAnnotations(){
		self.correctScreenPositionOfAnnotations()
		
		for obj in self.annotations{
			let annotation = obj as JCAnnotation
			
			let t = self.visibleAnnotations.visibleAnnotationTupleForAnnotation(annotation)
			
			t?.view.setNeedsLayout()
			t?.view.setNeedsDisplay()
		}
	}
	
	func addAnnotation(annotation:JCAnnotation){
		self.annotations.addObject(annotation)
		
		let screenPosition = self.screenPositionForAnnotation(annotation)
		
		if self.point(screenPosition, isWithinBounds: self.bounds) {
			
			let view = self.tiledScrollViewDelegate.tiledScrollView(self, viewForAnnotation: annotation)
			view.position = screenPosition
			
			let t = JCVisibleAnnotationTuple(annotation: annotation, view: view)
			self.visibleAnnotations.addObject(t)
			
			self.canvasView.addSubview(view)
		}
	}
	
	func addAnnotations(annotations:NSArray){
		for annotation in annotations {
			self.addAnnotation(annotation as JCAnnotation)
		}
	}
	
	func removeAnnotation(annotation:JCAnnotation){
		if self.annotations.containsObject(annotation) {
			
			if let t = self.visibleAnnotations.visibleAnnotationTupleForAnnotation(annotation) {
			
				t.view.removeFromSuperview()
				self.visibleAnnotations.removeObject(t)
			}
			
			self.annotations.removeObject(annotation)
		}
	}
	
	func removeAnnotations(annotations:NSArray){
		for annotation in annotations {
			self.removeAnnotation(annotation as JCAnnotation)
		}
	}
	
	func removeAllAnnotations(){
		self.removeAnnotations(self.annotations.allObjects)
	}
	
/*
	func t_(){
		
	}
*/
	
}
