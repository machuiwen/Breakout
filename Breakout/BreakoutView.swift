//
//  BreakoutView.swift
//  Breakout
//
//  Created by Chuiwen Ma on 11/9/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class BreakoutView: UIView, UICollisionBehaviorDelegate
{
    // MARK: Public API
    var numOfRows: Int = 5
    var numOfCols: Int { return 5 }
    var ballBounciness: Float = 1.0
    var allowGravity: Bool = false
    var numOfBalls: Int = 1
    
    var animating = false {
        didSet {
            if animating != oldValue {
                if animating {
                    animator.addBehavior(ballBehavior)
                } else {
                    animator.removeAllBehaviors()
                }
            }
        }
    }
    
    // MARK: Private Properties
    
    // Sizes
    private struct Sizes {
        static let ballDiameter = 30
        static let topMargin: CGFloat = 30
        static let bottomMargin: CGFloat = 60
        static let ballPaddleDist: CGFloat = 2
        static let brickPadding: CGFloat = 5
    }
    
    private var brickSize: CGSize {
        let width = (bounds.size.width - CGFloat(numOfCols + 1) * Sizes.brickPadding) / CGFloat(numOfCols)
        let height = (bounds.size.height / 3 - CGFloat(numOfRows + 1) * Sizes.brickPadding) / CGFloat(numOfRows)
        return CGSize(width: width, height: height)
    }
    
    private let ballSize = CGSize(width: Sizes.ballDiameter, height: Sizes.ballDiameter)
    
    private var paddleSize: CGSize {
        return CGSize(width: bounds.size.width / 4, height: 20)
    }
    
    private var randomAngle: CGFloat {
        // random angle from 0 to 2pi
        return CGFloat(Double(arc4random()) / Double(UINT32_MAX) * 2 * M_PI)
    }
    
    // Subviews
    private var bricks = [Int: UIView]()
    private var paddle: UIView?
    private var balls = Set<UIView>()
    
    // Animator & Behavior
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
    
    private lazy var ballBehavior: BreakoutBehavior = {
        let lazilyCreatedBallBehavior = BreakoutBehavior(
            ballBounciness: self.ballBounciness,
            allowGravity: self.allowGravity
        )
        lazilyCreatedBallBehavior.collisionDelegate = self
        lazilyCreatedBallBehavior.addBarrier(
            fromPoint: CGPoint(x: self.bounds.minX, y: self.bounds.maxY),
            toPoint: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY),
            named: "BottomBound"
        )
        return lazilyCreatedBallBehavior
    }()
    
    // Delegate property for UIBreakoutViewDelegate
    weak var delegate: UIBreakoutViewDelegate?
    
    
    // MARK: UICollisionBehaviorDelegate
    
    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        if let id = identifier as? Int {
            // remove boundary
            behavior.removeBoundaryWithIdentifier(id)
            if let brick = bricks[id] {
                // animation on view
                UIView.transitionWithView(brick,
                    duration: 0.4,
                    options: .TransitionFlipFromLeft,
                    animations: {
                        brick.backgroundColor = UIColor.purpleColor()
                    },
                    completion: { finished in
                        if finished {
                            brick.removeFromSuperview()
                        }
                    }
                )
                // remove from bricks dictionary
                bricks.removeValueForKey(id)
                // if all bricks are eliminated
                // stop animating, trigger an alert
                if bricks.count == 0 {
                    animating = false
                    delegate?.gameEnded(self, win: true)
                }
            }
        } else if let name = identifier as? String where name == "BottomBound" {
            // hit the bottom bound, remove ball from behavior
            // remove ball from superview and balls array
            behavior.removeItem(item)
            if let view = item as? UIView {
                view.removeFromSuperview()
                balls.remove(view)
            }
            // if all balls escape
            // stop animating, trigger an alert
            if balls.count == 0 {
                animating = false
                delegate?.gameEnded(self, win: false)
            }
            print("ball escaped from bottom bound")
        }
    }
    
    
    // MARK: Private Methods
    
    private func brickId(withRow row: Int, andCol col: Int) -> Int {
        return (row - 1) * numOfCols + col
    }

    // initialize bricks
    private func initBricks() {
        for row in 1...numOfRows {
            for col in 1...numOfCols {
                var frame = CGRect(origin: CGPointZero, size: brickSize)
                frame.origin.x = CGFloat(col) * Sizes.brickPadding + CGFloat(col - 1) * brickSize.width
                frame.origin.y = Sizes.topMargin + CGFloat(row) * Sizes.brickPadding + CGFloat(row - 1) * brickSize.height
                
                let brick = UIView(frame: frame)
                brick.layer.borderWidth = 1
                brick.layer.borderColor = UIColor.blackColor().CGColor
                brick.backgroundColor = UIColor.colorWithIndex(row)
                
                addSubview(brick)
                let bid = brickId(withRow: row, andCol: col)
                ballBehavior.addBarrier(brick.frame, named: bid)
                self.bricks[bid] = brick
            }
        }
    }
    
    // initialize balls
    private func initBalls() {
        for _ in 1...numOfBalls {
            var frame = CGRect(origin: CGPointZero, size: ballSize)
            frame.origin.x = (paddle?.frame.midX ?? bounds.size.width / 2) - ballSize.width / 2
            frame.origin.y = (paddle?.frame.minY ?? bounds.size.height * 2 / 3) - ballSize.height - Sizes.ballPaddleDist
            
            let ball = UIView(frame: frame)
            ball.backgroundColor = UIColor.brownColor()
            
            addSubview(ball)
            ballBehavior.addItem(ball)
            self.balls.insert(ball)
        }
    }
    
    // initialize padlle
    private func initPaddle() {
        var frame = CGRect(origin: CGPointZero, size: paddleSize)
        frame.origin.x = bounds.size.width / 2 - paddleSize.width / 2
        frame.origin.y = bounds.size.height - paddleSize.height - Sizes.bottomMargin
        
        let paddle = UIView(frame: frame)
        paddle.backgroundColor = UIColor.magentaColor()
        
        addSubview(paddle)
        ballBehavior.addBarrier(paddle.frame, named: "paddle")
        
        self.paddle = paddle
    }
    
    // initialize game
    func initUI() {
        animating = false
        bricks.removeAll()
        for ball in balls {
            ballBehavior.removeItem(ball)
        }
        balls.removeAll()
        paddle = nil
        for view in subviews {
            view.removeFromSuperview()
        }
        ballBehavior = BreakoutBehavior(ballBounciness: ballBounciness, allowGravity: allowGravity)
        ballBehavior.collisionDelegate = self
        ballBehavior.addBarrier(
            fromPoint: CGPoint(x: self.bounds.minX, y: self.bounds.maxY),
            toPoint: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY),
            named: "BottomBound"
        )
        initBricks()
        initPaddle()
        initBalls()
        animating = true
    }
    
    // tap gesture responder
    func pushBall() {
        ballBehavior.setPushAngle(randomAngle, andMagnitude: 300.0 / (ballSize.width * ballSize.height))
    }
    
    // pan gesture responder
    func movePaddle(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Changed || recognizer.state == .Ended {
            if let paddle = paddle {
                paddle.frame.origin.x = max(0, min(self.bounds.maxX - paddle.frame.width, recognizer.translationInView(self).x + paddle.frame.origin.x))
                recognizer.setTranslation(CGPointZero, inView: self)
                // add as barrier to ballBehavior
                ballBehavior.addBarrier(paddle.frame, named: "paddle")
            }
        }
    }
    
}

private extension UIColor {
    class func colorWithIndex(index: Int) -> UIColor {
        switch index {
        case 1:
            return redColor()
        case 2:
            return orangeColor()
        case 3:
            return yellowColor()
        case 4:
            return greenColor()
        case 5:
            return cyanColor()
        case 6:
            return blueColor()
        default:
            return purpleColor()
        }
    }
}
