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

class JCVisibleAnnotationTuple: NSObject
{
	var annotation: JCAnnotation!
	var view: JCAnnotationView!

	convenience init(annotation: JCAnnotation, view: JCAnnotationView)
	{
		self.init()
		self.annotation = annotation
		self.view = view
	}
}

extension Set
{
	//NSSet {

	func visibleAnnotationTupleForAnnotation(annotation: JCAnnotation) -> JCVisibleAnnotationTuple?
	{
		for obj in self {
			if let t = obj as? JCVisibleAnnotationTuple {
				if t.annotation === annotation {
					return t
				}
			}
		}
		return nil
	}

	func visibleAnnotationTupleForView(view: JCAnnotationView) -> JCVisibleAnnotationTuple?
	{
		for obj in self {
			if let t = obj as? JCVisibleAnnotationTuple {
				if t.view === view {
					return t
				}
			}
		}
		return nil
	}
}
