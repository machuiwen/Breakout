//
//  SettingsTableViewController.swift
//  Breakout
//
//  Created by Chuiwen Ma on 11/11/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    // MARK: Model
    
    private var settings = BreakoutSettings()
    
    // MARK: Outlets
    
    @IBOutlet private weak var numOfBricksStepper: UIStepper!
    @IBOutlet private weak var numOfBricksLabel: UILabel!
    @IBOutlet private weak var ballBouncinessSlider: UISlider!
    @IBOutlet private weak var numOfBallsSegControl: UISegmentedControl!
    @IBOutlet private weak var gravitySwitch: UISwitch!
    
    // MARK: Actions
    @IBAction private func updateNumOfBricksLabel(sender: UIStepper) {
        numOfBricksLabel?.text = String(Int(sender.value))
    }
    
    // MARK: Methods
    
    private func saveSettings() {
        settings.numberOfBricks = Int(numOfBricksStepper.value)
        settings.ballBounciness = ballBouncinessSlider.value
        settings.numberOfBalls = numOfBallsSegControl.selectedSegmentIndex + 1
        settings.gravity = gravitySwitch.on
    }
    
    private func printSettings() {
        print("Number of bricks: \(settings.numberOfBricks)")
        print("Ball bounciness: \(settings.ballBounciness)")
        print("Number of balls: \(settings.numberOfBalls)")
        print("Gravity: \(settings.gravity)")
        print("settings printed.")
    }
    
    private func loadSettings() {
        numOfBricksStepper?.value = Double(settings.numberOfBricks)
        numOfBricksLabel?.text = String(settings.numberOfBricks)
        ballBouncinessSlider?.setValue(settings.ballBounciness, animated: false)
        numOfBallsSegControl?.selectedSegmentIndex = settings.numberOfBalls - 1
        gravitySwitch?.setOn(settings.gravity, animated: false)
    }

    // MARK: ViewController life cycle
    
    // Load settings before appear
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadSettings()
    }
    
    // Save settings before disappear
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveSettings()
        printSettings()
    }

}
