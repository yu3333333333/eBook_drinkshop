//
//  RecommendationsView.swift
//  eBook
//

import SwiftUI

struct RecommendationsView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        List {
            // 只保留有新品的品牌
            ForEach(model.brands.filter { brand in
                brand.drinks.contains(where: { $0.isNew })
            }) { brand in
                let newDrinks = brand.drinks.filter { $0.isNew }

                // 每個品牌各自維護一個目前索引
                BrandNewDrinksCarousel(brand: brand, newDrinks: newDrinks)
            }
        }
        .listStyle(.insetGrouped)
    }
}

// MARK: - 每個品牌的新品輪播
private struct BrandNewDrinksCarousel: View {
    let brand: Brand
    let newDrinks: [Drink]

    // 當前頁索引
    @State private var currentIndex: Int = 0

    var body: some View {
        Section {
            VStack(spacing: 10) {
                // 使用 selection 綁定 + tag 來同步索引
                TabView(selection: $currentIndex) {
                    ForEach(Array(newDrinks.enumerated()), id: \.element.id) { index, drink in
                        VStack(spacing: 8) {
                            // 圖片：保持原始比例，不裁切
                            Group {
                                if let name = drink.imageName {
                                    Image(name)
                                        .resizable()
                                        .scaledToFit()
                                } else if let name = brand.imageName {
                                    Image(name)
                                        .resizable()
                                        .scaledToFit()
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(16)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .background(Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                            Text(drink.name)
                                .font(.headline)

                            Text(priceText(for: drink))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal)
                        .tag(index)
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 250)

                // 黑色點點指示器
                PageDots(count: newDrinks.count, currentIndex: currentIndex)
                    .padding(.top, -2)
                    .padding(.bottom, 6)
            }
        } header: {
            HStack {
                BrandImageViewCompat(brand: brand)
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                Text(brand.name)
                    .font(.title3).bold()
            }
        }
    }

    private func priceText(for drink: Drink) -> String {
        let m = drink.prices[.medium].map { "中杯 \($0) 元" }
        let l = drink.prices[.large].map { "大杯 \($0) 元" }
        switch (m, l) {
        case let (m?, l?):
            return "\(m)・\(l)"
        case let (m?, nil):
            return m
        case let (nil, l?):
            return l
        default:
            return "價格未定"
        }
    }
}

// MARK: - 黑色點點指示器
private struct PageDots: View {
    let count: Int
    let currentIndex: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? Color.black : Color.black.opacity(0.25))
                    .frame(width: index == currentIndex ? 8 : 6,
                           height: index == currentIndex ? 8 : 6)
                    .animation(.easeInOut(duration: 0.2), value: currentIndex)
            }
        }
        .frame(maxWidth: .infinity)
        .opacity(count > 1 ? 1 : 0)
    }
}

// MARK: - 簡易品牌圖片：優先 imageData，再退回 imageName
private struct BrandImageViewCompat: View {
    let brand: Brand

    var body: some View {
        Group {
            if let data = brand.imageData, let ui = UIImage(data: data) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
            } else if let name = brand.imageName {
                Image(name)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .background(.thinMaterial)
            }
        }
    }
}
