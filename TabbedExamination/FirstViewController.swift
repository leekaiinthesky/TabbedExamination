//
//  ViewController.swift
//  BubbleGame
//
//  Created by Lee-kai Wang on 5/11/15.
//  Copyright (c) 2015 Lee-kai Wang. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController {
    
    var creationTimes = [NSDate]()
    var completionTimes = [NSDate]()
    var instructionLabel = UILabel()
    //var scoreLabel = UILabel()
    var activeBubble = UIView()

    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice!
    var output = AVCaptureMovieFileOutput()
    var topPreviewLayer : AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let devices = AVCaptureDevice.devices()
        captureSession.sessionPreset = AVCaptureSessionPresetMedium // can be changed
        // Loop through all the capture devices on this phone
        for device in devices {
            if device.hasMediaType(AVMediaTypeVideo) {
                if device.position == AVCaptureDevicePosition.Front {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        beginSession()
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //scoreLabel.removeFromSuperview()
        instructionLabel.removeFromSuperview()
        activeBubble.removeFromSuperview()
        creationTimes = []
        completionTimes = []

        instructionLabel.frame = CGRect(x: 50, y: 100, width: view.frame.width - 2 * 50, height: 500)
        instructionLabel.text = "Tap 10 red squares as fast as you can. Tap the green square below to begin."
        instructionLabel.font = UIFont(name: instructionLabel.font.fontName, size: 36)
        instructionLabel.numberOfLines = 0
        instructionLabel.textAlignment = NSTextAlignment.Center
        instructionLabel.backgroundColor = UIColor.whiteColor()
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
        //scoreLabel.removeFromSuperview()
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
            
//            scoreLabel.frame = CGRect(x: 200, y: 100, width: view.frame.width - 2 * 200, height: 400)
//            scoreLabel.text = "Fastest: \(Int(1000 * bestTime)) ms\nSlowest: \(Int(1000 * worstTime)) ms\nAverage: \(Int(1000 * totalTime / 10)) ms"
//            scoreLabel.font = UIFont(name: scoreLabel.font.fontName, size: 36)
//            scoreLabel.numberOfLines = 0
//            scoreLabel.textAlignment = NSTextAlignment.Center
//            scoreLabel.backgroundColor = UIColor.grayColor()
//            view.addSubview(scoreLabel)
            
            creationTimes = []
            completionTimes = []
            
            instructionLabel.frame = CGRect(x: 150, y: 100, width: view.frame.width - 2 * 150, height: 500)
            instructionLabel.text = "Fastest: \(Int(1000 * bestTime)) ms\nSlowest: \(Int(1000 * worstTime)) ms\nAverage: \(Int(1000 * totalTime / 10)) ms\n\n\nTap the green square to restart."
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
    
    func beginSession() {
        
        if let device = captureDevice {
            device.lockForConfiguration(nil)
            device.whiteBalanceMode = AVCaptureWhiteBalanceMode.Locked
            device.unlockForConfiguration()
        }
        
        var err: NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        //captureSession.addOutput(videoDataOutput)
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        topPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        topPreviewLayer.videoGravity = AVLayerVideoGravityResize
        view.layer.addSublayer(topPreviewLayer)
        topPreviewLayer.zPosition = -2000
        topPreviewLayer.frame = view.bounds
        
        //        bottomPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //        bottomPreviewLayer!.videoGravity = AVLayerVideoGravityResize
        //        bottomView.layer.addSublayer(bottomPreviewLayer)
        //        bottomPreviewLayer?.frame = bottomView.bounds
        //        println(bottomPreviewLayer?.transform)
        
//        output = AVCaptureVideoDataOutput()
//        output?.alwaysDiscardsLateVideoFrames = true // I think this is default anyway
//        output?.videoSettings = [kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA]
//        let cameraQueue = dispatch_queue_create("cameraQueue", DISPATCH_QUEUE_SERIAL)
//        output?.setSampleBufferDelegate(self, queue: cameraQueue)
//        captureSession.addOutput(output)
        
        
        captureSession.startRunning()
    }
}
