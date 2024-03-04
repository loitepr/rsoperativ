import Foundation

// MARK: - Welcome
struct RootLocation: Codable {
    let type: String?
    let geometry: Geometry?
    let properties: Properties?
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: String?
    let coordinates: [Double]?
}

// MARK: - Properties
struct Properties: Codable {
    let meta: Meta?
    let timeseries: [Timesery]?
}

// MARK: - Meta
struct Meta: Codable {
    let updatedAt: String?
    let units: Units?

    enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
        case units
    }
}

// MARK: - Units
struct Units: Codable {
    let airPressureAtSeaLevel, airTemperature, airTemperatureMax, airTemperatureMin: String?
    let airTemperaturePercentile10, airTemperaturePercentile90, cloudAreaFraction, cloudAreaFractionHigh: String?
    let cloudAreaFractionLow, cloudAreaFractionMedium, dewPointTemperature, fogAreaFraction: String?
    let precipitationAmount, precipitationAmountMax, precipitationAmountMin, probabilityOfPrecipitation: String?
    let probabilityOfThunder, relativeHumidity, ultravioletIndexClearSky, windFromDirection: String?
    let windSpeed, windSpeedOfGust, windSpeedPercentile10, windSpeedPercentile90: String?

    enum CodingKeys: String, CodingKey {
        case airPressureAtSeaLevel = "air_pressure_at_sea_level"
        case airTemperature = "air_temperature"
        case airTemperatureMax = "air_temperature_max"
        case airTemperatureMin = "air_temperature_min"
        case airTemperaturePercentile10 = "air_temperature_percentile_10"
        case airTemperaturePercentile90 = "air_temperature_percentile_90"
        case cloudAreaFraction = "cloud_area_fraction"
        case cloudAreaFractionHigh = "cloud_area_fraction_high"
        case cloudAreaFractionLow = "cloud_area_fraction_low"
        case cloudAreaFractionMedium = "cloud_area_fraction_medium"
        case dewPointTemperature = "dew_point_temperature"
        case fogAreaFraction = "fog_area_fraction"
        case precipitationAmount = "precipitation_amount"
        case precipitationAmountMax = "precipitation_amount_max"
        case precipitationAmountMin = "precipitation_amount_min"
        case probabilityOfPrecipitation = "probability_of_precipitation"
        case probabilityOfThunder = "probability_of_thunder"
        case relativeHumidity = "relative_humidity"
        case ultravioletIndexClearSky = "ultraviolet_index_clear_sky"
        case windFromDirection = "wind_from_direction"
        case windSpeed = "wind_speed"
        case windSpeedOfGust = "wind_speed_of_gust"
        case windSpeedPercentile10 = "wind_speed_percentile_10"
        case windSpeedPercentile90 = "wind_speed_percentile_90"
    }
}

// MARK: - Timesery
struct Timesery: Codable {
    let time: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let instant: InstantWeather?
    let next12Hours: Next12Hours?
    let next1Hours: Next1Hours?
    let next6Hours: Next6Hours?

    enum CodingKeys: String, CodingKey {
        case instant = "instant"
        case next12Hours = "next_12_hours"
        case next1Hours = "next_1_hours"
        case next6Hours = "next_6_hours"
    }
}

// MARK: - Instant
struct InstantWeather: Codable {
    let details: [String: Double] //InstantDetails? //[String: Double]?
}

// MARK: - InstantDetails
struct InstantDetails: Codable {
    let airPressureAtSeaLevel: Double?
    let airTemperature: Double?
    let airTemperaturePercentile10: Double?
    let airTemperaturePercentile90: Double?
    let cloudAreaFraction: Double?
    let cloudAreaFractionHigh: Double?
    let cloudAreaFractionLow: Double?
    let cloudAreaFractionMedium: Double?
    let dewPointTemperature: Double?
    let fogAreaFraction: Double?
    let relativeHumidity: Double?
    let ultravioletIndexClearSky: Double?
    let windFromDirection: Double?
    let windSpeed: Double?
    let windSpeedOfGusts: Double?
    let windSpeedPercentile10: Double?
    let windSpeedPercentile90: Double?
}
enum CodingKeys: String, CodingKey {
    case airPressureAtSeaLevel = "air_pressure_at_sea_level"
    case airTemperature = "air_temperature"
    case airTemperaturePercentile10 = "air_temperature_percentile_10"
    case airTemperaturePercentile90 = "air_temperature_percentile_90"
    case cloudAreaFraction = "cloud_area_fraction"
    case cloudAreaFractionHigh = "cloud_area_fraction_high"
    case cloudAreaFractionLow = "cloud_area_fraction_low"
    case cloudAreaFractionMedium = "cloud_area_fraction_medium"
    case dewPointTemperature = "dew_point_temperature"
    case fogAreaFraction = "fog_area_fraction"
    case relativeHumidity = "relative_humidity"
    case ultravioletIndexClearSky = "ultraviolet_index_clear_sky"
    case windFromDirection = "wind_from_direction"
    case windSpeed = "wind_speed"
    case windSpeedOfGust = "wind_speed_of_gust"
    case windSpeedPercentile10 = "wind_speed_percentile_10"
    case windSpeedPercentile90 = "wind_speed_percentile_90"
}

