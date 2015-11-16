//
//  BreakoutSettings.swift
//  Breakout
//
//  Created by Chuiwen Ma on 11/12/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import Foundation

class BreakoutSettings {
    
    // MARK: Public API
    
    var numberOfBricks: Int {
        get {
            return (defaults.objectForKey(Keys.NumberOfBricks) as? Int) ?? DefaultSettings.NumberOfBricks
        }
        set {
            defaults.setInteger(newValue, forKey: Keys.NumberOfBricks)
        }
    }
    
    var ballBounciness: Float {
        get {
            return (defaults.objectForKey(Keys.BallBounciness) as? Float) ?? DefaultSettings.BallBounciness
        }
        set {
            defaults.setFloat(newValue, forKey: Keys.BallBounciness)
        }
    }
    
    var numberOfBalls: Int {
        get {
            return (defaults.objectForKey(Keys.NumberOfBalls) as? Int) ?? DefaultSettings.NumberOfBalls
        }
        set {
            defaults.setInteger(newValue, forKey: Keys.NumberOfBalls)
        }
    }
    
    var numberOfLives: Int {
        get {
            return (defaults.objectForKey(Keys.NumberOfLives) as? Int) ?? DefaultSettings.NumberOfLives
        }
        set {
            defaults.setInteger(newValue, forKey: Keys.NumberOfLives)
        }
    }
    
    var gravity: Bool {
        get {
            return (defaults.objectForKey(Keys.Gravity) as? Bool) ?? DefaultSettings.Gravity
        }
        set {
            defaults.setBool(newValue, forKey: Keys.Gravity)
        }
    }
    
    var specialBricks: Bool {
        get {
            return (defaults.objectForKey(Keys.SpecialBricks) as? Bool) ?? DefaultSettings.SpecialBricks
        }
        set {
            defaults.setBool(newValue, forKey: Keys.SpecialBricks)
        }
    }
    
    
    // MARK: Private data structure
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private struct Keys {
        static let NumberOfBricks = "NumberOfBricks"
        static let BallBounciness = "BallBounciness"
        static let NumberOfBalls = "NumberOfBalls"
        static let NumberOfLives = "NumberOfLives"
        static let Gravity = "Gravity"
        static let SpecialBricks = "SpecialBricks"
    }
    
    private struct DefaultSettings {
        static let NumberOfBricks = 25
        static let BallBounciness: Float = 1.0
        static let NumberOfBalls = 1
        static let NumberOfLives = 1
        static let Gravity = false
        static let SpecialBricks = false
    }
    
}