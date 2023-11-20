//
//  UIView+.swift
//  Runner
//
//  Created by lambiengcode on 19/11/2023.
//

import UIKit

extension UIView {
    func setHeight(_ h:CGFloat, animateTime:TimeInterval?=nil) {

        if let c = self.constraints.first(where: { $0.firstAttribute == .height && $0.relation == .equal }) {
            c.constant = CGFloat(h)

            if let animateTime = animateTime {
                UIView.animate(withDuration: animateTime, animations:{
                    self.superview?.layoutIfNeeded()
                })
            }
            else {
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
    func setWidth(_ w:CGFloat, animateTime:TimeInterval?=nil) {

        if let c = self.constraints.first(where: { $0.firstAttribute == .width && $0.relation == .equal }) {
            c.constant = CGFloat(w)

            if let animateTime = animateTime {
                UIView.animate(withDuration: animateTime, animations:{
                    self.superview?.layoutIfNeeded()
                })
            }
            else {
                self.superview?.layoutIfNeeded()
            }
        }
    }
}

extension UIView {
    /// Remove all subview until has 1 view
    func removeSubviewsUntil1View() {
        for (index, element) in subviews.enumerated() {
            if (index < subviews.count - 1) {
                element.removeFromSuperview()
            }
        }
    }
    
    // Remove all subview
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    /// Remove all subview with specific type
    func removeAllSubviews<T: UIView>(type: T.Type) {
        subviews
            .filter { $0.isMember(of: type) }
            .forEach { $0.removeFromSuperview() }
    }
}
