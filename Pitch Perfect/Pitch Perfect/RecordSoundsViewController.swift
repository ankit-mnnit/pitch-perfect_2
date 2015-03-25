//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ankit Garg on 17/03/15.
//  Copyright (c) 2015 Ankit Garg. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    
    override func viewWillAppear(animated: Bool) {
        stopRecordingButton.hidden = true
        recordingInProgress.hidden = false
        recordingInProgress.text = "Tap to record"
    }

    @IBAction func recordAudioTapped(sender: UIButton) {

            recordingInProgress.hidden = false
            recordButton.enabled = false
            stopRecordingButton.hidden = false
        
            recordingInProgress.text = "recording in progress..."
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
            
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()

    }

    @IBAction func stopRecordingTapped(sender: UIButton) {
        
        recordButton.enabled = true
        recordingInProgress.hidden = true
        stopRecordingButton.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(pathURL: recorder.url, fileTitle: recorder.url.lastPathComponent)
            
            self.performSegueWithIdentifier("stopRecordingTapped", sender: recordedAudio)
            
        } else {
            println("The audio didn't record successfully")
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecordingTapped") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio!
            playSoundsVC.receivedAudio = data;
            
        }
    }
    
    
}

