import SwiftUI
import Foundation
import MapKit

extension Color {
    static var theme: Color  { return Color("theme") }
    static var backgroundColor: Color  { return Color("BackgroundColor") }
    static var backgroundColorWeak2: Color  { return Color("BackgroundColorWeak") }
    static var textColor: Color  { return Color("TextColor") }
    static var textColorWeak2: Color  { return Color("TextColorWeak") }
}

extension UIColor {
    static var theme: UIColor  { return UIColor(named: "theme")! }
    static var BackgroundColor: UIColor  { return UIColor(named: "BackgroundColor")! }
    static var BackgroundColorDark: UIColor  { return UIColor(named: "BackgroundColorWeak")! }
    static var TextColor: UIColor  { return UIColor(named: "TextColor")! }
    static var TextColorDark: UIColor  { return UIColor(named: "TextColorWeak")! }
}

extension ContentView {
    // COUNT NUMBER OF STATES
    func countStates() -> [String] {
        var tiGreen: Int = 0
        var tiOrange: Int = 0
        var tiRed: Int = 0
        var tiYellow: Int = 0
        var tiBlue: Int = 0
        var tiPurple: Int = 0
        var tiUnknown: Int = 0
        
        for vessel in vessels {
            switch vessel.extendedState?.statusID {
            case 0:
                tiGreen = tiGreen + 1
            case 1:
                tiOrange = tiOrange + 1
            case 3:
                tiRed = tiRed + 1
            case 4:
                tiYellow = tiYellow + 1
            case 5:
                tiBlue = tiBlue + 1
            case 6:
                tiPurple = tiPurple + 1
            default:
                tiUnknown = tiUnknown + 1
            }
        }
        
        var tempOutput: [String] = []
        tempOutput.append("\(tiGreen)")
        tempOutput.append("\(tiYellow)")
        tempOutput.append("\(tiOrange)")
        tempOutput.append("\(tiBlue)")
        tempOutput.append("\(tiRed)")
        tempOutput.append("\(tiPurple)")
        
        return tempOutput
    }
    
    // GET DATA FROM JSON AND STORE IN STATE VARIABLE
    func fetchData() async throws {
        let urlRs = URL(string: "https://prod-rsfeed-xml2json-proxy.rs-marine-services.rs.no/prefetch/getboats")!
        let requestRs = URLRequest(url: urlRs)
        let (dataRs, _) = try await URLSession.shared.data(for: requestRs)
        let allDataRs = try JSONDecoder().decode(Root.self, from: dataRs)
        
        vessels.removeAll()
        
        for vessel in allDataRs.rescueboats! {
            vessels.append(vessel)
        }
    }

    func fetchDataPos() async throws {
        
        let urlPos = URL(string: "https://prod-rsfeed-xml2json-proxy.rs-marine-services.rs.no/prefetch/iphone")!
        let requestPos = URLRequest(url: urlPos)
        let (dataPos, _) = try await URLSession.shared.data(for: requestPos)
        do {
            let allDataPos = try JSONDecoder().decode(WelcomePos.self, from: dataPos)
                
            vesselsPos.removeAll()
            
            if allDataPos.iphoneFeed.vessels.count != 0 {
                for vesselPos in allDataPos.iphoneFeed.vessels {
                    vesselsPos.append(vesselPos)
                }
                
                for index in vessels.indices {
                    for positions in vesselsPos {
                        if vessels[index].mmsi == positions.mmsi {
                            vessels[index].vesselSpeed = Double(positions.sog.value)
                            vessels[index].vesselCog = Double(positions.cog.value)
                        }
                    }
                }
                    
                
            }
        } catch {print("\(error)")}
    }
    
    func fetchBarentsWatch() async throws {
        vToken = await getToken()
        vSelectedBW.removeAll()
        
        for index in vSelectedForAis.indices {
            let vTemp = vSelectedForAis[index]
            vSelectedBW.append(await getData(token: vToken, mmsi: vTemp))
        }
        
        // Populate track
        vSelectedBW.forEach({ item in
            var vTempPos: [MKMapPoint] = []
            var vTempBW: [BW] = []
            item.forEach({ item2 in
                vTempPos.append(MKMapPoint(CLLocationCoordinate2D(latitude: item2.latitude ?? 56, longitude: item2.longitude ?? 6)))
                vTempBW.append(BW(bwSpeed: item2.speedOverGround, bwCog: item2.courseOverGround, bwLatitude: item2.latitude, bwLongitude: item2.longitude, bwHdg: item2.trueHeading, bwTime: item2.msgtime))
            })
            
            for index in vessels.indices {
                if vessels[index].mmsi == String(item[0].mmsi ?? 666) {
                    vessels[index].aistrack = vTempPos
                    vessels[index].bw = vTempBW
                }
            }
        })
    }
}

// CALCULATE POSITION X METERS FROM COORDINATE
func findNewCoordinates(bearing:Double, distanceMeters:Double, origin:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
    let distRadians = distanceMeters / (6372797.6)

    let lat1 = origin.latitude * .pi / 180
    let lon1 = origin.longitude * .pi / 180
    let bearing1 = bearing * .pi / 180

    let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing1))
    let lon2 = lon1 + atan2(sin(bearing1) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))

    return CLLocationCoordinate2D(latitude: lat2 * 180 / .pi, longitude: lon2 * 180 / .pi)
}

