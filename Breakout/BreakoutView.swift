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
    weak var delegate: UIBreakoutViewDelegate?
    
    var numOfRows = 5
    var numOfCols:Int { return 5 }
    
    var ballBounciness: Float = 1.0
    var allowGravity: Bool = false
    var numOfBalls: Int = 1
    
    private var padding: CGFloat = 5
    private var brickSize: CGSize {
        let width = (bounds.size.width - CGFloat(numOfCols + 1) * padding) / CGFloat(numOfCols)
        let height = (bounds.size.height / 3 - CGFloat(numOfRows + 1) * padding) / CGFloat(numOfRows)
        return CGSize(width: width, height: height)
    }
    private let ballSize = CGSize(width: 30, height: 30)
    private var paddleSize: CGSize {
        let width = bounds.size.width / 4
        return CGSize(width: width, height: 20)
    }
    
    private struct Sizes {
        static let ballDiameter = 30
        static let topMargin: CGFloat = 30
        static let bottomMargin: CGFloat = 60
        static let ballPaddleDist: CGFloat = 2
    }
    
    private lazy var ballBehavior: BreakoutBehavior = {
        let lazilyCreatedBallBehavior = BreakoutBehavior(ballBounciness: self.ballBounciness, allowGravity: self.allowGravity)
        lazilyCreatedBallBehavior.collisionDelegate = self
        return lazilyCreatedBallBehavior
    }()
    
    private var bricks = [Int: UIView]()
    
    // UICollisionBehaviorDelegate
    
    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        if let ball = item as? UIView where ball == self.ball {
            if let id = identifier as? Int {
                behavior.removeBoundaryWithIdentifier(id)
                if let brick = bricks[id] {
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
                    bricks.removeValueForKey(id)
                    if bricks.count == 0 {
                        animating = false
                        delegate?.gameEnded(self)
                    }
                }
            }
        }
    }
    
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
    
    private var paddle: UIView?
    private var ball: UIView?
    
    private var randomAngle: CGFloat {
        return CGFloat(Double(arc4random()) / Double(UINT32_MAX) * 2 * M_PI)
    }
    
    func initUI() {
        bricks.removeAll()
        paddle = nil
        if let ball = ball {
            ballBehavior.removeItem(ball)
        }
        ball = nil
        animating = false
        for view in subviews {
            view.removeFromSuperview()
        }
        ballBehavior = BreakoutBehavior(ballBounciness: self.ballBounciness, allowGravity: self.allowGravity)
        ballBehavior.collisionDelegate = self
        initBricks()
        initPaddle()
        initBall()
    }
    
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
    
    private func initBricks() {
        for row in 1...numOfRows {
            for col in 1...numOfCols {
                var frame = CGRect(origin: CGPointZero, size: brickSize)
                frame.origin.x = CGFloat(col) * padding + CGFloat(col - 1) * brickSize.width
                frame.origin.y = Sizes.topMargin + CGFloat(row) * padding + CGFloat(row - 1) * brickSize.height
                
                let brick = UIView(frame: frame)
                brick.layer.borderWidth = 1
                brick.layer.borderColor = UIColor.blackColor().CGColor
                brick.backgroundColor = UIColor.colorWithIndex(row)
                
                addSubview(brick)
                ballBehavior.addBarrier(brick.frame, named: brickId(withRow: row, andCol: col))
                
                self.bricks[brickId(withRow: row, andCol: col)] = brick
            }
        }
    }
    
    private func brickId(withRow row: Int, andCol col: Int) -> Int {
        return (row - 1) * numOfRows + col
    }
    
    func initBall() {
        var frame = CGRect(origin: CGPointZero, size: ballSize)
        frame.origin.x = (paddle?.frame.midX ?? bounds.size.width / 2) - ballSize.width / 2
        frame.origin.y = (paddle?.frame.minY ?? bounds.size.height * 2 / 3) - ballSize.height - Sizes.ballPaddleDist
        
        let ball = UIView(frame: frame)
        ball.backgroundColor = UIColor.brownColor()
        
        addSubview(ball)
        ballBehavior.addItem(ball)
        
        self.ball = ball
    }
    
    func initPaddle() {
        var frame = CGRect(origin: CGPointZero, size: paddleSize)
        frame.origin.x = bounds.size.width / 2 - paddleSize.width / 2
        frame.origin.y = bounds.size.height - paddleSize.height - Sizes.bottomMargin
        
        let paddle = UIView(frame: frame)
        paddle.backgroundColor = UIColor.magentaColor()
        
        addSubview(paddle)
        ballBehavior.addBarrier(paddle.frame, named: "paddle")
        
        self.paddle = paddle
    }
    
    func pushBall() {
        if animating == false {
            animating = true
        }
        ballBehavior.setPushAngle(randomAngle, andMagnitude: 300.0 / (ball!.bounds.width * ball!.bounds.height))
        print("ball pushed")
    }
    
    func movePaddle(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Changed || recognizer.state == .Ended {
            if let paddle = paddle {
                paddle.frame.origin.x = max(0, min(self.bounds.maxX - paddle.frame.width, recognizer.translationInView(self).x + paddle.frame.origin.x))
                recognizer.setTranslation(CGPointZero, inView: self)
                ballBehavior.addBarrier(paddle.frame, named: "paddle")
            }
        }
    }
    
    // MARK: TO BE implemented
    override func layoutSubviews() {
        super.layoutSubviews()
        // position bricks
        // position paddle
        // position ball
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
