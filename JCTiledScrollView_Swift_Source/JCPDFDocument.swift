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
import Foundation

class JCPDFDocument
{
	class func createX(documentURL: NSURL!, password: String!) -> CGPDFDocument?
	{
		// Check for non-NULL CFURLRef
		guard let document = CGPDFDocumentCreateWithURL(documentURL as CFURLRef) else {
			return nil
		}

		// Encrypted
		// Try a blank password first, per Apple's Quartz PDF example
		if CGPDFDocumentIsEncrypted(document) == true &&
		   CGPDFDocumentUnlockWithPassword(document, "") == false {
			// Nope, now let's try the provided password to unlock the PDF
			if let cPasswordString = password.cStringUsingEncoding(NSUTF8StringEncoding) {
				if CGPDFDocumentUnlockWithPassword(document, cPasswordString) == false {
					// Unlock failed
#if DEBUG
					println("CGPDFDocumentCreateX: Unable to unlock " + theURL + " with " + password)
#endif
				}
			}
		}

		return document
	}

	class func needsPassword(documentURL: NSURL!, password: String!) -> Bool
	{
		var needsPassword = false

		// Check for non-NULL CFURLRef
		guard let document = CGPDFDocumentCreateWithURL(documentURL as CFURLRef) else {
			return needsPassword
		}
		// Encrypted
		// Try a blank password first, per Apple's Quartz PDF example
		if CGPDFDocumentIsEncrypted(document) == true &&
		   CGPDFDocumentUnlockWithPassword(document, "") == false {
			// Nope, now let's try the provided password to unlock the PDF
			if let cPasswordString = password.cStringUsingEncoding(NSUTF8StringEncoding) {
				if CGPDFDocumentUnlockWithPassword(document, cPasswordString) == false {
					needsPassword = true
				}
			}
		}

		return needsPassword
	}

}

