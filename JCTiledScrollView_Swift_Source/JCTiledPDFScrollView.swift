//
//  Copyright (c) 2015-present Yichi Zhang
//  https://github.com/yichizhang
//  zhang-yi-chi@hotmail.com
//
//  This source code is licensed under MIT license found in the LICENSE file
//  in the root directory of this source tree.
//  Attribution can be found in the ATTRIBUTION file in the root directory 
//  of this source tree.
//

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

