//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Chuiwen Ma on 11/11/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
    
    // Gravity Behavior
    private let gravity: UIGravityBehavior = {
        let lazilyCreatedGravity = UIGravityBehavior()
        lazilyCreatedGravity.setAngle(CGFloat(M_PI / 2), magnitude: 0.0)
        return lazilyCreatedGravity
    }()
    
    // Push Behavior
    private lazy var push: UIPushBehavior = {
        let lazilyCreatedPush = UIPushBehavior(items: [], mode: UIPushBehaviorMode.Instantaneous)
        lazilyCreatedPush.action = { [unowned self] in
            if !lazilyCreatedPush.active {
                self.removeChildBehavior(lazilyCreatedPush)
            }
        }
        return lazilyCreatedPush
    }()
    
    // Collision Behavior
    private let collision: UICollisionBehavior = {
        let lazilyCreatedCollision = UICollisionBehavior()
        lazilyCreatedCollision.translatesReferenceBoundsIntoBoundary = true
        lazilyCreatedCollision.action = {
            if let referenceView = lazilyCreatedCollision.dynamicAnimator?.referenceView {
                for item in lazilyCreatedCollision.items {
                    if let view = item as? UIView where CGRectIsEmpty(CGRectIntersection(referenceView.bounds, view.frame)) {
                        // view is completely out of bounds of the reference view
                        lazilyCreatedCollision.removeItem(view)
                        view.removeFromSuperview()
                        print("Out of bounds.")
                    }
                }
            }
        }
        return lazilyCreatedCollision
    }()
    
    // Dynamic Item Behavior
    private let itemBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedItemBehavior = UIDynamicItemBehavior()
        lazilyCreatedItemBehavior.allowsRotation = false
        lazilyCreatedItemBehavior.elasticity = 1.0
        lazilyCreatedItemBehavior.resistance = 0.0
        lazilyCreatedItemBehavior.friction = 0.0
        return lazilyCreatedItemBehavior
    }()
    
    // MARK: Public API
    
    weak var collisionDelegate: UICollisionBehaviorDelegate? {
        get {
            return collision.collisionDelegate
        }
        set {
            collision.collisionDelegate = newValue
        }
    }
    
    override init() {
        super.init()
        addChildBehavior(collision)
        addChildBehavior(itemBehavior)
        // gravity is optional
        // push will be added when setting push angel and magnitude
    }
    
    // initialize with ball bounciness and gravity option
    convenience init(ballBounciness elasticity: Float, allowGravity: Bool) {
        self.init()
        itemBehavior.elasticity = CGFloat(elasticity)
        if allowGravity {
            gravity.setAngle(CGFloat(M_PI / 2), magnitude: 0.1)
            itemBehavior.addChildBehavior(gravity)
        }
    }
    
    func addItem(item: UIDynamicItem) {
        gravity.addItem(item)
        push.addItem(item)
        collision.addItem(item)
        itemBehavior.addItem(item)
    }
    
    func removeItem(item: UIDynamicItem) {
        gravity.removeItem(item)
        push.removeItem(item)
        collision.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    func setPushAngle(angel: CGFloat, andMagnitude magnitude: CGFloat) {
        addChildBehavior(push)
        push.setAngle(angel, magnitude: magnitude)
        push.active = true
    }
    
    func addBarrier(frameRect: CGRect, named name: NSCopying) {
        collision.removeBoundaryWithIdentifier(name)
        collision.addBoundaryWithIdentifier(name, forPath: UIBezierPath(rect: frameRect))
    }
    
    func addBarrier(fromPoint p1: CGPoint, toPoint p2: CGPoint, named name: NSCopying) {
        collision.removeBoundaryWithIdentifier(name)
        collision.addBoundaryWithIdentifier(name, fromPoint: p1, toPoint: p2)
    }
    
    func removeBarrier(name: NSCopying) {
        collision.removeBoundaryWithIdentifier(name)
    }
    
}
