//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Chuiwen Ma on 11/11/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
    
//    private let gravity = UIGravityBehavior()
    
    private let gravity: UIGravityBehavior = {
        let lazilyCreatedGravity = UIGravityBehavior()
        lazilyCreatedGravity.setAngle(CGFloat(M_PI / 2), magnitude: 0.0)
        return lazilyCreatedGravity
    }()
    
    private let push = UIPushBehavior(items: [], mode: UIPushBehaviorMode.Instantaneous)
    
    private let collision: UICollisionBehavior = {
        let lazilyCreatedCollision = UICollisionBehavior()
        lazilyCreatedCollision.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreatedCollision
    }()
    
    private let itemBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedItemBehavior = UIDynamicItemBehavior()
        lazilyCreatedItemBehavior.allowsRotation = false
        lazilyCreatedItemBehavior.elasticity = 1.0
        lazilyCreatedItemBehavior.resistance = 0.0
        lazilyCreatedItemBehavior.friction = 0.0
        return lazilyCreatedItemBehavior
    }()
    
    var collisionDelegate:UICollisionBehaviorDelegate? {
        get {
            return collision.collisionDelegate
        }
        set {
            collision.collisionDelegate = newValue
        }
    }
    
    override init() {
        super.init()
        gravity.magnitude = 0.0
        addChildBehavior(gravity)
        addChildBehavior(push)
        addChildBehavior(collision)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(ballBounciness elasticity: Float, allowGravity g: Bool) {
        self.init()
        gravity.setAngle(CGFloat(M_PI / 2), magnitude: g ? 0.1 : 0.0)
        itemBehavior.elasticity = CGFloat(elasticity)
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
        print(push.items.count)
        push.setAngle(angel, magnitude: magnitude)
        push.active = true
    }
    
    func addBarrier(frameRect: CGRect, named name: NSCopying) {
        collision.removeBoundaryWithIdentifier(name)
        collision.addBoundaryWithIdentifier(name, forPath: UIBezierPath(rect: frameRect))
    }
    
    func removeBarrier(name: NSCopying) {
        collision.removeBoundaryWithIdentifier(name)
    }
    
}
