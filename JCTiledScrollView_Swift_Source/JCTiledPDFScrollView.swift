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

class JCTiledPDFScrollView: JCTiledScrollView, JCPDFTiledViewDelegate
{
    private var document: CGPDFDocument!

    private var numberOfPages = Int(0)
    private var cropBoxRect = CGRectZero
    private var mediaBoxRect = CGRectZero
    private var effectiveRect = CGRectZero

    override class func tiledLayerClass() -> AnyClass
    {
        return JCPDFTiledView.self
    }

    deinit
    {
        document = nil
    }

    init(frame: CGRect, URL url: NSURL)
    {
        var contentSize = CGSizeZero

        guard let tempDocument = JCPDFDocument.createX(url, password: "") else {
            fatalError("Document is null")
        }
        document = tempDocument

        guard let firstPage = CGPDFDocumentGetPage(document, 1) else {
            fatalError("Page is null")
        }
        numberOfPages = CGPDFDocumentGetNumberOfPages(document)
        cropBoxRect = CGPDFPageGetBoxRect(firstPage, CGPDFBox.CropBox);
        mediaBoxRect = CGPDFPageGetBoxRect(firstPage, CGPDFBox.MediaBox);
        effectiveRect = mediaBoxRect

        contentSize = CGSize(width: effectiveRect.size.width,
                             height: effectiveRect.size.height * CGFloat(numberOfPages))

        super.init(frame: frame, contentSize: contentSize)

        let preferredTileWidth = 256
        let preferredTileHeight = 256

        let cols = Int(effectiveRect.size.width) / preferredTileWidth + 1
        let rows = Int(effectiveRect.size.height) / preferredTileHeight + 1
        self.tiledView.tileSize = CGSize(width: effectiveRect.size.width / CGFloat(cols), height: effectiveRect.size.height / CGFloat(rows))

        let fitZoomScale = min(
        scrollView.bounds.width / effectiveRect.size.width,
        scrollView.bounds.height / effectiveRect.size.height
        )

        scrollView.minimumZoomScale = fitZoomScale
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    func pdfPageForTiledView(tiledView: JCPDFTiledView!, rect: CGRect, pageNumber: UnsafeMutablePointer<Int>, pageSize: UnsafeMutablePointer<CGSize>) -> CGPDFPage?
    {
        var requestedPage = Int(rect.origin.y / effectiveRect.height) + 1

        if requestedPage < 1 {
            requestedPage = 1
        }
        if requestedPage > numberOfPages {
            requestedPage = numberOfPages
        }

        pageNumber.memory = requestedPage
        pageSize.memory = effectiveRect.size

        return CGPDFDocumentGetPage(document, requestedPage)
    }

    func pdfDocumentForTiledView(tiledView: JCPDFTiledView!) -> CGPDFDocument
    {
        return document
    }
}

