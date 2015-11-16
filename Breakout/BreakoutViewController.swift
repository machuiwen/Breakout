//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Chuiwen Ma on 11/9/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UIBreakoutViewDelegate {
    
    // Game Settings
    private let settings = BreakoutSettings()
    
    // Game View
    @IBOutlet weak var gameView: BreakoutView! {
        didSet {
            gameView.addGestureRecognizer(UITapGestureRecognizer(target: gameView, action: "pushBall"))
            let panRecognizer = UIPanGestureRecognizer(target: gameView, action: "movePaddle:")
            panRecognizer.maximumNumberOfTouches = 1
            gameView.addGestureRecognizer(panRecognizer)
        }
    }
    
    // Alert Controller
    private lazy var alert: UIAlertController = {
        var lazyAlert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        lazyAlert.addAction(UIAlertAction(
            title: "Cancel",
            style: .Cancel,
            handler: nil)
        )
        lazyAlert.addAction(UIAlertAction(
            title: "Retry",
            style:  .Default)
            { (action: UIAlertAction) -> Void in
                self.gameView?.initUI()
            }
        )
        return lazyAlert
    }()
    
    // Update game settings
    private func updateSettings() {
        if let gameView = gameView {
            gameView.numOfRows = settings.numberOfBricks / gameView.numOfCols
            gameView.ballBounciness = settings.ballBounciness
            gameView.numOfBalls = settings.numberOfBalls
            gameView.allowGravity = settings.gravity
            print("game view has \(settings.numberOfBricks) bricks")
        }
    }
    
    // MARK: UIBreakoutViewDelegate
    
    func gameEnded(breakoutView: BreakoutView, win: Bool) {
        if win {
            alert.title = "You Win!"
            alert.message = "All bricks are eliminated."
        } else {
            alert.title = "Game Over!"
            alert.message = "You lose all balls."
        }
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: ViewController life cycle
    
    // set gameView's delegate to be self
    override func viewDidLoad() {
        super.viewDidLoad()
        // set delegate
        gameView?.delegate = self
    }
    
    // update settings
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateSettings()
        gameView?.initUI()
    }
    
    // stop animation
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        gameView?.animating = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        gameView?.initUI()
    }
}
