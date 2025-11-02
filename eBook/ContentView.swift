//
//  ContentView.swift
//  eBook
//
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = AppModel() // 在 AppModel.swift 定義

    var body: some View {
        TabView {
            NavigationStack {
                RecommendationsView() // 在 RecommendationsView.swift 定義
                    .navigationTitle("推薦新品")
            }
            .tabItem {
                Label("推薦", systemImage: "sparkles")
            }

            NavigationStack {
                BrandsListView() // 在 BrandsListView.swift 定義
                    .navigationTitle("品牌一覽")
            }
            .tabItem {
                Label("品牌", systemImage: "list.bullet")
            }

            NavigationStack {
                CustomEditorView() // 在 CustomEditorView.swift 定義
                    .navigationTitle("自訂")
            }
            .tabItem {
                Label("自訂", systemImage: "plus.square.on.square")
            }

            NavigationStack {
                FavoritesView() // 在 FavoritesView.swift 定義
                    .navigationTitle("我的收藏")
            }
            .tabItem {
                Label("收藏", systemImage: "heart")
            }
        }
        .environmentObject(model)
    }
}

#Preview {
    ContentView()
}
