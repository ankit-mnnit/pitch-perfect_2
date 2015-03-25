//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ankit Garg on 17/03/15.
//  Copyright (c) 2015 Ankit Garg. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var player : AVAudioPlayer! = nil
    
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    
    var receivedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        player.enableRate = true
        audioEngine = AVAudioEngine()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func reallySlowAudio(sender: UIButton) {
        playWithSpeed(0.5)
        
    }

    @IBAction func reallyFastAudio(sender: UIButton) {
        playWithSpeed(2.0)
    }
    
    func playWithSpeed(rate: Float) {
        audioEngine.stop()
        player.stop()
        player.currentTime = 0.0
        player.rate = rate
        player.play()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        player.stop()
        audioEngine.stop()
        
    }
    
    @IBAction func applyChipmunkEffect(sender: UIButton) {
        audioEngine.stop()
        playSoundWithPitch(1000)
        
        
    }
    
    
    @IBAction func applyDarthVaderEffect(sender: UIButton) {
        audioEngine.stop()
        playSoundWithPitch(-1000)
    }
    
    
    func playSoundWithPitch(pitch: Float) {
        player.stop()
        audioEngine.stop()
        
        var playerNode = AVAudioPlayerNode()
        audioEngine.attachNode(playerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(playerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        // Play the file
        playerNode.play()
    }
    
}
