//
//  GameScene.swift
//  MMGame
//
//  Created by Lucas Barros on 19/03/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import SpriteKit
import GameplayKit
import PlaygroundSupport

public class GameScene: SKScene {
    
    var openedQuestion = false
    var started = false
    
    var lastLabelFrameNode:SKNode!
    var selectedNode:SKNode!
    var selectedEquation:SKNode!
    let equations:[String] = ["1-2+7=.png","1+1+1=.png","1+2+3=.png","1+7+2=.png","1+9-3=.png","1x1+2=.png","1x1x1=.png","1x2-1=.png","1x2x3=.png","1x3-1=.png","1x8x1=.png","2-1+3=.png","2x2+5=.png","2x2x2=.png","2x5x2=.png","2x7+3=.png","3-4+8=.png","3+4+5=.png","3x1x5=.png","3x3-2=.png","4-1+9=.png","4x3-1=.png","4x3x2=.png","5-2+4=.png","5x3-7=.png","6-2-1=.png","6+5+4=.png","6x2+3=.png","7-4+1=.png","7+7+7=.png","7x4-9=.png","8-5+2=.png","8+2+1=.png","8x2+1=.png","9-2-3=.png","9+2+7=.png","9+9+1=.png","9x1x2=.png","9x2-7=.png"]
    let equationsResult:[Int] = [6,3,6,10,7,3,1,1,6,2,8,4,9,8,20,17,7,12,15,7,12,11,24,7,8,3,15,15,4,21,19,5,11,17,4,18,19,18,11]
    var randomEquation = 0
    var playerScore = 0
    var playerMultiplier = 1
    public var openPath = ["21","12"]
    var oldCenter:CGPoint?

    
    // User click location
    func touchDown(atPoint pos : CGPoint) {
        
        let touchedNodes = self.nodes(at: pos)
        
        for  node in touchedNodes
        {
            if node.name != nil {
                if(node.name?.contains("button"))!{
                    let itemExists = openPath.contains(where: {
                        $0.range(of: "55", options: .caseInsensitive) != nil
                    })
                    
                    if(node.name == "button_55")&&(itemExists){
                        let scaleUp = SKAction.scale(to: 0.6, duration: 3)
                        let mainView: SKSpriteNode = childNode(withName: "mainView") as! SKSpriteNode
                        let center:CGPoint = mainView.anchorPoint
                        
                        oldCenter = node.position
                        let hopeLabelNode: SKSpriteNode = node.childNode(withName: "hope_label") as! SKSpriteNode
                        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
                        hopeLabelNode.run(fadeIn)
                        
                        let moveCenter = SKAction.move(to: center, duration: 3)
                        let winActionGroup = SKAction.group([scaleUp,moveCenter])
                        node.zPosition = 7
                        node.run(winActionGroup)
                        
                        return
                    }
                    for i in 0..<self.openPath.count{
                        var stringName = "button_"
                        stringName.append(openPath[i])
                        if(node.name! == stringName ){
                            self.randomEquation = Int(arc4random_uniform(UInt32(self.equationsResult.count)))
                            self.selectedPath(node:node)
                        }
                    }
                    
                } else if(node.name?.contains("option"))!{
                    self.selectedOption(node:node)
                } else if(node.name?.contains("congra"))!{
                    
                    // End Game Animation
                    let colorizeOrange = SKAction.colorize(with: SKColor.orange, colorBlendFactor: 0.5 , duration: 1)
                    let colorizeGreen = SKAction.colorize(with: SKColor.green, colorBlendFactor: 1.0, duration: 1)
                    let colorizeRed = SKAction.colorize(with: SKColor.red, colorBlendFactor: 1.0, duration: 1)
                    let colorizeBlue = SKAction.colorize(with: SKColor.blue, colorBlendFactor: 1.0, duration: 1)
                    let colorizePurple = SKAction.colorize(with: SKColor.purple, colorBlendFactor: 1.0, duration: 1)
                    let sequence = SKAction.sequence([colorizeOrange,colorizeGreen,colorizeRed,colorizePurple,colorizeBlue])
                    node.run(sequence)
                } else if(node.name == "reset_Btn"){
                    started = false
                    self.resetGame()
                    self.openPath = ["21","12"]
                    self.view?.layoutIfNeeded()
                }
            }
        }
    }
    
