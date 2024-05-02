//
//  SummaryView.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 29/04/24.
//

import SwiftUI

struct SummaryView: View {
    @Binding var profile: ProfileViewModel
    @State var summaryModel: SummaryViewModel = SummaryViewModel()
    @State private var profileSheet: Bool = false
    @State private var filterDateLending: Date = Date()
    @State private var filterDateDebt: Date = Date()
    @State private var isLoadingLending: Bool = false
    @State private var isLoadingDebt: Bool = false
    @Binding var isAuthenticated: Bool?
    @Binding var isLoginScreenPresented: Bool
    var body: some View {
        NavigationStack{
            VStack{
                if isAuthenticated == false {
                    ContentUnavailableView {
                        Label("You are not authenticated!", systemImage: "xmark")
                    } description: {
                        Text("Log in first to access our services")
                        Button("Login") {
                            isLoginScreenPresented.toggle()
                        }
                    }
                } else {
                    VStack{
                        Text("Total Lending")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if (isLoadingLending) {
                            ProgressView()
                        } else {
                            Text(summaryModel.lendingSummary ?? 0, format: .currency(code: "IDR"))
                                .font(.title)
                                .bold()
                                .padding(.bottom, 8)
                            HStack(alignment: .bottom){
                                DatePicker("", selection: $filterDateLending,
                                           in: ...Date()
                                           ,displayedComponents: [.date])
                                .datePickerStyle(.compact)
                                .onChange(of: filterDateLending, {
                                    Task{
                                        isLoadingLending = true
                                        do {
                                            try await summaryModel.getLendingSummary(filterDate: filterDateLending)
                                            isLoadingLending = false
                                        }
                                        catch{
                                            isLoadingLending = false
                                        }
                                    }
                                })
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 150)
                    .padding()
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                    )
                    .task{
                        isLoadingLending = true
                        do {
                            try await summaryModel.getLendingSummary(filterDate: filterDateDebt)
                            isLoadingLending = false
                        }
                        catch{
                            isLoadingLending = false
                        }
                    }
                    VStack{
                        HStack(alignment: .top){
                            Text("Total Debt")
                                .font(.title2)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        if (isLoadingDebt) {
                            HStack(alignment: .center){
                                ProgressView()
                            }
                        } else {
                            Text(summaryModel.debtSummary ?? 0, format: .currency(code: "IDR"))
                                .font(.title)
                                .bold()
                                .padding(.bottom, 8)
                            Spacer()
                            HStack(alignment: .bottom){
                                DatePicker("", selection: $filterDateDebt,
                                           in: ...Date()
                                           ,displayedComponents: [.date])
                                .datePickerStyle(.compact)
                                .onChange(of: filterDateDebt, {
                                    Task{
                                        isLoadingDebt = true
                                        do {
                                            try await summaryModel.getBorrowingSummary(filterDate: filterDateDebt)
                                            isLoadingDebt = false
                                        }
                                        catch{
                                            isLoadingDebt = false
                                        }
                                    }
                                })
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 150)
                    .padding()
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                    )
                    .task{
                        isLoadingDebt = true
                        do {
                            try await summaryModel.getBorrowingSummary(filterDate: filterDateDebt)
                            isLoadingDebt = false
                        }
                        catch{
                            isLoadingDebt = false
                        }
                    }
                    .sheet(isPresented: $profileSheet){
                        ProfileView(profile: $profile, isLoginScreenPresented: $isLoginScreenPresented)
                    }
                }
                Spacer()
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    AvatarView()
                        .onTapGesture{
                            profileSheet.toggle()
                        }
                }
            })
            .padding()
            .navigationTitle("Summary")
        }
    }
}
