//
//  DebtsView.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 23/04/24.
//

import SwiftUI
import NotificationCenter
struct DebtsView: View {
    @Binding var profile: ProfileViewModel
    @State private var model  = DebtViewModel()
    @State var profileSheet: Bool = false
    @State var isLoading: Bool = false
    @Binding var isAuthenticated: Bool?
    @Binding var isLoginScreenPresented: Bool
    func refreshDebtDate(){
        Task{
            isLoading = true
            try await model.getDebts()
            isLoading = false
        }
    }
    var body: some View {
        let groupedDebts = Dictionary(grouping: model.debts, by: \.status)
        NavigationStack{
            ZStack{
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
                    ZStack{
                        if isLoading {
                            ProgressView()
                        } else {
                            if (model.debts.isEmpty) {
                                ContentUnavailableView {
                                    Label("No Debts", systemImage: "banknote.fill")
                                } description: {
                                    Text("Wait for your friend to lend you some money!")
                                }
                            } else {
                                List{
                                    ForEach(groupedDebts.keys.sorted(), id: \.self) { status in
                                        Section(header: Text(status)) {
                                            ForEach(groupedDebts[status]!, id: \.id) { debt in
                                                VStack(alignment: .leading) {
                                                    Text(debt.created_at.formatted())
                                                        .font(.footnote)
                                                        .foregroundStyle(.tertiary)
                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                    Text(debt.title)
                                                        .bold()
                                                        .font(.title3)
                                                    Text("Lent by: \(debt.lender_username)")
                                                        .font(.subheadline)
                                                        .foregroundStyle(.secondary)
                                                    if let details = debt.details {
                                                        Text(details)
                                                            .lineLimit(2)
                                                            .font(.subheadline)
                                                            .foregroundStyle(.secondary)
                                                    }
                                                    if debt.status == "unpaid" {
                                                        Button("Confirm"){
                                                            Task{
                                                                do {
                                                                    try await model.completeDebts(id: debt.id)
                                                                    try await model.getDebts()
                                                                }
                                                                catch {
                                                                    print(error)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    Divider()
                                                    HStack {
                                                        Text("Total")
                                                            .font(.headline)
                                                            .foregroundStyle(.secondary)
                                                        Spacer()
                                                        Text(debt.amount, format: .currency(code: "IDR"))
                                                            .font(.title2)
                                                            .bold()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .listRowSpacing(8)
                                .refreshable{
                                    refreshDebtDate()
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $model.searchDebts)
            .onChange(of: model.searchDebts, {
                refreshDebtDate()
            })
            .onAppear(perform: {
                refreshDebtDate()
            })
            .onChange(of: model.filter, {
                refreshDebtDate()
            })
            .navigationTitle("Debts")
            .sheet(isPresented: $profileSheet, content: {
                ProfileView(profile: $profile, isLoginScreenPresented: $isLoginScreenPresented)
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    AvatarView()
                        .onTapGesture{
                            profileSheet.toggle()
                        }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Sort", selection: $model.filter){
                            ForEach(LendingFilter.allCases, id: \.self){ filter in
                                Text("\(filter)".capitalized)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                    }
                }
            })
        }
    }
}
