//
//  ViewController.swift
//  FaceIt
//
//  Created by Chris William Sehnert on 8/10/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import UIKit

class FaceViewController: VCLLoggingViewController {
    
    var expression = FacialExpression(eyes: .closed, mouth: .neutral) {
        didSet {
            updateUI()
        }
    }


    @IBOutlet weak var faceView: FaceView! {
        didSet {
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchRecognizer)
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))
//            tapRecognizer.numberOfTapsRequired = 1
//            faceView.addGestureRecognizer(tapRecognizer)
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipeUpRecognizer.direction = .up
            swipeUpRecognizer.numberOfTouchesRequired = 1
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeDownRecognizer.direction = .down
            swipeDownRecognizer.numberOfTouchesRequired = 1
            faceView.addGestureRecognizer(swipeUpRecognizer)
            faceView.addGestureRecognizer(swipeDownRecognizer)
            updateUI()
        }
    }
    
    private struct HeadShake {
        static let angle = CGFloat.pi/6
        static let segmentDuration: TimeInterval = 0.5
        
    }
    
    private func rotateFace(by angle: CGFloat) {
        faceView.transform = faceView.transform.rotated(by: angle)
    }
    
    private func shakeHead() {
        UIView.animate(
            withDuration: HeadShake.segmentDuration,
            animations: { self.rotateFace(by: HeadShake.angle) },
            completion: { finished in
                if finished {
                    UIView.animate(
                        withDuration: HeadShake.segmentDuration,
                        animations: { self.rotateFace(by: -HeadShake.angle * 2) },
                        completion: { finished in
                            if finished {
                                UIView.animate(
                                    withDuration: HeadShake.segmentDuration,
                                    animations: { self.rotateFace(by: HeadShake.angle) }
                                )
                            }
                    }
                    )
                }
        }
        )
    }
    
    
    @IBAction func shakeHead(_ sender: UITapGestureRecognizer) {
        shakeHead()        
    }
    
    func toggleEyes (byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    func increaseHappiness () {
        expression = expression.happier
    }
    
    func decreaseHappiness () {
        expression = expression.sadder
    }
    


    
    private func updateUI () {
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
            faceView?.eyesOpen = false
        }
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        
    }
    
    private let mouthCurvatures = [
        FacialExpression.Mouth.frown: -1.0,
        .smirk: -0.5,
        .grin: 0.5,
        .smile: 1.0,
        .neutral: 0.0]
}


