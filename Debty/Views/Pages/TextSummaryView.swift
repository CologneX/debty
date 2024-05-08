//
//  TextSummaryView.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 07/05/24.
//

import SwiftUI

struct TextSummaryView: View {
    @State var isLoading: Bool = true
    var body: some View {
        NavigationView{
            VStack{ // First VStack to contain VStack Cards
                VStack{ // Date VStack
                    HStack{
                        DatePicker("Start", selection: .constant(Date()),
                                   in: ...Date()
                                   ,displayedComponents: [.date])
                        .datePickerStyle(.compact)
                        
                        DatePicker("End", selection: .constant(Date()),
                                   in: ...Date()
                                   ,displayedComponents: [.date])
                        .datePickerStyle(.compact)
                    }
                    VStack{
                        if (isLoading) {
                            ProgressView()

                        } else {
                            Text("Rp. 500.000")
                                .font(.title)
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity ,maxHeight: .infinity)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 150)
                .background(
                    .regularMaterial,
                    in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                )
                Button("Change"){
                    isLoading.toggle()
                }
            }
            .padding(.horizontal)
            .navigationTitle("Summary")
        }
    }
}

#Preview {
    TextSummaryView()
}
