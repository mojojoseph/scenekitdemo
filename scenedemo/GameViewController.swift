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
    
    let earthMap = SCNMaterial()
    earthMap.diffuse.contents = UIImage(named: "art.scnassets/earth.png")
    earthSphere.materials = [earthMap]
    scene.rootNode.addChildNode(earthNode)

    
    let moonSphere = SCNSphere(radius: 0.55)
    let moonNode = SCNNode(geometry: moonSphere)
    let moonMap = SCNMaterial()
    moonNode.position = SCNVector3(x: 8, y: 0.0, z: 0.0)
    moonMap.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")
    moonSphere.materials = [moonMap]
    scene.rootNode.addChildNode(moonNode)
    
    let ANIMATION = true
    
    if ANIMATION {
      
      let SECONDS_FOR_EARTH_REVOLUTION:CFTimeInterval = 1
      let TILT_EARTH_AXIS:Float = -0.4101523742
      
      let earthRotation = CABasicAnimation(keyPath: "eulerAngles")
      earthRotation.fromValue = NSValue(SCNVector3: SCNVector3(x: 0, y: 0, z: TILT_EARTH_AXIS))
      earthRotation.toValue =   NSValue(SCNVector3: SCNVector3(x: 0.0, y: Float(2*M_PI), z:TILT_EARTH_AXIS))
      earthRotation.duration    = SECONDS_FOR_EARTH_REVOLUTION
      earthRotation.repeatCount = .infinity
      earthNode.addAnimation(earthRotation, forKey: "eulerAngles")
      
      let TILT_MOON_AXIS:Float = 0.02617993878
      
      let moonRotation = CABasicAnimation(keyPath: "eulerAngles")
      moonRotation.fromValue = NSValue(SCNVector3: SCNVector3(x: 0, y: 0, z: TILT_MOON_AXIS))
      moonRotation.toValue =   NSValue(SCNVector3: SCNVector3(x: 0.0, y: Float(2*M_PI), z:TILT_MOON_AXIS))
      moonRotation.duration = SECONDS_FOR_EARTH_REVOLUTION*27
      moonRotation.repeatCount = .infinity
      moonNode.addAnimation(moonRotation, forKey: "eulerAngles")
      
      let moonOrbit = CAKeyframeAnimation(keyPath: "position")
      moonOrbit.values = moonOrbitArray(8)
      moonOrbit.repeatCount = .infinity
      moonOrbit.duration = SECONDS_FOR_EARTH_REVOLUTION*27
      moonNode.addAnimation(moonOrbit, forKey: "position")
    }
    
    let sat1Sphere = SCNSphere(radius: 0.05)
    sat1Sphere.firstMaterial?.diffuse.contents = UIColor.yellowColor()
    let sat1Node = SCNNode(geometry: sat1Sphere)
    sat1Node.position = SCNVector3(x: 3, y: 0.0, z: 0.0)
    scene.rootNode.addChildNode(sat1Node)
    let o1 = CAKeyframeAnimation(keyPath: "position")
    o1.values = satelliteOrbitArray(radius: 3, phi: 0.52)
    o1.repeatCount = .infinity
    o1.duration = 5
    sat1Node.addAnimation(o1, forKey: "position")

    let sat2Sphere = SCNSphere(radius: 0.05)
    sat2Sphere.firstMaterial?.diffuse.contents = UIColor.yellowColor()

    let sat2Node = SCNNode(geometry: sat2Sphere)
    sat2Node.position = SCNVector3(x: 4, y: 0.0, z: 0.0)
    scene.rootNode.addChildNode(sat2Node)
    let o2 = CAKeyframeAnimation(keyPath: "position")
    o2.values = satelliteOrbitArray(radius: 4, phi: 1.04)
    o2.repeatCount = .infinity
    o2.duration = 10
    sat2Node.addAnimation(o2, forKey: "position")

    let sat3Sphere = SCNSphere(radius: 0.05)
    sat3Sphere.firstMaterial?.diffuse.contents = UIColor.yellowColor()

    let sat3Node = SCNNode(geometry: sat3Sphere)
    sat3Node.position = SCNVector3(x: 5, y: 0.0, z: 0.0)
    scene.rootNode.addChildNode(sat3Node)
    let o3 = CAKeyframeAnimation(keyPath: "position")
    o3.values = satelliteOrbitArray(radius: 5, phi: 1.56)
    o3.repeatCount = .infinity
    o3.duration = 15
    sat3Node.addAnimation(o3, forKey: "position")
    
    let sat4Sphere = SCNSphere(radius: 0.05)
    sat4Sphere.firstMaterial?.diffuse.contents = UIColor.yellowColor()

    let sat4Node = SCNNode(geometry: sat4Sphere)
    sat4Node.position = SCNVector3(x: 5.5, y: 0.0, z: 0.0)
    scene.rootNode.addChildNode(sat4Node)
    let o4 = CAKeyframeAnimation(keyPath: "position")
    o4.values = satelliteOrbitArray(radius: 5.5, phi: 2.09)
    o4.repeatCount = .infinity
    o4.duration = 20
    sat4Node.addAnimation(o4, forKey: "position")

    
    // retrieve the SCNView
    let scnView = self.view as! SCNView
    
    // set the scene to the view
    scnView.scene = scene
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = true
    
    // show statistics such as fps and timing information
    //    scnView.showsStatistics = true
    
    // configure the view
    scnView.backgroundColor = UIColor.blackColor()
    //scnView.backgroundColor = UIColor.whiteColor()
    
    scnView.autoenablesDefaultLighting = true
    
   }
  
  func moonOrbitArray(xLocation:Double) -> [NSValue] {
    var values = [NSValue]()
    let r:Double = xLocation

    for var phi:Double = 0.0; phi < 2*M_PI; phi += 0.19 {
      
      println("phi = \(phi)")
      
      var x = r*cos(phi)
      var z = -r*sin(phi)
      var v = NSValue(SCNVector3:SCNVector3Make(Float(x), 0, Float(z)))
      
      values.append(v)

    }
    
    return values
  }
  
  func satelliteOrbitArray(#radius:Double, phi:Double) -> [NSValue] {
    var values = [NSValue]()
    let r = radius
    for var theta:Double = 0.0; theta < 2*M_PI; theta += 0.19 {
      var x = r*sin(theta)*cos(phi)
      var y = r*sin(theta)*sin(phi)
      var z = r*cos(theta)
      var v = NSValue(SCNVector3:SCNVector3Make(Float(x), Float(y), Float(z)))
      
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
