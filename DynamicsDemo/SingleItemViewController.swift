//
//  SingleItemViewController.swift
//  DynamicsDemo
//
//  Created by Hesham Abd-Elmegid on 6/23/16.
//  Copyright © 2016 CareerFoundy. All rights reserved.
//

import UIKit

class SingleItemViewController: UIViewController {
    
    let blueSquareView = UIView()
    var originalBounds = CGRect.zero
    var originalCenter = CGPoint.zero
    let ThrowingThreshold: CGFloat = 1000
    let ThrowingVelocityPadding: CGFloat = 35
    var attachmentBehavior: UIAttachmentBehavior!
    var pushBehavior: UIPushBehavior!
    var itemBehavior: UIDynamicItemBehavior!
    lazy var animator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self.view)
    }()
    
    @IBOutlet weak var redSquare: UIView!
    @IBOutlet weak var blueSquare: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBlueSquareView()
        animator = UIDynamicAnimator(referenceView: view)
        originalBounds = blueSquareView.bounds
        originalCenter = blueSquareView.center
    }
    
    func addBlueSquareView() {
        let frame = CGRectMake(50, 70, 150, 150)
        blueSquareView.frame = frame
        blueSquareView.backgroundColor = .blueColor()
        view.addSubview(blueSquareView)
    }
    
    @IBAction func handleAttachmentGesture(sender: UIPanGestureRecognizer) {
        let location = sender.locationInView(self.view)
        let boxLocation = sender.locationInView(self.blueSquareView)
        
        
        switch sender.state {
        case .Began:
            print("Your touch start position is \(location)")
            print("Start location in image is \(boxLocation)")
            // 1
            animator.removeAllBehaviors()
            
            // 2
            let centerOffset = UIOffset(horizontal: boxLocation.x - blueSquareView.bounds.midX,
                                        vertical: boxLocation.y - blueSquareView.bounds.midY)
            attachmentBehavior = UIAttachmentBehavior(item: blueSquareView,
                                                      offsetFromCenter: centerOffset, attachedToAnchor: location)
            
            // 3
            redSquare.center = attachmentBehavior.anchorPoint
            blueSquare.center = location
            
            // 4
            animator.addBehavior(attachmentBehavior)
            
        case .Ended:
            print("Your touch end position is \(location)")
            print("End location in image is \(boxLocation)")
            
            animator.removeAllBehaviors()
            
            // 1
            let velocity = sender.velocityInView(view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            
            if magnitude > ThrowingThreshold {
                // 2
                let pushBehavior = UIPushBehavior(items: [blueSquareView], mode: .Instantaneous)
                pushBehavior.pushDirection = CGVector(dx: velocity.x / 10, dy: velocity.y / 10)
                pushBehavior.magnitude = magnitude / ThrowingVelocityPadding
                
                animator.addBehavior(pushBehavior)
                
                // 3
                let angle = Int(arc4random_uniform(20)) - 10
                
                itemBehavior = UIDynamicItemBehavior(items: [blueSquareView])
                itemBehavior.friction = 0.2
                itemBehavior.allowsRotation = true
                itemBehavior.addAngularVelocity(CGFloat(angle), forItem: blueSquareView)
                animator.addBehavior(itemBehavior)
                
                // 4
                let timeOffset = Int64(0.4 * Double(NSEC_PER_SEC))
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeOffset), dispatch_get_main_queue()) {
                    self.resetDemo()
                }
            } else {
                resetDemo()
            }
            
        default:
            attachmentBehavior.anchorPoint = sender.locationInView(view)
            redSquare.center = attachmentBehavior.anchorPoint
        }
    }
    
    @IBAction func addBehaviorButtonTapped(sender: AnyObject) {
        let gravityBehavior = UIGravityBehavior(items: [blueSquareView])
        animator.addBehavior(gravityBehavior)
        
        let collisionBehavior = UICollisionBehavior(items: [blueSquareView])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)
        
        let dynamicItemBehavior = UIDynamicItemBehavior(items: [blueSquareView])
        dynamicItemBehavior.elasticity = 0.6;
        animator.addBehavior(dynamicItemBehavior)
    }
    
    func resetDemo() {
        animator.removeAllBehaviors()
        
        UIView.animateWithDuration(0.45) {
            self.blueSquareView.bounds = self.originalBounds
            self.blueSquareView.center = self.originalCenter
            self.blueSquareView.transform = CGAffineTransformIdentity
        }
    }
}

