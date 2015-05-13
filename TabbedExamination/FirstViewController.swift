//
//  ViewController.swift
//  BubbleGame
//
//  Created by Lee-kai Wang on 5/11/15.
//  Copyright (c) 2015 Lee-kai Wang. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var bubblesCreated = 0
    var bubblesPopped = 0.0
    var bubbleArray = [UIView]()
    var bottomBorder = CALayer() // scoreView is extraneous after adding this
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bottomBorder.frame = CGRect(x: 0, y: view.frame.height / 2, width: view.frame.width, height: 1)
        bottomBorder.backgroundColor = UIColor.redColor().CGColor
        view.layer.addSublayer(bottomBorder)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        createBubble()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createBubble() {
        let startingRadius = 20
        let endingRadius = 60
        
        let bubble = UIView(frame: CGRect(x: Int(arc4random_uniform(UInt32(Int(view.frame.width) - startingRadius * 2))), y: 0, width: startingRadius * 2, height: startingRadius * 2))
        bubble.backgroundColor = randomColor()
        view.addSubview(bubble)
        bubbleArray.append(bubble)
        
        UIView.animateWithDuration(3, delay: 0.0, options: UIViewAnimationOptions.CurveLinear | UIViewAnimationOptions.AllowUserInteraction, animations: {
            bubble.frame = CGRect(x: Int(arc4random_uniform(UInt32(Int(self.view.frame.width) - endingRadius * 2))), y: Int(self.view.frame.height), width: endingRadius * 2, height: endingRadius * 2)
            }, completion: { finished in
                self.destroyBubbleAndCreate(bubble)
        })
        
        bubblesCreated += 1
    }
    
    func randomColor() -> UIColor {
        var randomRed = CGFloat(arc4random_uniform(256))/255.0
        var randomGreen = CGFloat(arc4random_uniform(256))/255.0
        var randomBlue = CGFloat(arc4random_uniform(256))/255.0
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
    }
    
    func destroyBubbleAndCreate(bubble: UIView) {
        if let bubbleExists = find(self.bubbleArray, bubble) {
            //println("\(bubblesPopped) out of \(bubblesCreated) bubbles popped: score = \(100 * bubblesPopped/Double(bubblesCreated))")
            bottomBorder.frame = CGRect(x: 0, y: Int(Double(view.frame.height) - Double(view.frame.height) * bubblesPopped / Double(bubblesCreated)), width: Int(view.frame.width), height: 1)
            bubble.removeFromSuperview()
            bubbleArray.removeAtIndex(find(self.bubbleArray, bubble)!)
            if isViewLoaded() && view.window != nil {
                createBubble()
            }
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInView(view)
        var hit = false
        for bubble in bubbleArray {
            if (bubble.layer.presentationLayer().hitTest(location) != nil) {
                hit = true
                //                bubblesPopped += Double((view.frame.height - location.y) / view.frame.height)
                bubblesPopped += 1
                destroyBubbleAndCreate(bubble)
            }
        }
        if hit == false {
            bubblesCreated += 1
            bottomBorder.frame = CGRect(x: 0, y: Int(Double(view.frame.height) - Double(view.frame.height) * bubblesPopped / Double(bubblesCreated)), width: Int(view.frame.width), height: 1)
        }
    }
    
}
