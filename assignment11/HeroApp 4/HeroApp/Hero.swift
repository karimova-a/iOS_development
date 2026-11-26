//
//  Hero.swift
//  HeroApp
//
//  Codable model for one hero from the Superhero API.
//  Only `id` and `name` are required; every other field is optional,
//  because the API has many heroes with missing or messy data.
//

import Foundation

// MARK: - Lenient decoding

extension KeyedDecodingContainer {
    /// Decodes a value, or returns nil when the key is missing, null or has an unexpected type.
    /// One bad field in one hero must never make the whole list fail to load.
    nonisolated func lenient<T: Decodable>(_ type: T.Type, forKey key: Key) -> T? {
        try? decodeIfPresent(type, forKey: key)
    }
}

// MARK: - Model

nonisolated enum Gender {
    case male
    case female
    case unknown
}

nonisolated struct Hero: Codable {
    let id: Int
    let name: String
    let powerstats: Powerstats?
    let appearance: Appearance?
    let biography: Biography?
    let work: Work?
    let images: Images?

    var gender: Gender {
        let value = appearance?.gender?.lowercased() ?? ""
        if value == "male" { return .male }
        if value == "female" { return .female }
        return .unknown
    }
}

nonisolated struct Powerstats: Codable {
    let intelligence: Int?
    let strength: Int?
    let speed: Int?
    let durability: Int?
    let power: Int?
    let combat: Int?

    enum CodingKeys: String, CodingKey {
        case intelligence, strength, speed, durability, power, combat
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        intelligence = c.lenient(Int.self, forKey: .intelligence)
        strength = c.lenient(Int.self, forKey: .strength)
        speed = c.lenient(Int.self, forKey: .speed)
        durability = c.lenient(Int.self, forKey: .durability)
        power = c.lenient(Int.self, forKey: .power)
        combat = c.lenient(Int.self, forKey: .combat)
    }
}

nonisolated struct Appearance: Codable {
    let gender: String?
    let race: String?
    let height: [String]?
    let weight: [String]?
    let eyeColor: String?

    enum CodingKeys: String, CodingKey {
        case gender, race, height, weight, eyeColor
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        gender = c.lenient(String.self, forKey: .gender)
        race = c.lenient(String.self, forKey: .race)
        height = c.lenient([String].self, forKey: .height)
        weight = c.lenient([String].self, forKey: .weight)
        eyeColor = c.lenient(String.self, forKey: .eyeColor)
    }
}

nonisolated struct Biography: Codable {
    let fullName: String?
    let placeOfBirth: String?
    let publisher: String?
    let alignment: String?

    enum CodingKeys: String, CodingKey {
        case fullName, placeOfBirth, publisher, alignment
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        fullName = c.lenient(String.self, forKey: .fullName)
        placeOfBirth = c.lenient(String.self, forKey: .placeOfBirth)
        publisher = c.lenient(String.self, forKey: .publisher)
        alignment = c.lenient(String.self, forKey: .alignment)
    }
}

nonisolated struct Work: Codable {
    let occupation: String?
    let base: String?

    enum CodingKeys: String, CodingKey {
        case occupation, base
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        occupation = c.lenient(String.self, forKey: .occupation)
        base = c.lenient(String.self, forKey: .base)
    }
}

nonisolated struct Images: Codable {
    let sm: String?
    let md: String?
    let lg: String?

    enum CodingKeys: String, CodingKey {
        case sm, md, lg
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        sm = c.lenient(String.self, forKey: .sm)
        md = c.lenient(String.self, forKey: .md)
        lg = c.lenient(String.self, forKey: .lg)
    }
}

// MARK: - Display helpers for messy data

nonisolated enum Display {
    static let unknown = "Unknown"

    /// "-", "null", empty or missing text becomes "Unknown".
    static func text(_ value: String?) -> String {
        guard let value = value else { return unknown }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if isMissing(trimmed) { return unknown }
        return trimmed
    }

    /// Height or weight come as two strings, e.g. ["6'0", "183 cm"].
    /// Missing parts ("-", "0 cm", "0 kg") are dropped; nothing left becomes "Unknown".
    static func measurement(_ values: [String]?) -> String {
        let parts = (values ?? [])
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !isMissing($0) }
        if parts.isEmpty { return unknown }
        return parts.joined(separator: " · ")
    }

    private static func isMissing(_ value: String) -> Bool {
        let lower = value.lowercased()
        let missing: Set<String> = ["", "-", "null", "0 cm", "0 kg", "0 lb", "0 tons", "0"]
        return missing.contains(lower)
    }
}