// MARK: - Next12_Hours
struct Next12Hours: Codable {
    let summary: Next12HoursSummary?
    let details: Next12HoursDetails?
}

// MARK: - Next12_HoursDetails
struct Next12HoursDetails: Codable {
    let probabilityOfPrecipitation: Double?

    enum CodingKeys: String, CodingKey {
        case probabilityOfPrecipitation = "probability_of_precipitation"
    }
}

// MARK: - Next12_HoursSummary
struct Next12HoursSummary: Codable {
    let symbolCode: SymbolCode?
    let symbolConfidence: SymbolConfidence?

    enum CodingKeys: String, CodingKey {
        case symbolCode = "symbol_code"
        case symbolConfidence = "symbol_confidence"
    }
}

enum SymbolCode: String, Codable {
    case clearskyday = "clearsky_day"
    case clearskynight = "clearsky_night"
    case clearskypolartwilight = "clearsky_polartwilight"
    case cloudy = "cloudy"
    case fairday = "fair_day"
    case fairnight = "fair_night"
    case fairpolartwilight = "fair_polartwilight"
    case fog = "fog"
    case heavyrain = "heavyrain"
    case heavyrainandthunder = "heavyrainandthunder"
    case heavyrainshowersandthunderday = "heavyrainshowersandthunder_day"
    case heavyrainshowersandthundernight = "heavyrainshowersandthunder_night"
    case heavyrainshowersandthunderpolartwilight = "heavyrainshowersandthunder_polartwilight"
    case heavyrainshowersday = "heavyrainshowers_day"
    case heavyrainshowersnight = "heavyrainshowers_night"
    case heavyrainshowerspolartwilight = "heavyrainshowers_polartwilight"
    case heavysleet = "heavysleet"
    case heavysleetandthunder = "heavysleetandthunder"
    case heavysleetshowersandthunderday = "heavysleetshowersandthunder_day"
    case heavysleetshowersandthundernight = "heavysleetshowersandthunder_night"
    case heavysleetshowersandthunderpolartwilight = "heavysleetshowersandthunder_polartwilight"
    case heavysleetshowersday = "heavysleetshowers_day"
    case heavysleetshowersnight = "heavysleetshowers_night"
    case heavysleetshowerspolartwilight = "heavysleetshowers_polartwilight"
    case heavysnowshowersandthunderday = "heavysnowshowersandthunder_day"
    case heavysnowshowersandthundernight = "heavysnowshowersandthunder_night"
    case heavysnowshowersandthunderpolartwilight = "heavysnowshowersandthunder_polartwilight"
    case heavysnowshowersday = "heavysnowshowers_day"
    case heavysnowshowersnight = "heavysnowshowers_night"
    case heavysnowshowerspolartwilight = "heavysnowshowers_polartwilight"
    case lightrainshowersandthunderday = "lightrainshowersandthunder_day"
    case lightrainshowersandthundernight = "lightrainshowersandthunder_night"
    case lightrainshowersandthunderpolartwilight = "lightrainshowersandthunder_polartwilight"
    case lightrainshowersday = "lightrainshowers_day"
    case lightrainshowersnight = "lightrainshowers_night"
    case lightrainshowerspolartwilight = "lightrainshowers_polartwilight"
    case lightsleetshowersday = "lightsleetshowers_day"
    case lightsleetshowersnight = "lightsleetshowers_night"
    case lightsleetshowerspolartwilight = "lightsleetshowers_polartwilight"
    case lightsnowshowersday = "lightsnowshowers_day"
    case lightsnowshowersnight = "lightsnowshowers_night"
    case lightsnowshowerspolartwilight = "lightsnowshowers_polartwilight"
    case lightssleetshowersandthunderday = "lightssleetshowersandthunder_day"
    case lightssleetshowersandthundernight = "lightssleetshowersandthunder_night"
    case lightssleetshowersandthunderpolartwilight = "lightssleetshowersandthunder_polartwilight"
    case lightssnowshowersandthunderday = "lightssnowshowersandthunder_day"
    case lightssnowshowersandthundernight = "lightssnowshowersandthunder_night"
    case lightssnowshowersandthunderpolartwilight = "lightssnowshowersandthunder_polartwilight"
    case partlycloudyday = "partlycloudy_day"
    case partlycloudynight = "partlycloudy_night"
    case partlycloudypolartwilight = "partlycloudy_polartwilight"
    case rainshowersandthunderday = "rainshowersandthunder_day"
    case rainshowersandthundernight = "rainshowersandthunder_night"
    case rainshowersandthunderpolartwilight = "rainshowersandthunder_polartwilight"
    case rainshowersday = "rainshowers_day"
    case rainshowersnight = "rainshowers_night"
    case rainshowerspolartwilight = "rainshowers_polartwilight"
    case sleetshowersandthunderday = "sleetshowersandthunder_day"
    case sleetshowersandthundernight = "sleetshowersandthunder_night"
    case sleetshowersandthunderpolartwilight = "sleetshowersandthunder_polartwilight"
    case sleetshowersday = "sleetshowers_day"
    case sleetshowersnight = "sleetshowers_night"
    case sleetshowerspolartwilight = "sleetshowers_polartwilight"
    case snowshowersandthunderday = "snowshowersandthunder_day"
    case snowshowersandthundernight = "snowshowersandthunder_night"
    case snowshowersandthunderpolartwilight = "snowshowersandthunder_polartwilight"
    case snowshowersday = "snowshowers_day"
    case snowshowersnight = "snowshowers_night"
    case snowshowerspolartwilight = "snowshowers_polartwilight"
    case heavysnow = "heavysnow"
    case heavysnowandthunder = "heavysnowandthunder"
    case lightrain = "lightrain"
    case lightrainandthunder = "lightrainandthunder"
    case lightsleet = "lightsleet"
    case lightsleetandthunder = "lightsleetandthunder"
    case lightsnow = "lightsnow"
    case lightsnowandthunder = "lightsnowandthunder"
    case rain = "rain"
    case rainandthunder = "rainandthunder"
    case sleet = "sleet"
    case sleetandthunder = "sleetandthunder"
    case snow = "snow"
    case snowandthunder = "snowandthunder"
}