    func makeGreenPath(){
        
        for i in 0..<openPath.count {
            
            if(openPath[i] == "55"){
                continue
            }
            
            let fadeIn = SKAction.fadeIn(withDuration: 1.0)
            
            var stringName = "button_"
            stringName.append(openPath[i])
            if let nodeButton: SKSpriteNode = self.childNode(withName: stringName) as? SKSpriteNode {
                
                (nodeButton).texture = SKTexture(imageNamed: "greenRectangle")
                nodeButton.run(fadeIn)
            }
        }
    }
    
    // LowerBar Click Actions
    func selectedOption(node: SKNode){
        
        // Option animation config
        let scaleUp = SKAction.scale(to: 0.5, duration: 0.6)
        let scaleDown = SKAction.scale(to: 0.55, duration: 0.2)
        
        let scaleSequence = SKAction.sequence([scaleUp,scaleDown])
        let reverseScaleSequence = SKAction.sequence([scaleDown,scaleUp])
        
        let colorize = SKAction.colorize(with: SKColor.green, colorBlendFactor: 1.0, duration: 0.6)
        let reverseColorize = SKAction.colorize(with: SKColor.white, colorBlendFactor: 1.0, duration: 0.6)
        
        let scaleGroup = SKAction.group([scaleSequence,colorize])
        let reverseScaleGroup = SKAction.group([reverseScaleSequence,reverseColorize])
        
        let animation = SKAction.sequence([scaleGroup])
        let reverseAnimation = SKAction.sequence([reverseScaleGroup])
        
        // Buttons animation config
        let scaleUpBtn = SKAction.scale(to: 1, duration: 0.2)
        let scaleDownBtn = SKAction.scale(to: 1.2, duration: 0.1)
        
        // Update layout
        let updateView = SKAction.run {
            self.updateLowerBarView()
        }
        
        let animationBtn = SKAction.sequence([scaleUpBtn,scaleDownBtn,updateView])
        
        
        if((node.name?.contains("option"))!){
            // Answer label options
            if(openedQuestion){
                
                // Remove last selected label frame
                if(node.name?.contains("option"))!{
                    if(lastLabelFrameNode != nil)&&(lastLabelFrameNode != node){
                        lastLabelFrameNode.run(reverseAnimation)
                    }
                    // Selected label frame animation
                    node.run(animation)
                    lastLabelFrameNode = node
                    
                    if(lastLabelFrameNode != nil){
                        
                        let answer_1_label: SKLabelNode = childNode(withName: "answer_1_label") as! SKLabelNode
                        let answer_2_label: SKLabelNode = childNode(withName: "answer_2_label") as! SKLabelNode
                        let answer_3_label: SKLabelNode = childNode(withName: "answer_3_label") as! SKLabelNode
                        let answer_4_label: SKLabelNode = childNode(withName: "answer_4_label") as! SKLabelNode
                        
                        let answerArray = [answer_1_label,answer_2_label,answer_3_label,answer_4_label]
                        
                        let convertIndex:String = String((lastLabelFrameNode.name?.last)!)
                        let selectedIndex = Int(convertIndex)
                        
                        // if correct answer
                        if(answerArray[selectedIndex!-1].text == String(equationsResult[randomEquation])){
                            
                            (selectedNode as! SKSpriteNode).texture = SKTexture(imageNamed: "greenRectangle")
                            
                            let hideNode = SKAction.run {
                                self.selectedNode.isHidden = true
                                self.selectedEquation.isHidden = true
                            }
                            self.openNewPath()
                            
                            self.selectedNode.run(hideNode)
                            
                            if(lastLabelFrameNode != nil)&&(lastLabelFrameNode != node){
                                lastLabelFrameNode.run(reverseAnimation)
                            }
                            
                            openedQuestion = false
                            
                            playerScore = playerScore + (10*playerMultiplier)
                            playerMultiplier += 1
                            
                            node.run(animationBtn)
                            
                        } else { // if wrong answer
                            
                            let colorizeRed = SKAction.colorize(with: SKColor.orange, colorBlendFactor: 0.5 , duration: 0.2)
                            let colorizeWhite = SKAction.colorize(with: SKColor.white, colorBlendFactor: 1.0, duration: 0.1)
                            let sequence = SKAction.sequence([colorizeRed,colorizeWhite])
                            selectedNode.run(sequence)
                            (selectedNode as! SKSpriteNode).texture = SKTexture(imageNamed: "redRectangle2")
                            
                            lastLabelFrameNode.run(reverseAnimation)
                            
                            playerMultiplier = 1
                            
                            node.run(animationBtn)
                        }
                    }
                }
            }
        
        } else if node.name! == "otherQuestion" || node.name! == "answerQuestion" {
            // Select AnswerBtn or OtherBtn
            
            if(openedQuestion){
                
                if(node.name == "otherQuestion"){
                    node.run(animationBtn)
                    openedQuestion = false
                    
                    (selectedNode as! SKSpriteNode).texture = SKTexture(imageNamed: "greenRectangle")
                    
                    if(lastLabelFrameNode != nil)&&(lastLabelFrameNode != node){
                        lastLabelFrameNode.run(reverseAnimation)
                    }
                    
                } else if(node.name == "answerQuestion")&&(lastLabelFrameNode != nil){
                    
                    let answer_1_label: SKLabelNode = childNode(withName: "answer_1_label") as! SKLabelNode
                    let answer_2_label: SKLabelNode = childNode(withName: "answer_2_label") as! SKLabelNode
                    let answer_3_label: SKLabelNode = childNode(withName: "answer_3_label") as! SKLabelNode
                    let answer_4_label: SKLabelNode = childNode(withName: "answer_4_label") as! SKLabelNode
                    
                    let answerArray = [answer_1_label,answer_2_label,answer_3_label,answer_4_label]
                    
                    let convertIndex:String = String((lastLabelFrameNode.name?.last)!)
                    let selectedIndex = Int(convertIndex)
                    
                    // if correct answer
                    if(answerArray[selectedIndex!-1].text == String(equationsResult[randomEquation])){
                        
                        (selectedNode as! SKSpriteNode).texture = SKTexture(imageNamed: "greenRectangle")
                       
                        let hideNode = SKAction.run {
                            self.selectedNode.isHidden = true
                            self.selectedEquation.isHidden = true
                        }
                        self.openNewPath()
                        
                        self.selectedNode.run(hideNode)
                        
                        if(lastLabelFrameNode != nil)&&(lastLabelFrameNode != node){
                            lastLabelFrameNode.run(reverseAnimation)
                        }
                        
                        openedQuestion = false
                        
                        playerScore = playerScore + (10*playerMultiplier)
                        playerMultiplier += 1
                        
                        node.run(animationBtn)
                        
                    } else { // if wrong answer
                        
                        let colorizeRed = SKAction.colorize(with: SKColor.orange, colorBlendFactor: 0.5 , duration: 0.2)
                        let colorizeWhite = SKAction.colorize(with: SKColor.white, colorBlendFactor: 1.0, duration: 0.1)
                        let sequence = SKAction.sequence([colorizeRed,colorizeWhite])
                        selectedNode.run(sequence)
                        (selectedNode as! SKSpriteNode).texture = SKTexture(imageNamed: "redRectangle2")
                        
                        lastLabelFrameNode.run(reverseAnimation)
                        
                        playerMultiplier = 1
                        
                        node.run(animationBtn)
                    }
                }
            }
        }
    }
    
