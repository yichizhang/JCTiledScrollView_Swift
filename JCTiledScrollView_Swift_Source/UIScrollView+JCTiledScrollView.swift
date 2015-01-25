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

extension UIScrollView {
	
	func jc_zoomScaleByZoomingIn(numberOfLevels:CGFloat) -> CGFloat {
		
		let newZoom = CGFloat(
			min(
				powf( 2, Float( log2(self.zoomScale) + numberOfLevels ) ),
				Float( self.maximumZoomScale )
			)
		)
		return newZoom
	}
	
	func jc_zoomScaleByZoomingOut(numberOfLevels:CGFloat) -> CGFloat {
		
		let newZoom = CGFloat(
			max(
				powf( 2, Float( log2(self.zoomScale) - numberOfLevels ) ),
				Float( self.minimumZoomScale )
			)
		)
		return newZoom
	}
	
	func jc_setContentCenter(center:CGPoint, animated:Bool) {
		var newContentOffset = self.contentOffset
		
		if self.contentSize.width > self.bounds.size.width {
			newContentOffset.x = max(0.0, (center.x * self.zoomScale) - (self.bounds.size.width / 2.0) )
			newContentOffset.x = min(newContentOffset.x,
				(self.contentSize.width - self.bounds.size.width));
		}
		if self.contentSize.height > self.bounds.size.height {
			newContentOffset.y = max(0.0, (center.y * self.zoomScale) - (self.bounds.size.height / 2.0));
			newContentOffset.y = min(newContentOffset.y,
				(self.contentSize.height - self.bounds.size.height));
		}
		
		self.setContentOffset(newContentOffset, animated:animated)
	}
}
