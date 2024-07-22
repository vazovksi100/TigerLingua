//
//  SpeechSynthesizer.swift
//  TigerLingua
//
//  Created by admin on 7/22/24.
//



import SwiftUI
import AVFoundation

class SpeechSynthesizer: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private var synthesizer = AVSpeechSynthesizer()
    private var currentUtterance: AVSpeechUtterance?
    
    var continuation: CheckedContinuation<(), Never>?

    func speak(_ text: String, rate: Float = 0.5, language: Language) async {

        await withCheckedContinuation { continuation in
            self .continuation = continuation
            if let _ = currentUtterance {
                synthesizer.stopSpeaking(at: .immediate)
                self.currentUtterance = nil
            }
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: language.rawValue)
            utterance.rate = rate
            synthesizer.delegate = self
            synthesizer.speak(utterance)
        }
    }
    
    func speak(_ text: String, rate: Float = 0.5) async {
        
        await withCheckedContinuation { continuation in
            self .continuation = continuation
            if let _ = currentUtterance {
                synthesizer.stopSpeaking(at: .immediate)
                self.currentUtterance = nil
            }
            
            if let language = NSLinguisticTagger.dominantLanguage(for: text) {
                print(language)
                let utterance = AVSpeechUtterance(string: text)
                utterance.voice = AVSpeechSynthesisVoice(language: language)
                utterance.rate = rate
                synthesizer.delegate = self
                synthesizer.speak(utterance)
            } else {
                print("Unknown language")
            }
        }
    }
    
    func stopSpeaking() {
           synthesizer.stopSpeaking(at: .immediate)
           currentUtterance = nil
       }
    

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        currentUtterance = nil

        continuation?.resume()
        continuation = nil
    }
}




