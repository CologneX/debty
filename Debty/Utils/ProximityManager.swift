//
//  ProximityManager.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 05/05/24.
//
//
//import Supabase
//import CoreLocation
//import AVFoundation
//
//class ProximityManager: NSObject, CLLocationManagerDelegate {
//    let locationManager = CLLocationManager()
//    var synthesizer: AVSpeechSynthesizer?
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        synthesizer = AVSpeechSynthesizer()
//
//        // Listen for proximity notifications
//        
////        supabase.realtime.connect(on: "proximity_notifications")
////            .start { payload in
////                if let notification = payload?.newData {
////                    // Trigger text-to-speech notification
////                    self.speakText("You are in proximity to a borrower.")
////
////                    // Clear the notification record
////                    supabase.from("proximity_notifications")
////                        .delete()
////                        .eq("id", notification["id"])
////                        .execute()
////                }
////            }
//    }
//
//    func speakText(_ text: String) {
//        let utterance = AVSpeechUtterance(string: text)
//        synthesizer?.speak(utterance)
//    }
//
//    private func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) async {
//        guard let location = locations.last else { return }
//        // Update device location in Supabase
//        try await supabase.from("devices")
//            .update([
//                "location": GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            ])
//            .eq("device_id", value: auth.session.user.id)
//            .execute()
//    }
//}
