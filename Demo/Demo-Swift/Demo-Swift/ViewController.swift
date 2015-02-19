//
//  ViewController.swift
//  Demo-Swift
//
//  Created by Yichi on 13/12/2014.
//  Copyright (c) 2014 Yichi Zhang. All rights reserved.
//

import UIKit

enum JCDemoType {
	case PDF
	case Image
}

let annotationReuseIdentifier = "JCAnnotationReuseIdentifier";
let SkippingGirlImageName = "SkippingGirl"
let SkippingGirlImageSize = CGSizeMake(432, 648)

let ButtonTitleCancel = "Cancel"
let ButtonTitleRemoveAnnotation = "Remove this Annotation"

@objc class ViewController: UIViewController, JCTiledScrollViewDelegate, JCTileSource, UIAlertViewDelegate {

	var scrollView: JCTiledScrollView!
	var infoLabel: UILabel!
	var searchField: UITextField!
	var mode: JCDemoType!
	
	weak var selectedAnnotation:JCAnnotation?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		if(mode == JCDemoType.PDF){
			scrollView = JCTiledPDFScrollView(frame: self.view.bounds, URL: NSBundle.mainBundle().URLForResource("Map", withExtension: "pdf")! )
		}else{
			scrollView = JCTiledScrollView(frame: self.view.bounds, contentSize: SkippingGirlImageSize);
		}
		scrollView.tiledScrollViewDelegate = self
		scrollView.zoomScale = 1.0
		
		scrollView.dataSource = self;
		scrollView.tiledScrollViewDelegate = self;
				
		scrollView.tiledView.shouldAnnotateRect = true;
		 
		// totals 4 sets of tiles across all devices, retina devices will miss out on the first 1x set
		scrollView.levelsOfZoom = 3;
		scrollView.levelsOfDetail = 3;
		view.addSubview(scrollView)
		
		let paddingX:CGFloat = 20;
		let paddingY:CGFloat = 30;
		infoLabel = UILabel(frame: CGRectMake(paddingX, paddingY, self.view.bounds.size.width - 2*paddingX, 30));
		infoLabel.backgroundColor = UIColor.blackColor()
		infoLabel.textColor = UIColor.whiteColor()
		infoLabel.textAlignment = NSTextAlignment.Center
		view.addSubview(infoLabel)
		
		addRandomAnnotations()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func addRandomAnnotations() {
		for index in 0...4 {
			var a:JCAnnotation = DemoAnnotation();
			a.contentPosition = CGPointMake(
				//This is ridiculous!! Hahaha
				CGFloat(UInt(arc4random_uniform(UInt32(UInt(scrollView.tiledView.bounds.width))))),
				CGFloat(UInt(arc4random_uniform(UInt32(UInt(scrollView.tiledView.bounds.height)))))
			);
			scrollView.addAnnotation(a);
		}
	}
	
	// MARK: JCTiledScrollView Delegate
	func tiledScrollViewDidZoom(scrollView: JCTiledScrollView) {
		
		let infoString = "zoomScale=\(scrollView.zoomScale)"
		
		infoLabel.text = infoString
	}
	
	func tiledScrollView(scrollView: JCTiledScrollView, didReceiveSingleTap gestureRecognizer: UIGestureRecognizer) {
		
		var tapPoint:CGPoint = gestureRecognizer.locationInView(scrollView.tiledView)
		
		let infoString = "(\(tapPoint.x), \(tapPoint.y)), zoomScale=\(scrollView.zoomScale)"
		
		infoLabel.text = infoString
	}
	
	func tiledScrollView(scrollView: JCTiledScrollView, didSelectAnnotationView view: JCAnnotationView) {
		
		if view.annotation != nil {
			
			let av = UIAlertView(title: "Annotation Selected", message: "You've selected an annotation. What would you like to do with it?", delegate: self, cancelButtonTitle: ButtonTitleCancel, otherButtonTitles: ButtonTitleRemoveAnnotation )
			av.show()
			selectedAnnotation = view.annotation
		}
	}
	
	func tiledScrollView(scrollView: JCTiledScrollView!, viewForAnnotation annotation: JCAnnotation!) -> JCAnnotationView! {
		
		var view:DemoAnnotationView? = scrollView.dequeueReusableAnnotationViewWithReuseIdentifier(annotationReuseIdentifier) as? DemoAnnotationView;
		
		if ( (view) == nil )
		{
			view = DemoAnnotationView(frame:CGRectZero, annotation:annotation, reuseIdentifier:"Identifier");
			view!.imageView.image = UIImage(named: "marker-red.png");
			view!.sizeToFit();
		}
		
		return view;
	}
	
	func tiledScrollView(scrollView: JCTiledScrollView, imageForRow row: Int, column: Int, scale: Int) -> UIImage! {
		
		let fileName = NSString(format: "%@_%dx_%d_%d.png", SkippingGirlImageName, scale, row, column) as! String
		return UIImage(named: fileName)
		
	}
	
	// MARK: UIAlertView Delegate
	func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
		
		switch alertView.buttonTitleAtIndex(buttonIndex){
		case ButtonTitleCancel:
			break
		case ButtonTitleRemoveAnnotation:
			scrollView.removeAnnotation(self.selectedAnnotation)
		default:
			break
		}
		
	}
}

