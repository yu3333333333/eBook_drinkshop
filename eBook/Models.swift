//
//  Models.swift
//  eBook
//
//

import Foundation

enum DrinkCategory: String, CaseIterable, Codable, Identifiable {
    case tea = "茶類"
    case milkTea = "奶類/奶茶"
    case latte = "拿鐵/鮮奶茶"
    case fruit = "風味茶/果茶"
    case coffee = "咖啡/含咖啡因"
    case taste = "口感"
    case icecream = "冰淇淋"
    case others = "其他"

    var id: String { rawValue }
}

enum DrinkSize: String, CaseIterable, Codable, Identifiable {
    case medium = "M"
    case large = "L"

    var id: String { rawValue }
}

struct Drink: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var brandID: UUID
    var category: DrinkCategory
    var prices: [DrinkSize: Int]
    var imageName: String?
    var isNew: Bool = false
}

struct Brand: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    // 兩種來源擇一：優先使用 imageData，否則回退 imageName（Assets）
    var imageName: String?
    var imageData: Data?
    var drinks: [Drink] = []
}
