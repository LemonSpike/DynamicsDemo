//
//  MultipleItemsViewController.swift
//  DynamicsDemo
//
//  Created by Hesham Abd-Elmegid on 6/23/16.
//  Copyright © 2016 CareerFoundy. All rights reserved.
//

import UIKit

class MultipleItemsViewController: UIViewController {
    
    let gravityBehavior = UIGravityBehavior()
    let collisionBehavior = UICollisionBehavior()
    let dynamicItemBehavior = UIDynamicItemBehavior()
    var snapBehavior1: UISnapBehavior!
    var snapBehavior2: UISnapBehavior!
    var snapBehavior3: UISnapBehavior!
    lazy var animator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self.view)
    }()
    
    @IBOutlet var boxCollection: [UIView]!
    
    @IBAction func addViewButtonTapped(sender: AnyObject) {
        let squareView = createView()
        view.addSubview(squareView)
        addDynamicBehaviorsToView(squareView)
    }
    
    override func viewWillAppear(animated: Bool) {
        //        self.view.translatesAutoresizingMaskIntoConstraints = false
        //        for item in boxCollection {
        //            item.superview?.translatesAutoresizingMaskIntoConstraints=false
        //            item.translatesAutoresizingMaskIntoConstraints=false
        //            self.view.setNeedsLayout()
        //        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator.addBehavior(gravityBehavior)
        
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)
        
        dynamicItemBehavior.elasticity = 0.6;
        animator.addBehavior(dynamicItemBehavior)
        
        for item in boxCollection {
            collisionBehavior.addItem(item)
        }
        
        
        snapBehavior1=UISnapBehavior(item: boxCollection[0], snapToPoint: boxCollection[0].center)
        snapBehavior2=UISnapBehavior(item: boxCollection[1], snapToPoint: boxCollection[1].center)
        snapBehavior3=UISnapBehavior(item: boxCollection[2], snapToPoint: boxCollection[2].center)
        animator.addBehavior(snapBehavior1)
        animator.addBehavior(snapBehavior2)
        animator.addBehavior(snapBehavior3)
        
    }
    
    func createView() -> UIView {
        let x = randomNumber(0, max: view.bounds.width)
        let frame = CGRectMake(CGFloat(x), 0, 40, 40)
        let squareView = UIView(frame: frame)
        squareView.backgroundColor = randomColor()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MultipleItemsViewController.squareViewTapped(_:)))
        squareView.addGestureRecognizer(tapGestureRecognizer)
        return squareView
    }
    
    func randomNumber(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max) * (max - min) + min
    }
    
    func randomColor() -> UIColor {
        return UIColor(red: randomNumber(0, max: 1), green: randomNumber(0, max: 1), blue: randomNumber(0, max: 1), alpha: 1)
    }
    
    func addDynamicBehaviorsToView(view: UIView) {
        gravityBehavior.addItem(view)
        collisionBehavior.addItem(view)
        dynamicItemBehavior.addItem(view)
    }
    
    func squareViewTapped(gestureRecognizer: UITapGestureRecognizer) {
        if let view = gestureRecognizer.view {
            let pushBehavior = UIPushBehavior(items: [view], mode: .Instantaneous)
            pushBehavior.pushDirection = CGVectorMake(randomNumber(-4, max: 4), randomNumber(-4, max: 4))
            animator.addBehavior(pushBehavior)
        }
    }
}
