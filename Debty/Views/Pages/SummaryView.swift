//
//  SummaryView.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 29/04/24.
//

import SwiftUI
struct DateFilter: Equatable {
    var start: Date
    var end: Date
}
struct SummaryView: View {
    @Binding var profile: ProfileViewModel
    @State var summaryModel: SummaryViewModel = SummaryViewModel()
    @State private var profileSheet: Bool = false
    @State private var filterDateLending: DateFilter = DateFilter(start: Date(), end: Date())
    @State private var filterDateDebt: DateFilter = DateFilter(start: Date(), end: Date())
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
                    Section{
                        VStack{ // Date VStack
                            HStack{
                                DatePicker("Start", selection: $filterDateLending.start,
                                           in: ...Date()
                                           ,displayedComponents: [.date])
                                .datePickerStyle(.compact)
                                DatePicker("End", selection: $filterDateLending.end,
                                           in: $filterDateLending.start.wrappedValue...Date()
                                           ,displayedComponents: [.date])
                                .datePickerStyle(.compact)
                            }
                            VStack{
                                if (isLoadingLending) {
                                    ProgressView()
                                    
                                } else {
                                    Text(summaryModel.lendingSummary ?? 0, format: .currency(code: "IDR"))
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
                    } header: {
                        Text("Lending")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    Section{
                        VStack{ // Date VStack
                            HStack{
                                DatePicker("Start", selection: $filterDateDebt.start,
                                           in: ...Date()
                                           ,displayedComponents: [.date])
                                .datePickerStyle(.compact)
                                DatePicker("End", selection: $filterDateDebt.end,
                                           in: $filterDateDebt.start.wrappedValue...Date()
                                           ,displayedComponents: [.date])
                                .datePickerStyle(.compact)
                            }
                            VStack{
                                if (isLoadingDebt) {
                                    ProgressView()
                                    
                                } else {
                                    Text(summaryModel.debtSummary ?? 0, format: .currency(code: "IDR"))
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
                    } header: {
                        Text("Debt")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 24)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Summary")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    AvatarView()
                        .onTapGesture{
                            profileSheet.toggle()
                        }
                }
            })
            .padding(.top)
        }
        .onChange(of: filterDateLending, {
            Task{
                isLoadingLending = true
                do {
                    try await summaryModel.getLendingSummary(filter_date: filterDateLending)
                    isLoadingLending = false
                }
                catch{
                    isLoadingLending = false
                }
            }
        })
        .onChange(of: filterDateDebt, {
            Task{
                isLoadingDebt = true
                do {
                    try await summaryModel.getBorrowingSummary(filter_date: filterDateDebt)
                    isLoadingDebt = false
                }
                catch{
                    isLoadingDebt = false
                }
            }
        })
        .sheet(isPresented: $profileSheet){
            ProfileView(profile: $profile, isLoginScreenPresented: $isLoginScreenPresented)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}
