//
//  UIBreakoutViewDelegate.swift
//  Breakout
//
//  Created by Chuiwen Ma on 11/15/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import Foundation

@objc protocol UIBreakoutViewDelegate {
    // tell the view controller game has ended
    func gameEnded(breakoutView: BreakoutView, win: Bool)
}