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

class JCAnnotationTapGestureRecognizer: UITapGestureRecognizer
{
    var tapAnnotation: JCVisibleAnnotationTuple?

    override init(target: Any?, action: Selector?)
    {
        super.init(target: target, action: action)
    }
}