    func selectedPath(node: SKNode){
        
        // click animation
        let scaleUp = SKAction.scale(to: 0.9, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1, duration: 0.1)
        let scaleSequence = SKAction.sequence([scaleUp,scaleDown])
        
        // click Apear Equation animation
        let changeNodeLabel = SKAction.run {
            let reverseColorize = SKAction.colorize(with: SKColor.white, colorBlendFactor: 1.0, duration: 0.6)
            if(self.lastLabelFrameNode != nil){
                self.lastLabelFrameNode.run(reverseColorize)
            }
            
            let fadeIn = SKAction.fadeIn(withDuration: 1.0)
            let nodeNumber = String(node.name!.suffix(2))
            if(nodeNumber == "55"){
                return
            }
            
            var stringName = "equasion_"
            stringName.append(nodeNumber)
            let nodeLabel: SKSpriteNode = self.childNode(withName: stringName) as! SKSpriteNode
            nodeLabel.zPosition = 6
            
            
            (nodeLabel ).texture = SKTexture(imageNamed: self.equations[self.randomEquation])
            nodeLabel.run(fadeIn)
            self.selectedEquation = nodeLabel
        }
        
        // Animate Selected Equation
        let changeNodeImage = SKAction.run {
            (node as! SKSpriteNode).texture = SKTexture(imageNamed: "purpleRectangle2")
            node.zPosition = 5
        }
        
        // Animate Apear LowerBar
        let updateView = SKAction.run {
            self.updateLowerBarView()
        }
        
        // Group open Equation animation
        let scaleGroup = SKAction.group([scaleSequence,changeNodeImage,changeNodeLabel])
        
        // Animate open Equation
        let animation = SKAction.sequence([scaleGroup,updateView])
        
        // Run animation
        if(node.name?.contains("button"))!{
            
//            if(!openedQuestion){
                node.run(animation)
                
                // Change status to opened equation
                openedQuestion = true
            
            if(selectedNode != nil)&&(node.name! != selectedNode.name){
                self.makeGreenPath()
            }
            
                // Save last node
                selectedNode = node
//            }
            
        }
        
    }
    
