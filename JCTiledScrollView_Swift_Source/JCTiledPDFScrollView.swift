//
//  JCAnnotationView.swift
//  JCTiledScrollView-Swift
//
//  Created by Yichi on 12/01/2015.
//  Copyright (c) 2015 Yichi Zhang. All rights reserved.
//

import UIKit

class JCTiledPDFScrollView: JCTiledScrollView, JCPDFTiledViewDelegate {

	private var document:CGPDFDocument!
	private var currentPage:CGPDFPage!
	
	override class func tiledLayerClass() -> AnyClass{
		return JCPDFTiledView.self
	}
	
	init(frame: CGRect, URL url: NSURL) {
		
		var contentSize = CGSizeZero
	
		if let tempDocument = JCPDFDocument.createX(url, password: "") {

			self.document = tempDocument
			
			if let tempPage = CGPDFDocumentGetPage(self.document, 1) {
				
				self.currentPage = tempPage
				
				let cropBoxRect = CGPDFPageGetBoxRect(currentPage, kCGPDFCropBox);
				let mediaBoxRect = CGPDFPageGetBoxRect(currentPage, kCGPDFMediaBox);
				let effectiveRect = CGRectIntersection(cropBoxRect, mediaBoxRect);
				
				contentSize = effectiveRect.size
			}else {
				fatalError("Page is null")
			}
			
		}else{
			fatalError("Document is null")
		}
		
		
		super.init(frame: frame, contentSize: contentSize)
		
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func pdfPageForTiledView(tiledView: JCPDFTiledView!) -> CGPDFPage? {
		return currentPage
	}
	
	func pdfDocumentForTiledView(tiledView: JCPDFTiledView!) -> CGPDFDocument {
		return document
	}
}
