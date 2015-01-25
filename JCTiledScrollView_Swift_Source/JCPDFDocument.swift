//
//  JCPDFDocument.swift
//  JCTiledScrollView-Swift
//
//  Created by Yichi on 26/01/2015.
//  Copyright (c) 2015 Yichi Zhang. All rights reserved.
//

import UIKit
import Foundation

class JCPDFDocument{
	class func createX(theURL:NSURL?, password:String?) -> CGPDFDocument? {
		
		if let theURL = theURL {
			
			if let thePDFDoc = CGPDFDocumentCreateWithURL(theURL as CFURLRef) { // Check for non-NULL CFURLRef
				
				if CGPDFDocumentIsEncrypted(thePDFDoc) == true { // Encrypted
					// Try a blank password first, per Apple's Quartz PDF example
					if CGPDFDocumentUnlockWithPassword(thePDFDoc, "") == false {
						// Nope, now let's try the provided password to unlock the PDF
						if let password = password {
							// Not blank?
							if let cPasswordString = password.cStringUsingEncoding(NSUTF8StringEncoding) {
								if CGPDFDocumentUnlockWithPassword(thePDFDoc, cPasswordString) == false {
									// Unlock failed
									#if DEBUG
										println("CGPDFDocumentCreateX: Unable to unlock " + theURL + " with " + password)
									#endif
								}
							}
						}
					}
				}
				
				return thePDFDoc
			}
		} else {
			#if DEBUG
			println("CGPDFDocumentCreateX: theURL == NULL")
			#endif
		}
		
		return nil
	}
	
	class func needsPassword(theURL:NSURL?, password:String?) -> Bool {
		
		var needsPassword = false // Default flag
		
		if let theURL = theURL {
			
			if let thePDFDoc = CGPDFDocumentCreateWithURL(theURL as CFURLRef) { // Check for non-NULL CFURLRef
				
				if CGPDFDocumentIsEncrypted(thePDFDoc) == true { // Encrypted
					// Try a blank password first, per Apple's Quartz PDF example
					if CGPDFDocumentUnlockWithPassword(thePDFDoc, "") == false {
						// Nope, now let's try the provided password to unlock the PDF
						if let password = password {
							// Not blank?
							if let cPasswordString = password.cStringUsingEncoding(NSUTF8StringEncoding) {
								if CGPDFDocumentUnlockWithPassword(thePDFDoc, cPasswordString) == false {
									
									needsPassword = true
								}
							}
						}
					}
				}
			}
		} else {
			needsPassword = true
		}
		
		return needsPassword
	}
}
