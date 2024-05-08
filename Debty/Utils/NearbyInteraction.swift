//
//  NearbyInteraction.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 05/05/24.
//

import Foundation
import NearbyInteraction

// Setting up the Nearby Interaction session
class NearbyInteractionManager: NSObject {
    private var session: NISession?
    private var sessionDelegate: NISessionDelegate?
    
    override init() {
        super.init()
        sessionDelegate = NearbyInteractionSessionDelegate()
        session = NISession()
        session?.delegate = sessionDelegate
    }
    
    func start() async {
        // Encode discovery token
        if let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: session?.discoveryToken as Any, requiringSecureCoding: true){
            // Set user defaults
            do {
                try await supabase.rpc("update_discovery_token", params: ["new_token": encodedData])
                    .execute()
            } catch {
                print("Error saving discovery token")
            }
            
        }
    }
    func run() async {
        let unarchivedData = try! await supabase.from("devices").select("discovery_token").eq("user_id", value: auth.user().id).execute()
        print(unarchivedData)
        let peerDiscoveryToken = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: unarchivedData as! Data)
        let configuration = NINearbyPeerConfiguration(peerToken: peerDiscoveryToken!)
        session?.run(configuration)
    }
    func stop() {
        session?.invalidate()
    }
}
