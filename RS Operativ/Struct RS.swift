import Foundation
import SwiftUI
import MapKit

struct customCheckbox: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                configuration.label
            }
        })
    }
}

struct DefaultsKeys {
    static let selectedDetailed = "selectedDetailed"
    static let selectedNight = "selectedNight"
    static let selectedMap = "selectedMap"
}

struct CableMarker: Identifiable {
    var id: String { return "\(UUID())" }
    var from: CLLocationCoordinate2D
    var to: CLLocationCoordinate2D
}

struct Root: Codable, Identifiable {
    var id: String { return "\(UUID())" }
    var rescueboats: [Rescueboat]?
}

struct BW: Identifiable {
    var id: String { return "\(UUID())" }
    var bwSpeed, bwCog, bwLatitude, bwLongitude: Double?
    var bwHdg: Int?
    var bwTime: String?
}

struct Rescueboat: Codable, Identifiable {
    var id: String { return "\(UUID())"}
    
    var bw: [BW]?
    var aistrack: [MKMapPoint]?
    
    let merknad: AuxEngine?
    let aarsak: Aarsak?
    let aarsakID: String?
    let forventetTilbake: String?
    let name: String?
    let otherName: Bowthruster?
    let rs, rescueboatClass: String?
    let vesselType: AuxEngine?
    let callsign: AuxEngine?
    let mmsi: String?
    let mobile: AuxEngine?
    let email: String?
    let port: Port?
    let buildingyardYear: String?
    let construction, sales, finance, constructionMaterial: AuxEngine?
    let dnvClass, speed, range, gross: AuxEngine?
    let net, length, beam, draft: AuxEngine?
    let bunkerOil, ballastWater, freshWater, bollardPullMaximum: AuxEngine?
    let towingHook, mainEngine, auxEngine, gear: AuxEngine?
    let controllablePitchPropellers: AuxEngine?
    let bowthruster: Bowthruster?
    let waterjet, deckMachinery, salvageEquipment, divingEquipment: AuxEngine?
    let navigationEquipment, communicationEquipment, rescueAccommodation, crew: AuxEngine?
    let state: String?
    let stateDescription: Stat?
    let vesselTypeTxt: VesselTypeTxt?
    let classTxt: AuxEngine?
    let station: Station?
    let distriktskontor: [String: Bowthruster]?
    let koordinater: Koordinater?
    let imageURL: String?
    let extendedState: ExtendedState?
    let lokasjon: String?
    var weatherAirTemp: Double?
    var weatherWindSpeed: Double?
    var weatherWindDirection: Double?
    var weatherSymbol: String?
    var waveHeight: Double?
    var waveDirection: Double?
    var seaWaterTemp: Double?
    var seaWaterDirection: Double?
    var seaWaterSpeed: Double?
    var tideLevel: Tide?
    var vesselSpeed: Double?
    var vesselCog: Double?

    enum CodingKeys: String, CodingKey {
        case merknad, aarsak
        case aarsakID = "aarsak_id"
        case forventetTilbake = "forventet_tilbake"
        case name
        case otherName = "other_name"
        case rs
        case rescueboatClass = "class"
        case vesselType = "vessel-type"
        case callsign, mmsi, mobile, email, port
        case buildingyardYear = "buildingyard_year"
        case construction, sales, finance
        case constructionMaterial = "construction_material"
        case dnvClass = "dnv_class"
        case speed, range, gross, net, length, beam, draft
        case bunkerOil = "bunker_oil"
        case ballastWater = "ballast_water"
        case freshWater = "fresh_water"
        case bollardPullMaximum = "bollard_pull_maximum"
        case towingHook = "towing_hook"
        case mainEngine = "main_engine"
        case auxEngine = "aux_engine"
        case gear
        case controllablePitchPropellers = "controllable_pitch_propellers"
        case bowthruster, waterjet
        case deckMachinery = "deck_machinery"
        case salvageEquipment = "salvage_equipment"
        case divingEquipment = "diving_equipment"
        case navigationEquipment = "navigation_equipment"
        case communicationEquipment = "communication_equipment"
        case rescueAccommodation = "rescue_accommodation"
        case crew, state
        case stateDescription = "state_description"
        case vesselTypeTxt = "vessel-type-txt"
        case classTxt = "class-txt"
        case station = "Station"
        case distriktskontor = "Distriktskontor"
        case koordinater
        case imageURL = "imageUrl"
        case extendedState
        case lokasjon = "Lokasjon"
    }
}

enum Aarsak: String, Codable {
    case forflytning = "Forflytning"
    case ingenÅrsak = "Ingen årsak"
    case operasjonelt = "Operasjonelt"
    case opplag = "Opplag"
    case personell = "Personell"
    case teamAlert = "Team Alert"
    case tekniskPlanlagt = "Teknisk planlagt"
    case tekniskUplanlagt = "Teknisk uplanlagt"
    case hviletid = "Hviletid"
}

