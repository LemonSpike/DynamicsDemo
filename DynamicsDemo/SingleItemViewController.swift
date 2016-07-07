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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBlueSquareView()
    }
    
    func addBlueSquareView() {
        let frame = CGRectMake(50, 70, 150, 150)
        blueSquareView.frame = frame
        blueSquareView.backgroundColor = .blueColor()
        view.addSubview(blueSquareView)
    }

    @IBAction func addBehaviorButtonTapped(sender: AnyObject) {
        
    }
}

