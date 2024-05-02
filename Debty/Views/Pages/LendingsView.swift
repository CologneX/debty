//
//  LendingsView.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 23/04/24.
//

import SwiftUI
struct LendingsView: View {
    @Binding var profile: ProfileViewModel
    @State var addSheetActive: Bool = false
    @State var isLoading: Bool = false
    @State private var model = LendingViewModel()
    @State var profileSheet: Bool = false
    @Binding var isAuthenticated: Bool?
    @Binding var isLoginScreenPresented: Bool
    func refreshLendingData() {
        Task{
            isLoading = true
            try await model.getLendings()
            isLoading = false
        }
    }
    var body: some View {
        let groupedDebts = Dictionary(grouping: model.lendings, by: \.status)
        NavigationStack{
            ZStack{
                if isAuthenticated == true {
                    if isLoading {
                        ProgressView()
                    } else {
                        if (model.lendings.isEmpty) {
                            ContentUnavailableView {
                                Label("No Lending", systemImage: "banknote.fill")
                            } description: {
                                Text("Add new lending to make it appear here")
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
                                                Text("Borrowed to: \(debt.borrower_username)")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                                if let details = debt.details {
                                                    Text(details)
                                                        .lineLimit(2)
                                                        .font(.subheadline)
                                                        .foregroundStyle(.secondary)
                                                }
                                                if debt.status == "pending" {
                                                    Button("Confirm"){
                                                        Task{
                                                            do {
                                                                try await model.confirmLending(id: debt.id)
                                                                try await model.getLendings()
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
                        }
                    }
                } else {
                    ContentUnavailableView {
                        Label("You are not authenticated!", systemImage: "xmark")
                    } description: {
                        Text("Log in first to access our services")
                        Button("Login") {
                            isLoginScreenPresented.toggle()
                        }
                    }
                }
            }
            .searchable(text: $model.searchLending)
            .onChange(of: model.searchLending, {
               refreshLendingData()
            })
            .onAppear(perform: {
               refreshLendingData()
            })
            .onChange(of: model.filter, {
                refreshLendingData()
            })
            .navigationTitle("Lendings")
            .refreshable{
                refreshLendingData()
            }
            .sheet(isPresented: $profileSheet, content: {
                ProfileView(profile: $profile, isLoginScreenPresented: $isLoginScreenPresented)
            })
            .sheet(isPresented: $addSheetActive, content: {
                AddLendingSheet(isAuthenticated: $isAuthenticated, model: $model, currUser: $profile)
            })
            .toolbar(content: {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        addSheetActive.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
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



// View for adding a new lending
struct AddLendingSheet: View {
    @Binding var isAuthenticated: Bool?
    @Binding var model:LendingViewModel
    @Binding var currUser: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State var isAdding: Bool = false
    private func resetFields() {
        $model.AddDataForm.wrappedValue = AddDataModel(title: "", details: "", lender_id: UUID(), borrower_id: UUID(), amount: 0)
        $model.selectedContact.wrappedValue = nil
    }
    var body: some View {
        NavigationStack{
            if (isAuthenticated == true) {
                Form{
                    Section(header: Text("Select Borrower")){
                        NavigationLink(destination: ContactView(
                            model: $model,
                            currUser: $currUser
                        )){
                            if model.selectedContact != nil {
                                Text(model.selectedContact!.username)
                            } else {
                                Text("Select Borrower")
                            }
                        }
                    }
                    Section(header: Text("Information")){
                        TextField("Groceries...", text: $model.AddDataForm.title)
                        TextEditor(text: $model.AddDataForm.details)
                    }
                    Section(header: Text("Amount")){
                        LabeledContent {
                            TextField("0", value: $model.AddDataForm.amount, formatter: formatter)
                                .keyboardType(.decimalPad)
                                .font(.largeTitle)
                                .bold()
                            
                        } label: {
                            Text("Rp")
                        }
                    }
                }
                .task {
                    model.AddDataForm.lender_id = currUser.profile?.id ?? UUID()
                }
                .navigationTitle("Add Lending")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Back") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {Task {
                            do {
                                isAdding = true
                                try await model.addLending()
                                isAdding = false
                                dismiss()
                                resetFields()
                            }
                            catch {
                                isAdding = false
                            }
                        }}){
                            if isAdding {
                                ProgressView()
                            } else {
                                Text("Add")
                            }
                        }
                        .disabled(isAdding)
                    }
                }
            } else {
                ContentUnavailableView {
                    Label("You are not authenticated!", systemImage: "xmark")
                } description: {
                    Text("Log in first to access our services")
                    NavigationLink(destination: AuthView()) {
                        Text("Login")
                    }
                }
            }
        }
    }
}

// View for contact list
struct ContactView: View {
    @State var addUserSheetActive: Bool = false
    @Binding var model:LendingViewModel
    @Binding var currUser: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
            ZStack{
                if $model.contactList.isEmpty {
                    Text("No contacts")
                } else {
                    List {
                        ForEach($model.contactList, id: \.username) { $contact in
                            Button(action: {
                                model.selectedContact = contact
                                dismiss()
                            }) {
                                HStack {
                                    Text(contact.username)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if model.selectedContact == contact {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $model.searchContact)
            .navigationTitle("Contacts")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $addUserSheetActive)   {
                AddUserSheet(model: $model, currUser: $currUser)
            }
            .task {
                await model.getContacts()
            }
            .onChange(of: model.searchContact) {
                Task{
                    await model.getContacts()
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        addUserSheetActive.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            })
        }
        
    }
}


// View for adding new user to the lending
struct AddUserSheet: View {
    @Binding var model:LendingViewModel
    @Binding var currUser: ProfileViewModel
    @State var username: String = ""
    @State var isAdding: Bool = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
            Form{
                TextField("Username", text: $username)
            }
            .navigationTitle("Add User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Back") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button{
                        Task{
                            isAdding = true
                            do {
                                try await model.addContact(username: username)
                                dismiss()
                                await model.getContacts()
                                isAdding = false
                            } catch {
                                isAdding = false
                            }
                            
                        }
                    } label: {
                        if isAdding {
                            ProgressView()
                        } else {
                            Text("Add")
                        }
                    }
                }
            }
        }
        .presentationDetents([.height(200)])
    }
}