enum SymbolConfidence: String, Codable {
    case certain = "certain"
    case somewhatCertain = "somewhat certain"
    case uncertain = "uncertain"
}

// MARK: - Next1_Hours
struct Next1Hours: Codable {
    let summary: Next1HoursSummary?
    let details: Next1HoursDetails?
}

// MARK: - Next1_HoursDetails
struct Next1HoursDetails: Codable {
    let precipitationAmount: Double?
    let precipitationAmountMax: Double?
    let precipitationAmountMin: Double?
    let probabilityOfPrecipitation, probabilityOfThunder: Double?

    enum CodingKeys: String, CodingKey {
        case precipitationAmount = "precipitation_amount"
        case precipitationAmountMax = "precipitation_amount_max"
        case precipitationAmountMin = "precipitation_amount_min"
        case probabilityOfPrecipitation = "probability_of_precipitation"
        case probabilityOfThunder = "probability_of_thunder"
    }
}

// MARK: - Next1_HoursSummary
struct Next1HoursSummary: Codable {
    let symbolCode: SymbolCode?

    enum CodingKeys: String, CodingKey {
        case symbolCode = "symbol_code"
    }
}

// MARK: - Next6_Hours
struct Next6Hours: Codable {
    let summary: Next1HoursSummary?
    let details: Next6HoursDetails?
}

// MARK: - Next6_HoursDetails
struct Next6HoursDetails: Codable {
    let airTemperatureMax, airTemperatureMin, precipitationAmount, precipitationAmountMax: Double?
    let precipitationAmountMin, probabilityOfPrecipitation: Double?

    enum CodingKeys: String, CodingKey {
        case airTemperatureMax = "air_temperature_max"
        case airTemperatureMin = "air_temperature_min"
        case precipitationAmount = "precipitation_amount"
        case precipitationAmountMax = "precipitation_amount_max"
        case precipitationAmountMin = "precipitation_amount_min"
        case probabilityOfPrecipitation = "probability_of_precipitation"
    }
}



