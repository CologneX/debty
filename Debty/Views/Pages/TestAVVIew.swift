//
//  TestAVVIew.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 02/05/24.
//

import SwiftUI
import AVFoundation
struct TestAVVIew: View {
    let speechSynthesizer = AVSpeechSynthesizer()
    var body: some View {
        NavigationStack{
            Button("Speak"){
                let utterance = AVSpeechUtterance(string: "Cieee, ada yang berhutang didekatmu")
                utterance.pitchMultiplier = 1.0
                utterance.rate = 0.5
                utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
                speechSynthesizer.speak(utterance)
            }
            .navigationTitle("AV")
        }
    }
}

#Preview {
    TestAVVIew()
}
