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

@objc class JCAnnotationView: UIView
{
    private var _position: CGPoint = CGPointZero
    private var _centerOffset: CGPoint = CGPointZero

    var annotation: JCAnnotation?
    var reuseIdentifier: String = ""
    var position: CGPoint
    {
        get
        {
            return _position
        }
        set
        {
            if (!CGPointEqualToPoint(_position, newValue)) {
                _position = newValue
                adjustCenter()
            }
        }
    }
    var centerOffset: CGPoint
    {
        get
        {
            return _centerOffset
        }
        set
        {
            if (!CGPointEqualToPoint(_centerOffset, newValue)) {
                _centerOffset = newValue
                adjustCenter()
            }
        }
    }

    init(frame: CGRect, annotation: JCAnnotation, reuseIdentifier: String)
    {
        super.init(frame: frame)

        self.annotation = annotation
        self.reuseIdentifier = reuseIdentifier
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    private func adjustCenter()
    {
        center = CGPointMake(position.x + centerOffset.x, position.y + centerOffset.y)
    }
}

