//
//  ViewController.swift
//  dynamicAnimatorHack
//
//  Created by Jose Ramon Soto on 2/24/16.
//  Copyright © 2016 Jose Ramon Soto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate
{
    @IBOutlet weak var livesLabel: UILabel!
    
    var paddle = UIView()
    var ball = UIView()
    var brick = UIView()
    var playButton = UIView()
    var myDynamicAnimator = UIDynamicAnimator()
    var myLives = 5
    var collisionBehavior = UICollisionBehavior()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ball = UIView(frame: CGRectMake(view.center.x - 10, view.center.y, 20, 20))
        ball.layer.cornerRadius = 10.25
        ball.clipsToBounds = true
        ball.backgroundColor = UIColor.greenColor()
        view.addSubview(ball)
        
        paddle = UIView(frame: CGRectMake(view.center.x - 40, view.center.y * 1.7, 80, 20))
        paddle.layer.cornerRadius = 5
        paddle.clipsToBounds = true
        paddle.backgroundColor = UIColor.redColor()
        view.addSubview(paddle)
        
        brick = UIView(frame: CGRectMake(view.center.x - 30, 20, 60, 20))
        brick.backgroundColor = UIColor.blueColor()
        view.addSubview(brick)
        
        myDynamicAnimator = UIDynamicAnimator(referenceView: view)
        let ballDynamicBehavior = UIDynamicItemBehavior(items: [ball])
        ballDynamicBehavior.friction = 0.0 //transfer of energy
        ballDynamicBehavior.resistance = 0.0 //deceleration over time
        ballDynamicBehavior.elasticity = 1.16 //bounce factor
        ballDynamicBehavior.allowsRotation = true
        myDynamicAnimator.addBehavior(ballDynamicBehavior)
        
        let paddleDynamicBehavior = UIDynamicItemBehavior(items: [paddle])
        paddleDynamicBehavior.density = 1000
        paddleDynamicBehavior.resistance = 100
        paddleDynamicBehavior.allowsRotation = true
        myDynamicAnimator.addBehavior(ballDynamicBehavior)
        
        let brickDynamicBehavior = UIDynamicItemBehavior(items: [brick])
        brickDynamicBehavior.density = 1000
        brickDynamicBehavior.resistance = 100
        brickDynamicBehavior.allowsRotation = true
        myDynamicAnimator.addBehavior(brickDynamicBehavior)
        
        let pushBehavior = UIPushBehavior(items: [ball], mode: .Instantaneous)
        pushBehavior.angle = 1.1
        pushBehavior.magnitude = 0.2
        myDynamicAnimator.addBehavior(pushBehavior)
        
        collisionBehavior = UICollisionBehavior(items: [ball, paddle, brick])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything
        collisionBehavior.collisionDelegate = self
        myDynamicAnimator.addBehavior(collisionBehavior)
    }

    @IBAction func paddleDragged(sender: UIPanGestureRecognizer)
    {
        let panGesture = sender.locationInView(view).x
        paddle.center.x = panGesture
        myDynamicAnimator.updateItemUsingCurrentState(paddle)
    }
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        if item1.isEqual(brick) && item2.isEqual(ball) || item1.isEqual(ball) && item2.isEqual(brick)
        {
            if brick.backgroundColor == UIColor.blueColor()
            {
                brick.backgroundColor = UIColor.orangeColor()
            }
            else
            {
                brick.hidden = true
                collisionBehavior.removeItem(brick)
                myDynamicAnimator.updateItemUsingCurrentState(brick)
            }
        }
    }
    
    //method for item in boundary
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        if item.isEqual(ball) && p.y > paddle.center.y
        {
            print("lost life")
            myLives--
            if myLives > 0
            {
            livesLabel.text = "lives: \(myLives)"
            ball.center = view.center
            myDynamicAnimator.updateItemUsingCurrentState(ball)
            }
          else
            {
                livesLabel.text = "Game Over!"
                ball.removeFromSuperview()
            }
        }
    }
    @IBAction func playButton(sender: UIButton)
    {
        playButton.hidden = true
        
    }
    
}