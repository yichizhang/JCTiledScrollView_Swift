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
import Foundation

class JCPDFDocument
{
    class func createX(_ documentURL: URL!, password: String!) -> CGPDFDocument?
    {
        // Check for non-NULL CFURLRef
        guard let document = CGPDFDocument(documentURL as CFURL) else {
            return nil
        }

        // Encrypted
        // Try a blank password first, per Apple's Quartz PDF example
        if document.isEncrypted == true &&
           document.unlockWithPassword("") == false {
            // Nope, now let's try the provided password to unlock the PDF
            if let cPasswordString = password.cString(using: String.Encoding.utf8) {
                if document.unlockWithPassword(cPasswordString) == false {
                    // Unlock failed
#if DEBUG
                    print("CGPDFDocumentCreateX: Unable to unlock \(documentURL)")
#endif
                }
            }
        }

        return document
    }

    class func needsPassword(_ documentURL: URL!, password: String!) -> Bool
    {
        var needsPassword = false

        // Check for non-NULL CFURLRef
        guard let document = CGPDFDocument(documentURL as CFURL) else {
            return needsPassword
        }
        // Encrypted
        // Try a blank password first, per Apple's Quartz PDF example
        if document.isEncrypted == true &&
           document.unlockWithPassword("") == false {
            // Nope, now let's try the provided password to unlock the PDF
            if let cPasswordString = password.cString(using: String.Encoding.utf8) {
                if document.unlockWithPassword(cPasswordString) == false {
                    needsPassword = true
                }
            }
        }

        return needsPassword
    }

}

