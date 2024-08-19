//
//  SpeechRecognizerManager.swift
//  SpeechToDoList
//
//  Created by Дмитрий on 19.08.2024.
//

import UIKit
import Speech

final class SpeechRecognizerManager {

//MARK: - Initializers
    private init() {}
    
//MARK: - Properties

    static let shared = SpeechRecognizerManager()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
//MARK: - Functions
    
    func requestSpeechAuthorization(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    completion(true)
                case .denied, .restricted, .notDetermined:
                    completion(false)
                @unknown default:
                    fatalError("Unknown auth status")
                }
            }
        }
    }
    
    func startRecording(onResult: @escaping (String) -> Void) {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("AudioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        let inputNode = audioEngine.inputNode
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                let text = result.bestTranscription.formattedString
                onResult(text)
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
    
    func isRecording() -> Bool {
        audioEngine.isRunning
    }
}
