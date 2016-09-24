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

    func visibleAnnotationTupleForAnnotation(_ annotation: JCAnnotation) -> JCVisibleAnnotationTuple?
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

    func visibleAnnotationTupleForView(_ view: JCAnnotationView) -> JCVisibleAnnotationTuple?
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
