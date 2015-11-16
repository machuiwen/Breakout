//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Chuiwen Ma on 11/9/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UIBreakoutViewDelegate {
    
    @IBOutlet weak var gameView: BreakoutView! {
        didSet {
            gameView.delegate = self
            gameView.addGestureRecognizer(UITapGestureRecognizer(target: gameView, action: "pushBall"))
            let panRecognizer = UIPanGestureRecognizer(target: gameView, action: "movePaddle:")
            panRecognizer.maximumNumberOfTouches = 1
            gameView.addGestureRecognizer(panRecognizer)
        }
    }
    
//    private var settings: BreakoutSettings {
//        print("Load settings")
//        return BreakoutSettings()
//    }
    
    lazy var alert: UIAlertController = {
        var lazyAlert = UIAlertController(
            title: "You Win!",
            message: "All bricks are eliminated!",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        lazyAlert.addAction(UIAlertAction(
            title: "Replay",
            style:  .Default)
            { (action: UIAlertAction) -> Void in
                self.gameView?.initUI()
            }
        )
        lazyAlert.addAction(UIAlertAction(
            title: "Cancel",
            style: .Cancel)
            { (action: UIAlertAction) -> Void in
                // do nothing
            }
        )
        return lazyAlert
    }()
    
    func gameEnded(breakoutView: BreakoutView) {
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let settings = BreakoutSettings()
        gameView.numOfRows = settings.numberOfBricks / gameView.numOfCols
        gameView.ballBounciness = settings.ballBounciness
        gameView.allowGravity = settings.gravity
        print("game view has \(settings.numberOfBricks) bricks")
        print("game view has \(settings.ballBounciness) ball bounciness")
        gameView.initUI()
        
    }
    //    private func updateSettings() {
    ////        gameView?.numOfRows = settings.numberOfBricks / 5
    //    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        gameView?.initUI()
    //    }
    
    //
    //    override func viewDidAppear(animated: Bool) {
    //        super.viewDidAppear(animated)
    //        gameView?.initUI()
    //    }
    //
    //    override func viewWillDisappear(animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        gameView?.animating = false
    //    }
}