enum AuxEngine: Codable {
    case bowthruster(Bowthruster)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(Bowthruster.self) {
            self = .bowthruster(x)
            return
        }
        throw DecodingError.typeMismatch(AuxEngine.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for AuxEngine"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bowthruster(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Tide Water
struct Tide: Codable {
    var tideObservation: [TideData]
    var tidePrediction: [TideData]
    var tideForecast: [TideData]
    var tideWeather: [TideData]
}

struct TideData: Identifiable, Hashable, Codable {
    var id = UUID()
    var time: Date
    var value: Double
}

// MARK: - Bowthruster
struct Bowthruster: Codable {
}

// MARK: - ExtendedState
struct ExtendedState: Codable {
    let statusID: Int?
    let statusText: Stat?
    let colorCode: ColorCode?
    let underliggendeStatus: Int?

    enum CodingKeys: String, CodingKey {
        case statusID = "StatusId"
        case statusText = "StatusText"
        case colorCode = "ColorCode"
        case underliggendeStatus = "UnderliggendeStatus"
    }
}

enum ColorCode: String, Codable {
    case ff0000 = "#ff0000"
    case ff9933 = "#FF9933"
    case ffd203 = "#ffd203"
    case the0066Ff = "#0066FF"
    case the33Cc33 = "#33CC33"
}

enum Stat: String, Codable {
    case beredskap = "Beredskap"
    case kunSAROppdrag = "Kun SAR-oppdrag"
    case ledigPåBasenPatrulje = "Ledig, på basen/patrulje"
    case operativ = "Operativ"
    case påOppdrag = "På oppdrag"
    case the30MinBeredskap = "30 min beredskap"
    case the60MinBeredskap = "60 min beredskap"
    case uad = "UAD"
}

// MARK: - Koordinater
struct Koordinater: Codable {
    let timestamp, longitude, latitude, decimalLongitude: String?
    let decimalLatitude: String?

    enum CodingKeys: String, CodingKey {
        case timestamp = "Timestamp"
        case longitude = "Longitude"
        case latitude = "Latitude"
        case decimalLongitude = "Decimal_Longitude"
        case decimalLatitude = "Decimal_Latitude"
    }
}

enum Port: String, Codable {
    case bergen = "Bergen"
    case oslo = "Oslo"
    case sandnessjøen = "Sandnessjøen"
}

// MARK: - Station
struct Station: Codable {
    let code, name: String?
    let type: TypeEnum?
    let region: RegionUnion?
    let phone, address, zipcode: AuxEngine?
    let ziplocation: String?
    let postalPostbox, postalZipcode, postalZiplocation: AuxEngine?
    let emergencyContacts: EmergencyContacts?
    let coordinateType: CoordinateTypeUnion?
    let latitude, longitude: String?
    let municipalityWeb: MunicipalityWeb?
    let municipalityEmergencyPlan: Bowthruster?
    let description: [String: Bowthruster]?
    let localTemps: AuxEngine?

    enum CodingKeys: String, CodingKey {
        case code, name, type, region, phone, address, zipcode, ziplocation
        case postalPostbox = "postal_postbox"
        case postalZipcode = "postal_zipcode"
        case postalZiplocation = "postal_ziplocation"
        case emergencyContacts = "emergency_contacts"
        case coordinateType = "coordinate_type"
        case latitude, longitude
        case municipalityWeb = "municipality_web"
        case municipalityEmergencyPlan = "municipality_emergency_plan"
        case description
        case localTemps = "local_temps"
    }
}

enum CoordinateTypeUnion: Codable {
    case bowthruster(Bowthruster)
    case enumeration(CoordinateTypeEnum)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(CoordinateTypeEnum.self) {
            self = .enumeration(x)
            return
        }
        if let x = try? container.decode(Bowthruster.self) {
            self = .bowthruster(x)
            return
        }
        throw DecodingError.typeMismatch(CoordinateTypeUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for CoordinateTypeUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bowthruster(let x):
            try container.encode(x)
        case .enumeration(let x):
            try container.encode(x)
        }
    }
}

enum CoordinateTypeEnum: String, Codable {
    case degdec = "degdec"
}

// MARK: - EmergencyContacts
struct EmergencyContacts: Codable {
    let police, fire, ambulance, other: Bowthruster?
}

enum MunicipalityWeb: Codable {
    case bowthruster(Bowthruster)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(Bowthruster.self) {
            self = .bowthruster(x)
            return
        }
        throw DecodingError.typeMismatch(MunicipalityWeb.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MunicipalityWeb"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bowthruster(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

enum RegionUnion: Codable {
    case bowthruster(Bowthruster)
    case enumeration(RegionEnum)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(RegionEnum.self) {
            self = .enumeration(x)
            return
        }
        if let x = try? container.decode(Bowthruster.self) {
            self = .bowthruster(x)
            return
        }
        throw DecodingError.typeMismatch(RegionUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for RegionUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bowthruster(let x):
            try container.encode(x)
        case .enumeration(let x):
            try container.encode(x)
        }
    }
}

enum RegionEnum: String, Codable {
    case midtNorge = "Midt-Norge"
    case nordNorge = "Nord-Norge"
    case sørlandet = "Sørlandet"
    case vestlandet = "Vestlandet"
    case østlandet = "Østlandet"
}

enum TypeEnum: String, Codable {
    case amb = "AMB"
    case fast = "FAST"
    case nopos = "NOPOS"
    case rsrk = "RSRK"
}

enum VesselTypeTxt: String, Codable {
    case ambulanse = "Ambulanse"
    case fastBemannet = "Fast bemannet"
    case sjøredningskorps = "Sjøredningskorps"
    case støttefartøy = "Støttefartøy"
}

