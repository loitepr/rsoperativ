import Foundation

// MARK: - Welcome
struct RootOcean: Codable {
    let type: String?
    let geometry: GeometryOcean?
    let properties: PropertiesOcean?
}

// MARK: - Geometry
struct GeometryOcean: Codable {
    let type: String?
    let coordinates: [Double]?
}

// MARK: - Properties
struct PropertiesOcean: Codable {
    let meta: MetaOcean?
    let timeseries: [TimeseryOcean]?
}

// MARK: - Meta
struct MetaOcean: Codable {
    let updatedAt: String?
    let units: [String: String]

    enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
        case units = "units"
    }
}

// MARK: - Timesery
struct TimeseryOcean: Codable {
    let time: String?
    let data: DataClassOcean?
}

// MARK: - DataClass
struct DataClassOcean: Codable {
    let instant: InstantOcean?
}

// MARK: - Instant
struct InstantOcean: Codable {
    let details: [String: Double]
}
