
import Foundation
import MapKit

// MARK: - Welcome
struct WelcomePos: Codable, Identifiable {
    var id: String { return "\(UUID())" }
    let iphoneFeed: IphoneFeed
}

// MARK: - Vessel
struct IphoneFeed: Codable, Identifiable {
    var id: String { return "\(UUID())" }
    let vessels: [VesselPos]
    let stations: [StationPos]

    enum CodingKeys: String, CodingKey {
        case vessels = "Vessels"
        case stations = "Stations"
    }
}

// MARK: - Station
struct StationPos: Codable {
    let name, latitude, longitude: String
    let type: TypeUnion
    let address: String?
    let image: ImagePos
    let phone: String?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case type = "Type"
        case address = "Address"
        case image = "Image"
        case phone = "Phone"
    }
}

// MARK: - Image
struct ImagePos: Codable {
}

enum TypeUnion: Codable {
    case enumeration(TypeEnumPos)
    case image(ImagePos)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(TypeEnumPos.self) {
            self = .enumeration(x)
            return
        }
        if let x = try? container.decode(ImagePos.self) {
            self = .image(x)
            return
        }
        throw DecodingError.typeMismatch(TypeUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TypeUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .enumeration(let x):
            try container.encode(x)
        case .image(let x):
            try container.encode(x)
        }
    }
}

enum TypeEnumPos: String, Codable {
    case primærstasjon = "Primærstasjon"
    case sekundærstasjon = "Sekundærstasjon"
    case sjøredningskorps = "Sjøredningskorps"
}

// MARK: - Vessel
struct VesselPos: Codable, Identifiable {
    var idd: String { return "\(UUID())" }
    let id, name, mmsi, statusID: String
    let stationID: String
    let aarsak: AarsakPos
    let aarsakID: String
    let destination: Destination
    let latitude, longitude: String
    let sog, cog: Cog
    let crew: String?
    let range, callsign, station, vesselClass: String?
    let timestamp: String
    let status: Status
    let phone: Phone

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case mmsi = "MMSI"
        case statusID = "status_id"
        case stationID = "station_id"
        case aarsak
        case aarsakID = "aarsak_id"
        case destination = "Destination"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case sog = "SOG"
        case cog = "COG"
        case crew = "Crew"
        case range = "Range"
        case callsign = "Callsign"
        case station = "Station"
        case vesselClass = "Class"
        case timestamp = "Timestamp"
        case status = "Status"
        case phone = "Phone"
    }
}

enum AarsakPos: String, Codable {
    case ingenÅrsak = "Ingen årsak"
}

// MARK: - Cog
struct Cog: Codable {
    let unit: Unit
    let value: String
}

enum Unit: String, Codable {
    case empty = "°"
    case kn = "kn"
}

enum Destination: String, Codable {
    case nA = "N/A"
}

enum Phone: Codable {
    case image(ImagePos)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(ImagePos.self) {
            self = .image(x)
            return
        }
        throw DecodingError.typeMismatch(Phone.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Phone"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .image(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

enum Status: String, Codable {
    case beredskap = "Beredskap"
    case operativ = "Operativ"
}
