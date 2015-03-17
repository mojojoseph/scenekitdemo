//
//  GameViewController.swift
//  scenedemo
//
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    

    let scene = SCNScene()
    
    // Create and add a camera to the scene
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    scene.rootNode.addChildNode(cameraNode)
    
    // Place the camera
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
    
    
    let earthNode      = SCNNode()
    let earthSphere    = SCNSphere(radius: 2.0)
    earthNode.position = SCNVector3(x: 0, y: 0, z: 0)
    earthNode.geometry = earthSphere
    
    //let earthMap = SCNMaterial()
    //earthMap.diffuse.contents = UIImage(named: "art.scnassets/earth.png")

    //earthSphere.materials = [earthMap]
    scene.rootNode.addChildNode(earthNode)

    
    let moonSphere = SCNSphere(radius: 0.55)
    let moonNode = SCNNode(geometry: moonSphere)
//    let moonMap = SCNMaterial()
    moonNode.position = SCNVector3(x: 8, y: 0.0, z: 0.0)
//    moonMap.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")
//    moonSphere.materials = [moonMap]
    scene.rootNode.addChildNode(moonNode)
    
    let ANIMATION = false
    
    if ANIMATION {
      
    let TILT_EARTH_AXIS:Float = -0.4101523742
    
    let earthRotation = CABasicAnimation(keyPath: "eulerAngles")
    earthRotation.fromValue = NSValue(SCNVector3: SCNVector3(x: 0, y: 0, z: TILT_EARTH_AXIS))
    earthRotation.toValue =   NSValue(SCNVector3: SCNVector3(x: 0.0, y: Float(2*M_PI), z:TILT_EARTH_AXIS))
    earthRotation.duration = 5
    earthRotation.repeatCount = .infinity
    earthNode.addAnimation(earthRotation, forKey: "eulerAngles")
    
    let TILT_MOON_AXIS:Float = 0.02617993878
    
    let moonRotation = CABasicAnimation(keyPath: "eulerAngles")
    moonRotation.fromValue = NSValue(SCNVector3: SCNVector3(x: 0, y: 0, z: TILT_MOON_AXIS))
    moonRotation.toValue =   NSValue(SCNVector3: SCNVector3(x: 0.0, y: Float(2*M_PI), z:TILT_MOON_AXIS))
    moonRotation.duration = 3*27
    moonRotation.repeatCount = .infinity
    moonNode.addAnimation(moonRotation, forKey: "eulerAngles")
    
    let moonOrbit = CAKeyframeAnimation(keyPath: "position")
    moonOrbit.values = moonOrbitArray(8)
    moonOrbit.repeatCount = .infinity
    moonOrbit.duration = 27
    moonNode.addAnimation(moonOrbit, forKey: "position")
    }
    
    // retrieve the SCNView
    let scnView = self.view as! SCNView
    
    // set the scene to the view
    scnView.scene = scene
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = true
    
    // show statistics such as fps and timing information
    //    scnView.showsStatistics = true
    
    // configure the view
//    scnView.backgroundColor = UIColor.blackColor()
        scnView.backgroundColor = UIColor.whiteColor()
    
    scnView.autoenablesDefaultLighting = true
    
   }
  
  func moonOrbitArray(xLocation:Double) -> [NSValue] {
    
    var values = [NSValue]()
    let r:Double = xLocation

    for var phi:Double = 0.0; phi < 2*M_PI; phi += 0.19 {
      
      println("phi = \(phi)")
      
      var x = r*cos(phi)
      var y = r*sin(phi)
      var v = NSValue(SCNVector3:SCNVector3Make(Float(x), Float(y), 0))
      
      values.append(v)
      
    }
    
    return values
    
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
