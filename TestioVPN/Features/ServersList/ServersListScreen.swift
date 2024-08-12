//
//  ServersListScreen.swift
//  TestioVPN
//
//  Created by Yevhen Kyivskyi on 09.08.2024.
//

import SwiftUI

struct ServersListScreen: View {
    
    @StateObject var viewModel = ServersListViewModel()
    
    @State var isPresentedSheet = false
    
    var body: some View {
        Group {
            if viewModel.isInitialLoading {
                loadingView
            } else {
                content
            }
        }
        .task {
            await viewModel.getServersList()
        }
    }
    
    init() {
        // TODO: Refactor to newer API to change navigation bar appearance once iOS version is updated to 16
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = UIColor.white
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
}

private extension ServersListScreen {
    
    var content: some View {
        NavigationView {
            itemsListView
                .refreshable {
                    await viewModel.getServersList()
                }
                .background(Color.Testio.grayBackground)
                .listStyle(PlainListStyle())
                .navigationTitle("Testio.")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(
                            action: {
                                isPresentedSheet = true
                            },
                            label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "arrow.up.arrow.down")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                    Text("Sort")
                                }
                            }
                        )
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(
                            action: {
                                viewModel.logout()
                            },
                            label: {
                                HStack(spacing: 10) {
                                    Text("Logout")
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                }
                            }
                        )
                    }
                }
                .confirmationDialog("",isPresented: $isPresentedSheet) {
                    Button("By distance") {
                        viewModel.updateSorting(.byDistance)
                    }
                    Button("Alpabetical") {
                        viewModel.updateSorting(.alphabetical)
                    }
                    Button("Cancel", role: .cancel) {
                        viewModel.updateSorting(nil)
                    }
                }
        }
    }
    
    var itemsListView: some View {
        List {
            if viewModel.isShowingError {
                failureView
            }
            itemsSection
        }
        .background(Color.clear)
    }
    
    var itemsSection: some View {
        Section(
            content: {
                ForEach(viewModel.presentingItems, id: \.self) { item in
                    HStack {
                        Text(item.name)
                            .font(Font.Testio.body)
                        Spacer()
                        Text("\(item.distance) km")
                            .font(Font.Testio.body)
                    }
                }
                .listRowBackground(Color.white)
            },
            header: {
                HStack {
                    Text("SERVER")
                        .font(Font.Testio.bodySmall)
                    Spacer()
                    Text("DISTANCE")
                        .font(Font.Testio.bodySmall)
                }
            }
        )
    }
    
    var loadingView: some View {
        ZStack {
            BackgroundView()
            ProgressView()
                .frame(width: 24, height: 24)
                .tint(.Testio.progress)
        }
    }
    
    var failureView: some View {
        Text("Could not load, showing persisted data. Please pull to refresh")
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
            .padding(.top, 16)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
}

#Preview {
    ServersListScreen()
}
