//
//  FavoritesView.swift
//  eBook
//
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        Group {
            if model.favoriteDrinks.isEmpty {
                ContentUnavailableView("尚無收藏",
                                       systemImage: "heart",
                                       description: Text("在品牌或飲料頁面點擊愛心即可加入收藏"))
            } else {
                List {
                    ForEach(model.favoriteDrinks, id: \.id) { drink in
                        if let brand = model.brands.first(where: { $0.id == drink.brandID }) {
                            NavigationLink {
                                DrinkDetailView(drink: drink, brand: brand)
                            } label: {
                                HStack {
                                    Image(((drink.imageName ?? brand.imageName)!))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 56, height: 56)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    VStack(alignment: .leading) {
                                        Text(drink.name).font(.headline)
                                        Text(brand.name).font(.subheadline).foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "heart.fill")
                                        .foregroundStyle(.red)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .listStyle(.inset)
            }
        }
    }
}