    func updateLowerBarView(){
        let otherQuestion: SKSpriteNode = childNode(withName: "otherQuestion") as! SKSpriteNode
        let answerQuestion: SKSpriteNode = childNode(withName: "answerQuestion") as! SKSpriteNode
        let equationLowBarLabel: SKSpriteNode = childNode(withName: "selectedEquation") as! SKSpriteNode
        let equationPlaceholder: SKSpriteNode = childNode(withName: "equationPlaceholder") as! SKSpriteNode
        
        let option_1: SKSpriteNode = childNode(withName: "option_1") as! SKSpriteNode
        let option_2: SKSpriteNode = childNode(withName: "option_2") as! SKSpriteNode
        let option_3: SKSpriteNode = childNode(withName: "option_3") as! SKSpriteNode
        let option_4: SKSpriteNode = childNode(withName: "option_4") as! SKSpriteNode
        
        let answer_1_label: SKLabelNode = childNode(withName: "answer_1_label") as! SKLabelNode
        let answer_2_label: SKLabelNode = childNode(withName: "answer_2_label") as! SKLabelNode
        let answer_3_label: SKLabelNode = childNode(withName: "answer_3_label") as! SKLabelNode
        let answer_4_label: SKLabelNode = childNode(withName: "answer_4_label") as! SKLabelNode
        
        let multipliyer_label: SKLabelNode = childNode(withName: "multipliyer_label") as! SKLabelNode
        let score_label: SKLabelNode = childNode(withName: "score_label") as! SKLabelNode
        multipliyer_label.text = String(playerMultiplier)
        score_label.text = String(playerScore)
        
        let fadeIn = SKAction.fadeIn(withDuration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        
        if(openedQuestion){
            
            equationLowBarLabel.run(fadeIn)
            otherQuestion.run(fadeIn)
            answerQuestion.run(fadeIn)
            equationPlaceholder.run(fadeIn)
            
            option_1.run(fadeIn)
            option_2.run(fadeIn)
            option_3.run(fadeIn)
            option_4.run(fadeIn)
            
            answer_1_label.run(fadeIn)
            answer_2_label.run(fadeIn)
            answer_3_label.run(fadeIn)
            answer_4_label.run(fadeIn)
            
            let answerArray = [answer_1_label,answer_2_label,answer_3_label,answer_4_label]
            setupRandomAnwsers(answerArray: answerArray, equation: self.randomEquation)
            
            // Rename Equation
            (equationLowBarLabel ).texture = SKTexture(imageNamed: self.equations[self.randomEquation])
            
        } else {
            // updade new green paths
            self.makeGreenPath()
            
            otherQuestion.run(fadeOut)
            answerQuestion.run(fadeOut)
            equationLowBarLabel.run(fadeOut)
            equationPlaceholder.run(fadeOut)
            
            option_1.run(fadeOut)
            option_2.run(fadeOut)
            option_3.run(fadeOut)
            option_4.run(fadeOut)
            
            answer_1_label.run(fadeOut)
            answer_2_label.run(fadeOut)
            answer_3_label.run(fadeOut)
            answer_4_label.run(fadeOut)
        }
    }
    
    func setupRandomAnwsers(answerArray:[SKLabelNode], equation: Int) {
        
        // Create array with random number for answers
        var randomAnswers = [(Int(arc4random_uniform(UInt32(equationsResult[equation])))*(Int(arc4random_uniform(4)+1))),
                             (Int(arc4random_uniform(UInt32(equationsResult[equation])))*(Int(arc4random_uniform(4)+1))),
                             (Int(arc4random_uniform(UInt32(equationsResult[equation])))*(Int(arc4random_uniform(4)+1))),
                             (Int(arc4random_uniform(UInt32(equationsResult[equation])))*(Int(arc4random_uniform(4)+1)))]
        
        // if has repeted answer them re-random number
        if(!randomAnswers.contains(equationsResult[equation])){
            randomAnswers[Int(arc4random_uniform(4))] = equationsResult[equation]
        }
        
        // Check if number is equal to other, if so re-random number
        for i in 0..<answerArray.count {
            for j in 0..<answerArray.count {
                if(randomAnswers[i] == randomAnswers[j])&&(i != j) {
                    randomAnswers[i] = (Int(arc4random_uniform(UInt32(equationsResult[equation])))*(Int(arc4random_uniform(4))))
                }
            }
            answerArray[i].text = String(randomAnswers[i])
        }
    }
    
    // initial config in view
    func setupView(){
        let equationLowBarLabel: SKSpriteNode = childNode(withName: "selectedEquation") as! SKSpriteNode
        let otherQuestion: SKSpriteNode = childNode(withName: "otherQuestion") as! SKSpriteNode
        let answerQuestion: SKSpriteNode = childNode(withName: "answerQuestion") as! SKSpriteNode
        let equationPlaceholder: SKSpriteNode = childNode(withName: "equationPlaceholder") as! SKSpriteNode
        let button_55: SKSpriteNode = childNode(withName: "button_55") as! SKSpriteNode
        let hopeLabelNode: SKSpriteNode = button_55.childNode(withName: "hope_label") as! SKSpriteNode
        
        let option_1: SKSpriteNode = childNode(withName: "option_1") as! SKSpriteNode
        let option_2: SKSpriteNode = childNode(withName: "option_2") as! SKSpriteNode
        let option_3: SKSpriteNode = childNode(withName: "option_3") as! SKSpriteNode
        let option_4: SKSpriteNode = childNode(withName: "option_4") as! SKSpriteNode
        
        let multipliyer_label: SKLabelNode = childNode(withName: "multipliyer_label") as! SKLabelNode
        let score_label: SKLabelNode = childNode(withName: "score_label") as! SKLabelNode
        
        let answer_1_label: SKLabelNode = childNode(withName: "answer_1_label") as! SKLabelNode
        let answer_2_label: SKLabelNode = childNode(withName: "answer_2_label") as! SKLabelNode
        let answer_3_label: SKLabelNode = childNode(withName: "answer_3_label") as! SKLabelNode
        let answer_4_label: SKLabelNode = childNode(withName: "answer_4_label") as! SKLabelNode
        
        let equasion_12: SKSpriteNode = childNode(withName: "equasion_12") as! SKSpriteNode
        let equasion_13: SKSpriteNode = childNode(withName: "equasion_13") as! SKSpriteNode
        let equasion_14: SKSpriteNode = childNode(withName: "equasion_14") as! SKSpriteNode
        let equasion_15: SKSpriteNode = childNode(withName: "equasion_15") as! SKSpriteNode
        
        let equasion_21: SKSpriteNode = childNode(withName: "equasion_21") as! SKSpriteNode
        let equasion_22: SKSpriteNode = childNode(withName: "equasion_22") as! SKSpriteNode
        let equasion_23: SKSpriteNode = childNode(withName: "equasion_23") as! SKSpriteNode
        let equasion_24: SKSpriteNode = childNode(withName: "equasion_24") as! SKSpriteNode
        let equasion_25: SKSpriteNode = childNode(withName: "equasion_25") as! SKSpriteNode
        
        let equasion_31: SKSpriteNode = childNode(withName: "equasion_31") as! SKSpriteNode
        let equasion_32: SKSpriteNode = childNode(withName: "equasion_32") as! SKSpriteNode
        let equasion_33: SKSpriteNode = childNode(withName: "equasion_33") as! SKSpriteNode
        let equasion_34: SKSpriteNode = childNode(withName: "equasion_34") as! SKSpriteNode
        let equasion_35: SKSpriteNode = childNode(withName: "equasion_35") as! SKSpriteNode
        
        let equasion_41: SKSpriteNode = childNode(withName: "equasion_41") as! SKSpriteNode
        let equasion_42: SKSpriteNode = childNode(withName: "equasion_42") as! SKSpriteNode
        let equasion_43: SKSpriteNode = childNode(withName: "equasion_43") as! SKSpriteNode
        let equasion_44: SKSpriteNode = childNode(withName: "equasion_44") as! SKSpriteNode
        let equasion_45: SKSpriteNode = childNode(withName: "equasion_45") as! SKSpriteNode
        
        let equasion_51: SKSpriteNode = childNode(withName: "equasion_51") as! SKSpriteNode
        let equasion_52: SKSpriteNode = childNode(withName: "equasion_52") as! SKSpriteNode
        let equasion_53: SKSpriteNode = childNode(withName: "equasion_53") as! SKSpriteNode
        let equasion_54: SKSpriteNode = childNode(withName: "equasion_54") as! SKSpriteNode
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.01)
        
        if(!started){
            otherQuestion.isHidden = true
            answerQuestion.isHidden = true
            equationPlaceholder.run(fadeOut)
            hopeLabelNode.run(fadeOut)
            
            multipliyer_label.text = String(playerMultiplier)
            score_label.text = String(playerScore)
            
            otherQuestion.run(fadeOut)
            answerQuestion.run(fadeOut)
            equationLowBarLabel.run(fadeOut)
            
            option_1.run(fadeOut)
            option_2.run(fadeOut)
            option_3.run(fadeOut)
            option_4.run(fadeOut)
            
            answer_1_label.run(fadeOut)
            answer_2_label.run(fadeOut)
            answer_3_label.run(fadeOut)
            answer_4_label.run(fadeOut)
            
            equasion_12.run(fadeOut)
            equasion_13.run(fadeOut)
            equasion_14.run(fadeOut)
            equasion_15.run(fadeOut)
            
            equasion_21.run(fadeOut)
            equasion_22.run(fadeOut)
            equasion_23.run(fadeOut)
            equasion_24.run(fadeOut)
            equasion_25.run(fadeOut)
            
            equasion_31.run(fadeOut)
            equasion_32.run(fadeOut)
            equasion_33.run(fadeOut)
            equasion_34.run(fadeOut)
            equasion_35.run(fadeOut)
            
            equasion_41.run(fadeOut)
            equasion_42.run(fadeOut)
            equasion_43.run(fadeOut)
            equasion_44.run(fadeOut)
            equasion_45.run(fadeOut)
            
            equasion_51.run(fadeOut)
            equasion_52.run(fadeOut)
            equasion_53.run(fadeOut)
            equasion_54.run(fadeOut)
            
            started = true
            
            // updade new green paths
            self.makeGreenPath()
        }
    }
    
