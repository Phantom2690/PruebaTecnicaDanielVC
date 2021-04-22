//
//  Product.swift
//  PruebaTecnicaBuscadorProductos
//
//  Created by Daniel Vazquez on 21/4/21.
//

import Foundation

public struct PlpResults: Codable {
    let plpResults: Records
}

struct Records: Codable {
    let records: [Product]
    let plpState: PlpState
}

public struct PlpState: Codable {
    private enum CodingKeys: String, CodingKey {
        case firstRecNum
        case lastRecNum
        case totalNumRecs
    }
    
    let firstRecNum: Int?
    let lastRecNum: Int?
    let totalNumRecs: Int?
}


public struct Product: Codable {
    private enum CodingKeys: String, CodingKey {
        case productId
        case productDisplayName
        case smImage
        case promoPrice
        case listPrice
        case variantsColor
    }
    
    let productId: String?
    let productDisplayName: String?
    let smImage: String?
    let promoPrice: Double?
    let listPrice: Double?
    let variantsColor: [VariantsColor]?
}

struct VariantsColor:Codable {
    private enum CodingKeys: String, CodingKey {
        case colorHex
    }
    let colorHex: String?
}
