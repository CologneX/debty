//
//  Supabase.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 22/04/24.
//

import Supabase
import Foundation
let supabase = SupabaseClient(supabaseURL: URL(string: "https://jocwsnekwhvqvhmunrht.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpvY3dzbmVrd2h2cXZobXVucmh0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM3NzkxOTcsImV4cCI6MjAyOTM1NTE5N30.t8eyONGO70FinVCvog6M59yBUOrc1ohLb_4kG4f-BJc")

let auth = supabase.auth