    func resetGame(){
        for i in 1...5 {
            for j in  1...5{
                var buttonNodeName = "button_"
                var equationNodeName = "equasion_"
                var buttonIndex = ""
                
                buttonIndex.append(String(i))
                buttonIndex.append(String(j))
                buttonNodeName.append(buttonIndex)
                equationNodeName.append(buttonIndex)
                
                let fadeOut = SKAction.fadeOut(withDuration: 0.01)
                
                
                if(buttonNodeName != "button_11")&&(buttonNodeName != "button_55"){
                    
                    let equationNode: SKSpriteNode = childNode(withName: equationNodeName) as! SKSpriteNode
                    let buttonNode: SKSpriteNode = childNode(withName: buttonNodeName) as! SKSpriteNode
                    
                    let itemExists = openPath.contains(where: {
                        $0.range(of: buttonIndex, options: .caseInsensitive) != nil
                    })
                    if(itemExists){
                        (buttonNode ).texture = SKTexture(imageNamed: "whiteRectangle")
                    }
                    
                    playerMultiplier = 1
                    playerScore = 0
                    buttonNode.isHidden = false
                    equationNode.isHidden = false
                    equationNode.run(fadeOut)
                    
                    let reverseColorize = SKAction.colorize(with: SKColor.white, colorBlendFactor: 1.0, duration: 0.6)
                    if(lastLabelFrameNode != nil){
                        lastLabelFrameNode.run(reverseColorize)
                    }
                } else if(buttonNodeName == "button_55"){
                    let buttonNode: SKSpriteNode = childNode(withName: buttonNodeName) as! SKSpriteNode

                    let scaleDown = SKAction.scale(to: 0.1, duration: 1)
                    let moveBack = SKAction.move(to: self.oldCenter!, duration: 1)
                    let resetGroup = SKAction.group([scaleDown,moveBack])
                    buttonNode.run(resetGroup)

                    let hopeLabelNode = buttonNode.childNode(withName: "hope_label") as! SKSpriteNode
                    hopeLabelNode.run(fadeOut)

                }
            }
        }
    }
    
    
    public override func didMove(to view: SKView) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        self.setupView()
    }

    func openNewPath(){
        
        let nodeNumber = Int(String(self.selectedNode.name!.suffix(2)))
        
        var leftPath:String = ""
        var rightPath:String = ""
        var upPath:String = ""
        var downPath:String = ""
        
        switch (nodeNumber!) {
        case 12:
            rightPath = String(nodeNumber!+1)
            downPath = String(nodeNumber!+10)
        case 13:
            rightPath = String(nodeNumber!+1)
        case 14:
            // DeadEnd
            playerScore += playerMultiplier * 10
            playerMultiplier += 5
        case 15:
            // DeadEnd
            playerScore += playerMultiplier * 10
            playerMultiplier += 5
        case 21:
            rightPath = String(nodeNumber!+1)
        case 22:
            rightPath = String(nodeNumber!+1)
            downPath = String(nodeNumber!+10)
        case 23:
            leftPath = String(nodeNumber!-1)
            rightPath = String(nodeNumber!+1)
            downPath = String(nodeNumber!+10)
        case 24:
            rightPath = String(nodeNumber!+1)
        case 25:
            upPath = String(nodeNumber!-10)
        case 31:
            // DeadEnd
            playerScore += playerMultiplier * 10
            playerMultiplier += 5
        case 32:
            upPath = String(nodeNumber!-10)
            downPath = String(nodeNumber!+10)
        case 33:
            rightPath = String(nodeNumber!+1)
            upPath = String(nodeNumber!-10)
        case 34:
            leftPath = String(nodeNumber!-1)
            rightPath = String(nodeNumber!+1)
            downPath = String(nodeNumber!+10)
        case 35:
            leftPath = String(nodeNumber!-1)
            downPath = String(nodeNumber!+10)
        case 41:
            rightPath = String(nodeNumber!+1)
            upPath = String(nodeNumber!-10)
            downPath = String(nodeNumber!+10)
        case 42:
            leftPath = String(nodeNumber!-1)
            rightPath = String(nodeNumber!+1)
            upPath = String(nodeNumber!-10)
        case 43:
            leftPath = String(nodeNumber!-1)
            rightPath = String(nodeNumber!+1)
            downPath = String(nodeNumber!+10)
        case 44:
            leftPath = String(nodeNumber!-1)
            upPath = String(nodeNumber!-10)
        case 45:
            upPath = String(nodeNumber!-10)
            downPath = String(nodeNumber!+10)
        case 51:
            rightPath = String(nodeNumber!+1)
            upPath = String(nodeNumber!-10)
        case 52:
            // DeadEnd
            playerScore += playerMultiplier * 10
            playerMultiplier += 5
        case 53:
            rightPath = String(nodeNumber!+1)
            upPath = String(nodeNumber!-10)
        case 54:
            leftPath = String(nodeNumber!-1)
            rightPath = String(nodeNumber!+1)
        default:
            print(nodeNumber!)
        }
        
        self.openPath.append(leftPath)
        self.openPath.append(rightPath)
        self.openPath.append(upPath)
        self.openPath.append(downPath)
        
    }
}
