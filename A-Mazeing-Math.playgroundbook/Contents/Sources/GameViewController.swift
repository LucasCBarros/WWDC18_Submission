//
//  GameViewController.swift
//  MMGame
//
//  Created by Lucas Barros on 19/03/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//
//
//import UIKit
//import SpriteKit
//import GameplayKit
//
//public class GameViewController: UIViewController {
//
//    override public func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Load the SKScene from 'GameScene.sks'
//        let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 600 , height: 600))
//        
//        self.view = sceneView
//        
////        if let sceneView = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = GameScene(fileNamed: "GameScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFit
//
//                // Present the scene
//                sceneView.presentScene(scene)
//            }
//            
////            sceneView.ignoresSiblingOrder = false
//
////            view.showsFPS = true
////            view.showsNodeCount = true
////        }
//    }
//
//    override public var shouldAutorotate: Bool {
//        return true
//    }
//
//    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }
//
//    override  public func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Release any cached data, images, etc that aren't in use.
//    }
//
//    override public var prefersStatusBarHidden: Bool {
//        return true
//    }
//}

