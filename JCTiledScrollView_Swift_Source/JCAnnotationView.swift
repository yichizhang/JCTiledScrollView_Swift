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
    fileprivate var _position: CGPoint = CGPoint.zero
    fileprivate var _centerOffset: CGPoint = CGPoint.zero

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
            if (!_position.equalTo(newValue)) {
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
            if (!_centerOffset.equalTo(newValue)) {
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

    fileprivate func adjustCenter()
    {
        center = CGPoint(x: position.x + centerOffset.x, y: position.y + centerOffset.y)
    }
}