// RETURN STATUS ICON BASED ON VESSEL STATUS
func getStatusIcon(iiStatusCode: Int) -> String {
    switch iiStatusCode {
    case 0:
        return "🟢"
    case 1:
        return "🟠"
    case 3:
        return "🔴"
    case 4:
        return "🟡"
    case 5:
        return "🔵"
    case 6:
        return "🟣"
    default:
        return "❔"
    }
}

func findColor(iiStatusCode: Int) -> Color {
    switch iiStatusCode {
    case 0:
        return Color.green
    case 1:
        return Color.orange
    case 3:
        return Color.red
    case 4:
        return Color.yellow
    case 5:
        return Color.blue
    case 6:
        return Color.purple
    default:
        return Color.white
    }
}

func getCableMarkers(sog: Double, cog: Double, pos: CLLocationCoordinate2D) -> [CableMarker] {
    var counter = 1
    var startPos: CLLocationCoordinate2D
    var totalDistance = 1852.0 * sog
    var markerPositions: [CableMarker] = []
    
    while totalDistance > (sog/6)*1852+1 {
        startPos = findNewCoordinates(bearing: cog, distanceMeters: (sog/6)*1852 * Double(counter), origin: pos)
        
        let tempMarker = CableMarker(from: findNewCoordinates(bearing: cog + 90, distanceMeters: sog*50, origin: startPos), to: findNewCoordinates(bearing: cog - 90, distanceMeters: sog*50, origin: startPos))
        
        markerPositions.append(tempMarker)
        
        counter += 1
        totalDistance -= (sog/6)*1852
    }
    
    return markerPositions
}

func convertTime(isDateTime: String) -> String {
      let stringDate = isDateTime
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"  // EXAMPLE FROM JSON: 2023-12-13T16:00:00Z
      let dateString = dateFormatter.date(from: stringDate)
      
      if let dateTimeStamp  = dateString?.timeIntervalSince1970 {
         let date = Date(timeIntervalSince1970: TimeInterval(dateTimeStamp))
         dateFormatter.dateFormat = "EEEE d. MMMM yyyy"
         dateFormatter.timeZone = TimeZone(identifier: NSTimeZone.default.identifier)
          dateFormatter.locale = Locale(identifier: "nb_NO")
         let localDate = dateFormatter.string(from: date)
         return localDate
      }
      return ""
}

func adjustedDateTime(_ hourOffset: Int) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
    
    let calendar = Calendar.current
    let currentDate = Date()
    
    if let adjustedDate = calendar.date(byAdding: .hour, value: hourOffset, to: currentDate) {
        return dateFormatter.string(from: adjustedDate)
    } else {
        return "Error occurred while adjusting date"
    }
}

func createLine(loggedPoints: [BarentsWatch]) -> MapPolyline {
    var vArray: [MKMapPoint] = []
    loggedPoints.forEach({ loggedPoint in
        vArray.append(MKMapPoint(CLLocationCoordinate2D(latitude: loggedPoint.latitude ?? 56, longitude: loggedPoint.longitude ?? 6)))
    })
    
    if vArray.count > 0 {
        return MapPolyline(points: vArray)
    } else {
        return MapPolyline(coordinates: [CLLocationCoordinate2D(latitude: 58, longitude: 8), CLLocationCoordinate2D(latitude: 57, longitude: 7)])
    }
}

func getToken() async -> String {
    let data = NSMutableData(data: "client_id=preben.loite@rs.no:RSoperativ".data(using: .utf8)!)
    data.append("&scope=ais".data(using: .utf8)!)
    data.append("&client_secret=rsoperativrsoperativ".data(using: .utf8)!)
    data.append("&grant_type=client_credentials".data(using: .utf8)!)
        
    let url = URL(string: "https://id.barentswatch.no/connect/token")!
    let headers = [
        "Content-Type": "application/x-www-form-urlencoded"
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = data as Data
    
    do {
        let (dataBw, _) = try await URLSession.shared.data(for: request)
        let jsonDataBw = try JSONDecoder().decode(Token.self, from: dataBw)
        return jsonDataBw.accessToken
    } catch {
        return "Token not found"
    }
}

func getData(token: String, mmsi: String) async -> [BarentsWatch] {
    let url = URL(string: "https://historic.ais.barentswatch.no/v1/historic/trackslast24hours/\(mmsi)")!
    let headers = ["Authorization": "Bearer \(token)"]
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = headers
    
    do {
        let (dataBw, _) = try await URLSession.shared.data(for: request)
        let jsonDataBw = try JSONDecoder().decode([BarentsWatch].self, from: dataBw)
        return jsonDataBw
    } catch {
        print(error)
        return [BarentsWatch(courseOverGround: 0, latitude: 0, longitude: 0, name: "", rateOfTurn: 0, shipType: 0, speedOverGround: 0, trueHeading: 0, navigationalStatus: 0, mmsi: 0, msgtime: "")]
    }
}
