/*

 JCTiledScrollView_Swift

 Based on the code by:

 Jesse Collis (jessedc)
 Julius Oklamcak (vfr)
 Pete Hare (petehare)
 Anthony Damotte (adamotte)



 Copyright (c) 2015 Yichi Zhang
 https://github.com/yichizhang
 zhang-yi-chi@hotmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */
import UIKit

class JCTiledPDFScrollView: JCTiledScrollView, JCPDFTiledViewDelegate {

	private var document:CGPDFDocument!
	private var currentPage:CGPDFPage!
	
	override class func tiledLayerClass() -> AnyClass{
		return JCPDFTiledView.self
	}
	
	deinit {
		self.document = nil
		self.currentPage = nil
	}
	
	init(frame: CGRect, URL url: NSURL) {
		
		var contentSize = CGSizeZero
	
		if let tempDocument = JCPDFDocument.createX(url, password: "") {

			self.document = tempDocument
			
			if let tempPage = CGPDFDocumentGetPage(self.document, 1) {
				
				self.currentPage = tempPage
				
				let cropBoxRect = CGPDFPageGetBoxRect(currentPage, kCGPDFCropBox)
				let mediaBoxRect = CGPDFPageGetBoxRect(currentPage, kCGPDFMediaBox)
				let effectiveRect = CGRectIntersection(cropBoxRect, mediaBoxRect)
				
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

