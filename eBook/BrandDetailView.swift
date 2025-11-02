//
//  BrandDetailView.swift
//  eBook
//
//

import SwiftUI
import UIKit

struct BrandDetailView: View {
    @EnvironmentObject private var model: AppModel
    let brand: Brand

    // 依品牌自訂起始漸層顏色；結束色固定為白色
    private var customStartColor: Color {
        brandStartColor(for: brand)
    }
    private let customEndColor: Color = .white

    private var grouped: [(DrinkCategory, [Drink])] {
        let drinks = model.drinks(for: brand)
        let groupedDict = Dictionary(grouping: drinks, by: { $0.category })
        let order = DrinkCategory.allCases
        return order.compactMap { cat in
            guard let arr = groupedDict[cat], !arr.isEmpty else { return nil }
            return (cat, arr)
        }
    }

    // 白色比例提高的漸層
    private var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: customStartColor, location: 0.0),
                .init(color: customStartColor.opacity(0.6), location: 0.15),
                .init(color: customEndColor.opacity(0.95), location: 0.35),
                .init(color: customEndColor, location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var body: some View {
        ZStack {
            gradient.ignoresSafeArea()

            List {
                transparentBrandHeader

                ForEach(grouped, id: \.0.id) { category, drinks in
                    Section {
                        ForEach(drinks, id: \.id) { drink in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(drink.name)
                                        .font(.headline)
                                    Text(priceText(for: drink))
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Button {
                                    model.toggleFavorite(for: drink)
                                } label: {
                                    Image(systemName: model.isFavorite(drink) ? "heart.fill" : "heart")
                                        .foregroundStyle(model.isFavorite(drink) ? .red : .secondary)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.vertical, 6)
                            .listRowBackground(Color.clear)
                        }
                    } header: {
                        CategoryHeader(title: category.rawValue, accent: customStartColor)
                            .padding(.bottom, 4)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden)
        }
    }

    // 透明的品牌 Header
    private var transparentBrandHeader: some View {
        HStack(spacing: 12) {
            brandThumbnail
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 6) {
                Text(brand.name)
                    .font(.title3).bold()
                Text("\(model.drinks(for: brand).count) 項飲料")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .listRowBackground(Color.clear)
    }

    // 根據 brand.imageData 或 brand.imageName 顯示圖片；若皆無則顯示佔位
    @ViewBuilder
    private var brandThumbnail: some View {
        if let data = brand.imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else if let name = brand.imageName {
            Image(name)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                Color.gray.opacity(0.15)
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func priceText(for drink: Drink) -> String {
        let m = drink.prices[.medium].map { "中 \($0)" }
        let l = drink.prices[.large].map { "大 \($0)" }
        switch (m, l) {
        case let (m?, l?):
            return "\(m) / \(l)"
        case let (m?, nil):
            return m
        case let (nil, l?):
            return l
        default:
            return "—"
        }
    }

    // 依品牌決定漸層起始色
    private func brandStartColor(for brand: Brand) -> Color {
        // 以 imageName 決定顏色，若無 imageName 則回傳預設白色
        guard let key = brand.imageName?.lowercased() else {
            return .white
        }
        switch key {
        case "50lan":
            return Color(red: 0.98, green: 0.78, blue: 0.20) // 黃橘
        case "aniceholiday":
            return Color(red: 0.37, green: 0.39, blue: 0.26) // 深橄欖綠
        case "chingshin":
            return Color(red: 0.00, green: 0.56, blue: 0.44) // 綠藍
        case "coco":
            return Color(red: 0.96, green: 0.49, blue: 0.16) // 橘
        case "guiji":
            return Color(red: 0.14, green: 0.33, blue: 0.27) // 墨綠
        case "kebuke":
            return Color(red: 0.00, green: 0.43, blue: 0.53) // 深藍綠
        case "macu":
            return Color(red: 0.88, green: 0.13, blue: 0.12) // 紅
        case "milksha":
            return Color(red: 0.39, green: 0.45, blue: 0.19) // 牛奶綠
        case "wootea":
            return Color(red: 0.89, green: 0.56, blue: 0.25) // 茶棕
        default:
            return .white
        }
    }
}

// MARK: - 自訂分類標題（文字 + 強調底線）
private struct CategoryHeader: View {
    let title: String
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
                .textCase(nil) // 保持原樣
            // 強調底線：使用品牌色，降低不透明度避免過重
            Rectangle()
                .fill(accent.opacity(0.6))
                .frame(height: 3)
                .cornerRadius(1.5)
        }
        .padding(.top, 6)
        .padding(.trailing, 8)
        .background(Color.clear)
    }
}
