//
//  ViewController.swift
//  BubbleGame
//
//  Created by Lee-kai Wang on 5/11/15.
//  Copyright (c) 2015 Lee-kai Wang. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var creationTimes = [NSDate]()
    var completionTimes = [NSDate]()
    var instructionLabel = UILabel()
    var scoreLabel = UILabel()
    var activeBubble = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scoreLabel.removeFromSuperview()
        instructionLabel.removeFromSuperview()
        activeBubble.removeFromSuperview()
        creationTimes = []
        completionTimes = []

        instructionLabel.frame = CGRect(x: 150, y: 100, width: view.frame.width - 2 * 150, height: 500)
        instructionLabel.text = "Tap 10 red squares as fast as you can. Tap the green square below to begin."
        instructionLabel.font = UIFont(name: instructionLabel.font.fontName, size: 36)
        instructionLabel.numberOfLines = 0
        instructionLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(instructionLabel)
        
        let startingRadius = 40
        activeBubble = UIView(frame: CGRect(x: Int(Int(view.frame.width) - startingRadius * 2)/2, y: Int(Int(view.frame.height) - startingRadius * 2)/2, width: startingRadius * 2, height: startingRadius * 2))
        activeBubble.backgroundColor = UIColor.greenColor()
        view.addSubview(activeBubble)
        creationTimes.append(NSDate())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createBubble() {
        let startingRadius = 40
        activeBubble = UIView(frame: CGRect(x: Int(arc4random_uniform(UInt32(Int(view.frame.width) - startingRadius * 2))), y: Int(arc4random_uniform(UInt32(Int(view.frame.height) - startingRadius * 2 - 100))), width: startingRadius * 2, height: startingRadius * 2))
        activeBubble.backgroundColor = UIColor.redColor()
        view.addSubview(activeBubble)
        creationTimes.append(NSDate())
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
    }
    
    func destroyBubbleAndCreate() {
        scoreLabel.removeFromSuperview()
        instructionLabel.removeFromSuperview()
        activeBubble.removeFromSuperview()
        
        if count(creationTimes) > 10 {
            var time = 0.0
            var bestTime = 999.0
            var worstTime = 0.0
            var totalTime = 0.0
            for i in 1...10 { // ignore first one (green)
                time = completionTimes[i].timeIntervalSinceDate(creationTimes[i])
                if time < bestTime {
                    bestTime = time
                }
                if time > worstTime {
                    worstTime = time
                }
                totalTime += time
            }
            
            scoreLabel.frame = CGRect(x: 200, y: 100, width: view.frame.width - 2 * 200, height: 400)
            scoreLabel.text = "Fastest: \(Int(1000 * bestTime)) ms\nSlowest: \(Int(1000 * worstTime)) ms\nAverage: \(Int(1000 * totalTime / 10)) ms"
            scoreLabel.font = UIFont(name: scoreLabel.font.fontName, size: 36)
            scoreLabel.numberOfLines = 0
            scoreLabel.textAlignment = NSTextAlignment.Center
            view.addSubview(scoreLabel)
            
            creationTimes = []
            completionTimes = []
            
            instructionLabel.frame = CGRect(x: 150, y: 350, width: view.frame.width - 2 * 150, height: 200)
            instructionLabel.text = "Tap the green square to restart."
            instructionLabel.font = UIFont(name: instructionLabel.font.fontName, size: 36)
            instructionLabel.numberOfLines = 0
            instructionLabel.textAlignment = NSTextAlignment.Center
            view.addSubview(instructionLabel)
            
            let startingRadius = 40
            activeBubble = UIView(frame: CGRect(x: Int(Int(view.frame.width) - startingRadius * 2)/2, y: Int(view.frame.height * 3 / 5), width: startingRadius * 2, height: startingRadius * 2))
            activeBubble.backgroundColor = UIColor.greenColor()
            view.addSubview(activeBubble)
            creationTimes.append(NSDate())

        } else if isViewLoaded() && view.window != nil {
            createBubble()
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInView(view)
        var hit = false
        if activeBubble.layer.presentationLayer().hitTest(location) != nil {
            hit = true
            completionTimes.append(NSDate())
            destroyBubbleAndCreate()
        }
        if hit == false {
//            bottomBorder.frame = CGRect(x: 0, y: Int(Double(view.frame.height) - Double(view.frame.height) * bubblesPopped / Double(bubblesCreated)), width: Int(view.frame.width), height: 1)
        }
    }
    
}
