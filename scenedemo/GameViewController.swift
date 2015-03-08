//
//  GameViewController.swift
//  scenedemo
//
//  Created by Joseph Bell on 3/6/15.
//  Copyright (c) 2015 iAchieved.it, LLC. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let PhysicsCategorySphere = 1 << 0

    // create a new scene
    let scene = SCNScene() //named: "art.scnassets/ship.dae")!
    
    // create and add a camera to the scene
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    scene.rootNode.addChildNode(cameraNode)
    
    // place the camera
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
    
    scene.physicsWorld.gravity = SCNVector3(x: 0, y: 0, z: 0)
    
    
    // create and add a light to the scene
    /*
    let lightNode = SCNNode()
    lightNode.light = SCNLight()
    lightNode.light!.type = SCNLightTypeOmni
    lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
    scene.rootNode.addChildNode(lightNode)
    */
    
    /*
    // create and add an ambient light to the scene
    let ambientLightNode = SCNNode()
    ambientLightNode.light = SCNLight()
    ambientLightNode.light!.type = SCNLightTypeAmbient
    ambientLightNode.light!.color = UIColor.darkGrayColor()
    scene.rootNode.addChildNode(ambientLightNode)
    */
    

    
    
    let ematerial = SCNMaterial()
    ematerial.diffuse.contents = UIImage(named: "art.scnassets/earth.png")
    
    
    let earthNode = SCNNode()
    let sphere = SCNSphere(radius: 2.0)
    earthNode.position = SCNVector3(x: 0, y: 0, z: 0)
    earthNode.geometry = sphere
    earthNode.physicsBody = SCNPhysicsBody.dynamicBody()
    earthNode.physicsBody?.mass = 5.972
    sphere.materials = [ematerial]
    scene.rootNode.addChildNode(earthNode)
    
    let moonMap = SCNMaterial()
    moonMap.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")
    
    let moonSphere = SCNSphere(radius: 0.55)
    let moonNode = SCNNode(geometry: moonSphere)
    moonNode.position = SCNVector3(x: 20.0, y: 0.0, z: 0.0)
    moonNode.physicsBody = SCNPhysicsBody.dynamicBody()
    moonNode.physicsBody?.mass = 5.972/160
    moonNode.physicsBody?.velocity = SCNVector3(x: 0, y: 4, z: 0)

    moonSphere.materials = [moonMap]
    scene.rootNode.addChildNode(moonNode)
    
    let TILT_EARTH_AXIS:Float = 0.4101523742
    
    let earthRotation = CABasicAnimation(keyPath: "eulerAngles")
    earthRotation.fromValue = NSValue(SCNVector3: SCNVector3(x: 0, y: 0, z: TILT_EARTH_AXIS))
    earthRotation.toValue =   NSValue(SCNVector3: SCNVector3(x: 0.0, y: Float(2*M_PI), z:TILT_EARTH_AXIS))
    earthRotation.duration = 3
    earthRotation.repeatCount = .infinity
    earthNode.addAnimation(earthRotation, forKey: "eulerAngles")
    
    let TILT_MOON_AXIS:Float = 0.02617993878
    
    let moonRotation = CABasicAnimation(keyPath: "eulerAngles")
    moonRotation.fromValue = NSValue(SCNVector3: SCNVector3(x: 0, y: 0, z: TILT_MOON_AXIS))
    moonRotation.toValue =   NSValue(SCNVector3: SCNVector3(x: 0.0, y: Float(2*M_PI), z:TILT_MOON_AXIS))
    moonRotation.duration = 3*27
    moonRotation.repeatCount = .infinity
    moonNode.addAnimation(moonRotation, forKey: "eulerAngles")
    
    let earthsGravity = SCNPhysicsField.radialGravityField()
    earthsGravity.categoryBitMask = 1
    earthsGravity.strength = 9.8
    earthNode.physicsField = earthsGravity


    let moonsGravity = SCNPhysicsField.radialGravityField()
    moonsGravity.strength = 1.62519
    moonNode.physicsField = moonsGravity
    
    // retrieve the SCNView
    let scnView = self.view as! SCNView
    
    // set the scene to the view
    scnView.scene = scene
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = true
    
    // show statistics such as fps and timing information
    scnView.showsStatistics = true
    
    // configure the view
    scnView.backgroundColor = UIColor.blackColor()
    
    scnView.autoenablesDefaultLighting = true
    
   }
  
//  func
  
  func handleTap(gestureRecognize: UIGestureRecognizer) {
    // retrieve the SCNView
    let scnView = self.view as! SCNView
    
    // check what nodes are tapped
    let p = gestureRecognize.locationInView(scnView)
    if let hitResults = scnView.hitTest(p, options: nil) {
      // check that we clicked on at least one object
      if hitResults.count > 0 {
        // retrieved the first clicked object
        let result: AnyObject! = hitResults[0]
        
        // get its material
        let material = result.node!.geometry!.firstMaterial!
        
        // highlight it
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(0.5)
        
        // on completion - unhighlight
        SCNTransaction.setCompletionBlock {
          SCNTransaction.begin()
          SCNTransaction.setAnimationDuration(0.5)
          
          material.emission.contents = UIColor.blackColor()
          
          SCNTransaction.commit()
        }
        
        material.emission.contents = UIColor.redColor()
        
        SCNTransaction.commit()
      }
    }
  }
  
  override func shouldAutorotate() -> Bool {
    return true
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  override func supportedInterfaceOrientations() -> Int {
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
      return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    } else {
      return Int(UIInterfaceOrientationMask.All.rawValue)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
}
