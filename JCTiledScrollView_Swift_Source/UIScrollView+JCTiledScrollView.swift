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

extension UIScrollView
{

    func jc_zoomScaleByZoomingIn(numberOfLevels: CGFloat) -> CGFloat
    {

        let newZoom = CGFloat(
        min(
        powf(2, Float(log2(self.zoomScale) + numberOfLevels)),
        Float(self.maximumZoomScale)
        )
        )
        return newZoom
    }

    func jc_zoomScaleByZoomingOut(numberOfLevels: CGFloat) -> CGFloat
    {

        let newZoom = CGFloat(
        max(
        powf(2, Float(log2(self.zoomScale) - numberOfLevels)),
        Float(self.minimumZoomScale)
        )
        )
        return newZoom
    }

    func jc_setContentCenter(center: CGPoint, animated: Bool)
    {
        var newContentOffset = self.contentOffset

        if self.contentSize.width > self.bounds.size.width {
            newContentOffset.x = max(0.0, (center.x * self.zoomScale) - (self.bounds.size.width / 2.0))
            newContentOffset.x = min(newContentOffset.x,
                                     (self.contentSize.width - self.bounds.size.width))
        }
        if self.contentSize.height > self.bounds.size.height {
            newContentOffset.y = max(0.0, (center.y * self.zoomScale) - (self.bounds.size.height / 2.0))
            newContentOffset.y = min(newContentOffset.y,
                                     (self.contentSize.height - self.bounds.size.height))
        }

        self.setContentOffset(newContentOffset, animated: animated)
    }
}
