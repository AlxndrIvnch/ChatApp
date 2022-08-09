//
//  Decodable + Extensions.swift
//  Chat
//
//  Created by Aleksandr on 18.06.2022.
//

import Foundation

extension Decodable {
    init(from jsonObject: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sszzz"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        self = try decoder.decode(Self.self, from: data)
    }
}

