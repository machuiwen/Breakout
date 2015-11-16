//
//  SettingsTableViewController.swift
//  Breakout
//
//  Created by Chuiwen Ma on 11/11/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    private var settings = BreakoutSettings()
    
    @IBOutlet private weak var numOfBricksStepper: UIStepper!
    @IBOutlet private weak var numOfBricksLabel: UILabel!
    @IBOutlet private weak var ballBouncinessSlider: UISlider!
    @IBOutlet private weak var numOfBallsSegControl: UISegmentedControl!
    @IBOutlet private weak var gravitySwitch: UISwitch!

    
    @IBAction private func updateNumOfBricksLabel(sender: UIStepper) {
        numOfBricksLabel?.text = String(Int(sender.value))
    }
    
    private func updateSettings() {
        settings.numberOfBricks = Int(numOfBricksStepper.value)
        settings.ballBounciness = ballBouncinessSlider.value
        settings.numberOfBalls = numOfBallsSegControl.selectedSegmentIndex + 1
        settings.gravity = gravitySwitch.on
    }
    
    private func printSettings() {
        print(settings.numberOfBricks)
        print(settings.ballBounciness)
        print(settings.numberOfBalls)
        print(settings.gravity)
        print("settings printed.")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        updateSettings()
        printSettings()
        print("Settings saved.")
    }
    
    private func loadSettings() {
        numOfBricksStepper?.value = Double(settings.numberOfBricks)
        numOfBricksLabel?.text = String(settings.numberOfBricks)
        ballBouncinessSlider?.setValue(settings.ballBounciness, animated: false)
        numOfBallsSegControl?.selectedSegmentIndex = settings.numberOfBalls - 1
        gravitySwitch?.setOn(settings.gravity, animated: false)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadSettings()
    }

}
