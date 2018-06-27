import PlaygroundSupport
import SpriteKit


public func loadLiveView()
{
    // Load the SKScene from 'GameScene.sks'
    let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 400, height: 400))
    
    if let scene = GameScene(fileNamed: "GameScene") {
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFit
        
        // Present the scene
        sceneView.presentScene(scene)
    }
    
    sceneView.ignoresSiblingOrder = false
    
//    let view = UIView(frame: CGRect(x:0 , y:0, width: 400, height: 400))
//    view.backgroundColor = UIColor.red
    
    PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
}

