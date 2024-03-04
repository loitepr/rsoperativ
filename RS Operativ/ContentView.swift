//
//  ContentView.swift
//  RS Operativ
//
//  Created by Preben Løite on 08/12/2023.
//

import SwiftUI
import SwiftData
import MapKit
import Charts
import XMLCoder

struct ContentView: View {
    @State var vessels: [Rescueboat] = []
    @State var vesselsPos: [VesselPos] = []
    
    @State var animation = 1.0
    @State var visible = false
    
    @State var vToken = String()
    @State var vSelectedForAis: [String] = []
    @State var vSelectedBW: [[BarentsWatch]] = [[]]
    @State var vArray: [[MKMapPoint]] = [[]]

    
    let gradient = LinearGradient(colors: [.black, .orange, .red], startPoint: .leading, endPoint: .trailing)
    let stroke = StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round)

    @AppStorage("isExpanded1", store: .standard) var isExpanded1: Bool = false
    @AppStorage("isExpanded2", store: .standard) var isExpanded2: Bool = false
    @AppStorage("isExpanded3", store: .standard) var isExpanded3: Bool = false
    @AppStorage("isExpanded4", store: .standard) var isExpanded4: Bool = false
    @AppStorage("isExpanded5", store: .standard) var isExpanded5: Bool = false
    @AppStorage("isExpanded6", store: .standard) var isExpanded6: Bool = false
    @AppStorage("isExpanded7", store: .standard) var isExpanded7: Bool = false
    @AppStorage("isExpanded8", store: .standard) var isExpanded8: Bool = false
    @AppStorage("selectedNight", store: .standard) var selectedNight: Bool = false
    @AppStorage("selectedDetailed", store: .standard) var selectedDetailed: Bool = true
    @AppStorage("selectedWithSpeed", store: .standard) var selectedWithSpeed: Bool = false
    @AppStorage("selectedNameInMap", store: .standard) var selectedNameInMap: Bool = true
    @AppStorage("selectedMap", store: .standard) var selectedMap: String = "hybrid"
    @AppStorage("favStation", store: .standard) var favStation: String = ""
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State var selectedMapStyle: MapStyle = .hybrid
    @State var mySelection: Rescueboat?
    @State var selectedPoint: BW?

    class SheetMananger: ObservableObject{
        @Published var showSheet = false
        @Published var showSheet2 = false
    }

    @StateObject var sheetManager = SheetMananger()
    
    @State var vShowPopup = false
    
    @State var stationList: [String] = []
    
    @AppStorage("isOperativ", store: .standard) var isOperativ: Bool = true
    @AppStorage("isPrepared", store: .standard) var isPrepared: Bool = true
    @AppStorage("isInOp", store: .standard) var isInOp: Bool = false
    @AppStorage("isMission", store: .standard) var isMission: Bool = true
    @AppStorage("isSarOnly", store: .standard) var isSarOnly: Bool = true
    @AppStorage("isTeamAlert", store: .standard) var isTeamAlert: Bool = true
    
    var body: some View {
        TabView {
            NavigationStack {
                Text("Skøytestatus").font(.title).foregroundStyle(Color.textColor)
                List {
                    // FAST BEMANNET
                    Section(isExpanded: $isExpanded1, content: {
                        ForEach(vessels, id: \.id) { vessel in
                            if (vessel.vesselTypeTxt == .fastBemannet && vessel.station?.code != "86") {
                                HStack {
                                    NavigationLink {
                                        VesselView(selectedVessel: vessel)
                                    } label: {
                                        Text("\(getStatusIcon(iiStatusCode:(vessel.extendedState?.statusID)!))")
                                        VStack(alignment: .leading) {
                                            Text("\(vessel.name!)").foregroundStyle(Color.textColor)
                                            if selectedDetailed {Text("\(vessel.station?.name ?? "ukjent")").foregroundStyle(Color.textColorWeak2)}
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }, header: {
                        Text("Fast bemannet").foregroundStyle(Color.textColor)
                    })
                    .listRowBackground(Color.backgroundColorWeak2)
                    .listRowSeparatorTint(Color.textColorWeak2)
                    .foregroundStyle(Color.textColor)
                    .tint(Color.textColor)
                    
                    // FRIVILLIG BEMANNET
                    Section(isExpanded: $isExpanded2, content: {
                        ForEach(vessels, id: \.id) { vessel in
                            if (vessel.vesselTypeTxt == .sjøredningskorps && vessel.station?.code != "86") {
                                HStack {
                                    NavigationLink {
                                        VesselView(selectedVessel: vessel)
                                    } label: {
                                        Text("\(getStatusIcon(iiStatusCode:(vessel.extendedState?.statusID)!))").foregroundStyle(Color.textColor)
                                        VStack(alignment: .leading) {
                                            Text("\(vessel.name!)").foregroundStyle(Color.textColor)
                                            if selectedDetailed {Text("\(vessel.station?.name ?? "ukjent")").foregroundStyle(Color.textColorWeak2)}
                                        }
                                    }
                                }
                            }
                        }
                    }, header: {
                        Text("Frivillig bemannet").foregroundStyle(Color.textColor)
                    })
                    .listRowBackground(Color.backgroundColorWeak2)
                    .listRowSeparatorTint(Color.textColorWeak2)
                    .foregroundStyle(Color.textColor)
                    .tint(Color.textColor)
                    
                    // STØTTEFARTØY
                    Section(isExpanded: $isExpanded3, content: {
                        ForEach(vessels, id: \.id) { vessel in
                            if (vessel.vesselTypeTxt == .støttefartøy && vessel.station?.code != "86") {
                                HStack {
                                    NavigationLink {
                                        VesselView(selectedVessel: vessel)
                                    } label: {
                                        Text("\(getStatusIcon(iiStatusCode:(vessel.extendedState?.statusID)!))").foregroundStyle(Color.textColor)
                                        VStack(alignment: .leading) {
                                            Text("\(vessel.name!)").foregroundStyle(Color.textColor)
                                            if selectedDetailed {Text("\(vessel.station?.name ?? "ukjent")").foregroundStyle(Color.textColorWeak2)}
                                        }
                                    }
                                }
                            }
                        }
                    }, header: {
                        Text("Støttefartøy").foregroundStyle(Color.textColor)
                    })
                    .listRowBackground(Color.backgroundColorWeak2)
                    .listRowSeparatorTint(Color.textColorWeak2)
                    .foregroundStyle(Color.textColor)
                    .tint(Color.textColor)
                    
                    // AMBULANSEBÅTER
                    Section(isExpanded: $isExpanded4, content: {
                        ForEach(vessels, id: \.id) { vessel in
                            if (vessel.vesselTypeTxt == .ambulanse && vessel.station?.code != "86") {
                                HStack {
                                    NavigationLink {
                                        VesselView(selectedVessel: vessel)
                                    } label: {
                                        Text("\(getStatusIcon(iiStatusCode:(vessel.extendedState?.statusID)!))").foregroundStyle(Color.textColor)
                                        VStack(alignment: .leading) {
                                            Text("\(vessel.name!)").foregroundStyle(Color.textColor)
                                            if selectedDetailed {Text("\(vessel.station?.name ?? "ukjent")").foregroundStyle(Color.textColorWeak2)}
                                        }
                                    }
                                }
                            }
                        }
                    }, header: {
                        Text("Ambulanse").foregroundStyle(Color.textColor)
                    })
                    .listRowBackground(Color.backgroundColorWeak2)
                    .listRowSeparatorTint(Color.textColorWeak2)
                    .foregroundStyle(Color.textColor)
                    .tint(Color.textColor)
                    
                    // PÅ VERKSTED
                    Section(isExpanded: $isExpanded5, content: {
                        ForEach(vessels, id: \.id) { vessel in
                            if vessel.station?.code == "86" {
                                HStack {
                                    NavigationLink {
                                        VesselView(selectedVessel: vessel)
                                    } label: {
                                        Text("\(getStatusIcon(iiStatusCode:(vessel.extendedState?.statusID)!))").foregroundStyle(Color.textColor)
                                        VStack(alignment: .leading) {
                                            Text("\(vessel.name!)").foregroundStyle(Color.textColor)
                                        }
                                    }
                                }
                            }
                        }
                    }, header: {
                        Text("Verksted/opplag").foregroundStyle(Color.textColor)
                    })
                    .listRowBackground(Color.backgroundColorWeak2)
                    .listRowSeparatorTint(Color.textColorWeak2)
                    .foregroundStyle(Color.textColor)
                    .tint(Color.textColor)
                        
                    // MINE FAVORITTER
                    Section(isExpanded: $isExpanded8, content: {
                        ForEach(vessels, id: \.id) { vessel in
                            if (favStation.range(of: vessel.station?.name ?? "", options: .caseInsensitive) != nil) == true {
                                HStack {
                                    NavigationLink {
                                        VesselView(selectedVessel: vessel)
                                    } label: {
                                        Text("\(getStatusIcon(iiStatusCode:(vessel.extendedState?.statusID)!))").foregroundStyle(Color.textColor)
                                        VStack(alignment: .leading) {
                                            Text("\(vessel.name!)").foregroundStyle(Color.textColor)
                                            if selectedDetailed {Text("\(vessel.station?.name ?? "ukjent")").foregroundStyle(Color.textColorWeak2)}
                                        }
                                    }
                                }
                            }
                        }
                    }, header: {
                        Text("Mine favoritter").foregroundStyle(Color.textColor)
                    })
                    .listRowBackground(Color.backgroundColorWeak2)
                    .listRowSeparatorTint(Color.textColorWeak2)
                    .foregroundStyle(Color.textColor)
                    .tint(Color.textColor)
                    
                    // FOOTER
                    Section(footer:
                        HStack {
                            Spacer()
                            VStack(alignment: .center) {
                                Text("Dra ned for å oppdatere.").font(.footnote).foregroundStyle(Color.textColorWeak2).opacity(0.5)
                                Image(systemName: "arrow.down")
                                    .resizable()
                                    .foregroundStyle((Color.textColorWeak2)
                                    .opacity(0.3))
                                    .frame(width: 30, height: 30)
                                Spacer()
                            }
                            Spacer()
                        }
                    ) {
                        //
                    }
                }
                .listStyle(.sidebar)
                .scrollContentBackground(.hidden)
                .background(Color.backgroundColor)
                .foregroundStyle(Color.textColor)
                .task {
                    do {
                        try await fetchData()
                    } catch {}
                    do {
                        try await fetchDataPos()
                    } catch {}
                }
                .onAppear {
                    UIRefreshControl.appearance().tintColor = UIColor.TextColor
                    UIRefreshControl.appearance().attributedTitle = NSAttributedString(attributedString: NSAttributedString(string: "Oppdaterer…", attributes: [.foregroundColor: UIColor.TextColor]))
                }
                .refreshable {
                    do {
                        try await fetchData()
                    } catch {}
                    do {
                        try await fetchDataPos()
                    } catch {}
                }
            }.tabItem { Label("Skøytene", systemImage: "sailboat.fill") }
            .preferredColorScheme(selectedNight ? .dark : .light)
            .backgroundStyle(Color.backgroundColor)
            
            // GRAPH
            VStack {
                Text("Oppsummert").font(.title).foregroundStyle(Color.textColor)
                Chart {
                    BarMark(
                        x: .value("Type", "Operative"),
                        y: .value("Antall", Int(countStates()[0]) ?? 0)
                    )
                    .foregroundStyle(Color.green)
                    .annotation(position: .top, alignment: .bottom) { Text(countStates()[0]).foregroundStyle(Color.textColor) }
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    BarMark(
                        x: .value("Type", "Oppdrag"),
                        y: .value("Antall", Int(countStates()[1]) ?? 0)
                    )
                    .foregroundStyle(Color.yellow)
                    .annotation(position: .top, alignment: .bottom) { Text(countStates()[1]).foregroundStyle(Color.textColor) }
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    BarMark(
                        x: .value("Type", "Beredskap"),
                        y: .value("Antall", Int(countStates()[2]) ?? 0)
                    )
                    .foregroundStyle(Color.orange)
                    .annotation(position: .top, alignment: .bottom) { Text(countStates()[2]).foregroundStyle(Color.textColor) }
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    BarMark(
                        x: .value("Type", "Kun SAR"),
                        y: .value("Antall", Int(countStates()[3]) ?? 0)
                    )
                    .foregroundStyle(Color.blue)
                    .annotation(position: .top, alignment: .bottom) { Text(countStates()[3]).foregroundStyle(Color.textColor) }
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    BarMark(
                        x: .value("Type", "Team Alert"),
                        y: .value("Antall", Int(countStates()[5]) ?? 0)
                    )
                    .foregroundStyle(Color.purple)
                    .annotation(position: .top, alignment: .bottom) { Text(countStates()[5]).foregroundStyle(Color.textColor) }
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    BarMark(
                        x: .value("Type", "UAD"),
                        y: .value("Antall", Int(countStates()[4]) ?? 0)
                    )
                    .foregroundStyle(Color.red)
                    .annotation(position: .top, alignment: .bottom) { Text(countStates()[4]).foregroundStyle(Color.textColor) }
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .backgroundStyle(Color.backgroundColor)
                .chartYAxis {
                    AxisMarks() {
                        AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2])).foregroundStyle(Color.textColorWeak2)
                        AxisTick(centered: true, stroke: StrokeStyle(lineWidth: 0)).foregroundStyle(Color.textColor)
                        AxisValueLabel().foregroundStyle(Color.textColor)
                    }
                }
                .chartXAxis {
                    AxisMarks() {
                        AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 0)).foregroundStyle(Color.textColorWeak2)
                        AxisTick(centered: true, stroke: StrokeStyle(lineWidth: 0)).foregroundStyle(Color.textColor)
                        AxisValueLabel().foregroundStyle(Color.textColor)
                    }
                }
            }.tabItem { Label("Oppsummert", systemImage: "chart.bar.xaxis") }
            
            // MAP OVERVIEW
            ZStack {
                Map(interactionModes: [.pan, .zoom]) {
                    ForEach(vessels, id: \.id) { vessel in
                        if ((((isOperativ && (vessel.extendedState?.statusID == 0)) || (isPrepared && (vessel.extendedState?.statusID == 1)) || (isInOp && (vessel.extendedState?.statusID == 3)) ||  (isSarOnly && (vessel.extendedState?.statusID == 5)) ||  (isMission && (vessel.extendedState?.statusID == 4)) || (isTeamAlert && (vessel.extendedState?.statusID == 6))) && NSString(string: (vessel.koordinater?.decimalLatitude ?? "")).doubleValue > 1)) {
                                
                            let vesselPosition = CLLocationCoordinate2D(latitude: NSString(string: (vessel.koordinater?.decimalLatitude ?? "")).doubleValue, longitude: NSString(string: (vessel.koordinater?.decimalLongitude ?? "")).doubleValue)
                                
                            
                            if (selectedWithSpeed == false) || (selectedWithSpeed && Double(vessel.vesselSpeed ?? 0.0) > 0.5) {
                                MapCircle(center: vesselPosition, radius: 1852).foregroundStyle(findColor(iiStatusCode: (vessel.extendedState?.statusID)!).opacity(0.15))
                                
                                if selectedNameInMap {
                                    Annotation(Double(vessel.vesselSpeed ?? 0.0) > 0.5 ? "\(vessel.name!) (\(Double(vessel.vesselSpeed ?? 0.0)) kn)" : vessel.name!, coordinate: vesselPosition, anchor: .center) {
                                        Text("⌾")
                                            .font(.footnote)
                                            .scaledToFit()
                                            .padding(0)
                                            .frame(width: 14, height: 14)
                                            .foregroundStyle(Color.black)
                                            .background(findColor(iiStatusCode: (vessel.extendedState?.statusID)!))
                                            .clipShape(Circle())
                                            .onTapGesture(perform: {
                                                mySelection = vessel
                                                sheetManager.showSheet.toggle()
                                            })
                                    }
                                } else {
                                    Annotation(Double(vessel.vesselSpeed ?? 0.0) > 0.5 ? "RS\(String(describing: vessel.rs ?? "")) (\(Double(vessel.vesselSpeed ?? 0.0)) kn)" : "RS\(String(describing: vessel.rs ?? ""))", coordinate: vesselPosition, anchor: .center) {
                                        Text("⌾")
                                            .font(.footnote)
                                            .scaledToFit()
                                            .padding(0)
                                            .frame(width: 14, height: 14)
                                            .foregroundStyle(Color.black)
                                            .background(findColor(iiStatusCode: (vessel.extendedState?.statusID)!))
                                            .clipShape(Circle())
                                            .onTapGesture(perform: {
                                                mySelection = vessel
                                                sheetManager.showSheet.toggle()
                                            })
                                    }
                                }
                            }
                            
                            // Add 1-hour heading marker and mark for each 10 min with current speed
                            let tCog = Double(vessel.vesselCog ?? 0.0)
                            let tSog = Double(vessel.vesselSpeed ?? 0.0)
                        
                            if Double(vessel.vesselSpeed ?? 0.0) > 0.5 {
                                // 1-hour marker
                                MapPolyline(coordinates: [vesselPosition, findNewCoordinates(bearing: tCog, distanceMeters: 1852 * tSog, origin: vesselPosition)]).stroke(findColor(iiStatusCode: (vessel.extendedState?.statusID)!), lineWidth: 2.0)
                                
                                // Cable markers
                                ForEach(getCableMarkers(sog: Double(vessel.vesselSpeed ?? 0.0), cog: Double(vessel.vesselCog ?? 0.0), pos: vesselPosition)) { cableMark in
                                    MapPolyline(coordinates: [cableMark.from, cableMark.to]).stroke(findColor(iiStatusCode: (vessel.extendedState?.statusID)!), lineWidth: 2.0)
                                }
                                
                                // Arrowhead
                                let startPos = findNewCoordinates(bearing: tCog, distanceMeters: 1852 * tSog, origin: vesselPosition)
                                let leftCorner = findNewCoordinates(bearing: tCog - 90, distanceMeters: tSog*50, origin: startPos)
                                let tip = findNewCoordinates(bearing: tCog, distanceMeters: tSog*100, origin: startPos)
                                let rightCorner = findNewCoordinates(bearing: tCog + 90, distanceMeters: tSog*50, origin: startPos)
                                MapPolygon(coordinates: [startPos, leftCorner, tip, rightCorner, startPos]).stroke(findColor(iiStatusCode: (vessel.extendedState?.statusID)!), lineWidth: 2.0).foregroundStyle(findColor(iiStatusCode: (vessel.extendedState?.statusID)!))
                            }
                        }
                    }
                }
                .sheet(isPresented: $sheetManager.showSheet) {
                    if ((mySelection?.name ?? "") != "") && mySelection != nil {
                        VesselView(selectedVessel: mySelection!)
                    }
                }
                .onAppear(perform: {
                    switch selectedMap {
                        case "standard": selectedMapStyle = .standard
                        case "hybrid": selectedMapStyle = .hybrid
                        case "imagery": selectedMapStyle = .imagery
                        default: selectedMapStyle = .standard
                    }
                })
                .mapStyle(self.selectedMapStyle)
                .mapControls {
                    MapCompass()
                    MapScaleView()
                }
                
                VStack {
                    Spacer()
                    Image(systemName: "arrow.clockwise").foregroundStyle(Color.textColor)
                        .onTapGesture(perform: {
                            Task {
                                do {
                                    try await fetchData()
                                } catch {}
                                do {
                                    try await fetchDataPos()
                                } catch {}
                            }
                        })
                    .frame(width: 70, height: 35)
                    .padding(5)
                    .background(
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                    )
                    
                }.padding(10)
                
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Toggle(isOn: $isOperativ) {Text("🟢 Operative på stasjon").foregroundStyle(Color.textColor)}.toggleStyle(customCheckbox()).padding(1).font(.footnote)
                                Toggle(isOn: $isPrepared) {Text("🟠 30/60 min beredskap").foregroundStyle(Color.textColor)}.toggleStyle(customCheckbox()).padding(1).font(.footnote)
                                Toggle(isOn: $isMission) {Text("🟡 Ute på oppdrag").foregroundStyle(Color.textColor)}.toggleStyle(customCheckbox()).padding(1).font(.footnote)
                                Toggle(isOn: $isSarOnly) {Text("🔵 Kun SAR-oppdrag").foregroundStyle(Color.textColor)}.toggleStyle(customCheckbox()).padding(1).font(.footnote)
                                Toggle(isOn: $isTeamAlert) {Text("🟣 Team Alert (Q1 2024)").foregroundStyle(Color.textColor)}.toggleStyle(customCheckbox()).padding(1).font(.footnote)
                                Toggle(isOn: $isInOp) {Text("🔴 Ute av drift").foregroundStyle(Color.textColor)}.toggleStyle(customCheckbox()).padding(1).font(.footnote)
                                Text("Vektorene er 1 time lange og").foregroundStyle(Color.textColor).font(.footnote)
                                Text("har merker hvert 10. minutt.").foregroundStyle(Color.textColor).font(.footnote)
                            }
                            .padding()
                            .frame(alignment: .leading)
                            .background(
                                .ultraThinMaterial,
                                in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                            
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
            }
            .tabItem { Label("Kart", systemImage: "location.fill.viewfinder")}
            
            // ANALYZE AREA
            ZStack {
                Map(interactionModes: [.pan, .zoom]) {
                    ForEach(vessels, id: \.id) { vessel in
                        if ((((isOperativ && (vessel.extendedState?.statusID == 0)) || (isPrepared && (vessel.extendedState?.statusID == 1)) || (isInOp && (vessel.extendedState?.statusID == 3)) ||  (isSarOnly && (vessel.extendedState?.statusID == 5)) ||  (isMission && (vessel.extendedState?.statusID == 4)) || (isTeamAlert && (vessel.extendedState?.statusID == 6))) && NSString(string: (vessel.koordinater?.decimalLatitude ?? "")).doubleValue > 1)) {
                            
                            let vesselPosition = CLLocationCoordinate2D(latitude: NSString(string: (vessel.koordinater?.decimalLatitude ?? "")).doubleValue, longitude: NSString(string: (vessel.koordinater?.decimalLongitude ?? "")).doubleValue)
                            
                            if (selectedWithSpeed == false) || (selectedWithSpeed && Double(vessel.vesselSpeed ?? 0.0) > 0.5) {
                                if selectedNameInMap {
                                    Annotation(Double(vessel.vesselSpeed ?? 0.0) > 0.5 ? "\(vessel.name!) (\(Double(vessel.vesselSpeed ?? 0.0)) kn)" : vessel.name!, coordinate: vesselPosition, anchor: .center) {
                                        Text("⌾")
                                            .font(.footnote)
                                            .scaledToFit()
                                            .padding(0)
                                            .frame(width: 14, height: 14)
                                            .foregroundStyle(Color.black)
                                            .background(findColor(iiStatusCode: (vessel.extendedState?.statusID)!))
                                            .clipShape(Circle())
                                            .onTapGesture(perform: {
                                                vSelectedForAis.append(vessel.mmsi!)
                                            })
                                    }
                                } else {
                                    Annotation(Double(vessel.vesselSpeed ?? 0.0) > 0.5 ? "RS\(String(describing: vessel.rs ?? "")) (\(Double(vessel.vesselSpeed ?? 0.0)) kn)" : "RS\(String(describing: vessel.rs ?? ""))", coordinate: vesselPosition, anchor: .center) {
                                        Text("⌾")
                                            .font(.footnote)
                                            .scaledToFit()
                                            .padding(0)
                                            .frame(width: 14, height: 14)
                                            .foregroundStyle(Color.black)
                                            .background(findColor(iiStatusCode: (vessel.extendedState?.statusID)!))
                                            .clipShape(Circle())
                                            .onTapGesture(perform: {
                                                vSelectedForAis.append(vessel.mmsi!)
                                            })
                                    }
                                }
                            }
                            
                            // Add 1-hour heading marker and mark for each 10 min with current speed
                            let tCog = Double(vessel.vesselCog ?? 0.0)
                            let tSog = Double(vessel.vesselSpeed ?? 0.0)
                            
                            if Double(vessel.vesselSpeed ?? 0.0) > 0.5 {
                                // 1-hour marker
                                MapPolyline(coordinates: [vesselPosition, findNewCoordinates(bearing: tCog, distanceMeters: 1852 * tSog, origin: vesselPosition)]).stroke(findColor(iiStatusCode: (vessel.extendedState?.statusID)!), lineWidth: 2.0)
                                
                                // Cable markers
                                ForEach(getCableMarkers(sog: Double(vessel.vesselSpeed ?? 0.0), cog: Double(vessel.vesselCog ?? 0.0), pos: vesselPosition)) { cableMark in
                                    MapPolyline(coordinates: [cableMark.from, cableMark.to]).stroke(findColor(iiStatusCode: (vessel.extendedState?.statusID)!), lineWidth: 2.0)
                                }
                                
                                // Arrowhead
                                let startPos = findNewCoordinates(bearing: tCog, distanceMeters: 1852 * tSog, origin: vesselPosition)
                                let leftCorner = findNewCoordinates(bearing: tCog - 90, distanceMeters: tSog*50, origin: startPos)
                                let tip = findNewCoordinates(bearing: tCog, distanceMeters: tSog*100, origin: startPos)
                                let rightCorner = findNewCoordinates(bearing: tCog + 90, distanceMeters: tSog*50, origin: startPos)
                                MapPolygon(coordinates: [startPos, leftCorner, tip, rightCorner, startPos]).stroke(findColor(iiStatusCode: (vessel.extendedState?.statusID)!), lineWidth: 2.0).foregroundStyle(findColor(iiStatusCode: (vessel.extendedState?.statusID)!))
                            }
                            
                            if vessel.aistrack != nil {
                                MapPolyline(points: (vessel.aistrack)!).stroke(.red, lineWidth: 2)
                            }
                            
                            if vessel.bw != nil {
                                ForEach(vessel.bw ?? [BW(bwSpeed: 0.0)], id: \.id) { bwData in //ForEach(vessel.bw!, id: \.id) { bwData in
                                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: bwData.bwLatitude ?? 56.0, longitude: bwData.bwLongitude ?? 6.0), anchor: .center, content: {
                                        //MapCircle(center: CLLocationCoordinate2D(latitude: bwData.bwLatitude ?? 56.0, longitude: bwData.bwLongitude ?? 6.0), radius: 10)
                                        Text("↑").foregroundStyle(.black).font(.footnote)
                                            .onTapGesture(perform: { vShowPopup.toggle() })
                                            .popover(isPresented: $vShowPopup,
                                                 attachmentAnchor: .point(.center),
                                                 arrowEdge: .top,
                                                 content: {
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: 8).foregroundStyle(.white)
                                                        VStack {
                                                            Text("Fart: 32.5 kn").foregroundStyle(.white).font(.footnote)
                                                            Text("Heading: 350°").foregroundStyle(.white).font(.footnote)
                                                            Text("Kurs: 349°").foregroundStyle(.white).font(.footnote)
                                                        }.padding(10)
                                                    }.presentationCompactAdaptation(.none)
                                        })
                                    })
                                }
                            }
                        }
                        
                    }
                }
                .onAppear(perform: {
                    switch selectedMap {
                    case "standard": selectedMapStyle = .standard
                    case "hybrid": selectedMapStyle = .hybrid
                    case "imagery": selectedMapStyle = .imagery
                    default: selectedMapStyle = .standard
                    }
                })
                .task(id: vSelectedForAis) {
                    do {
                        try await fetchData()
                    } catch {}
                    do {
                        try await fetchDataPos()
                    } catch {}
                    do {
                        try await fetchBarentsWatch()
                    } catch {}
                }
                .mapStyle(self.selectedMapStyle)
                .mapControls {
                    MapCompass()
                    MapScaleView()
                }
                
                VStack {
                    Spacer()
                    Image(systemName: "arrow.clockwise").foregroundStyle(Color.textColor)
                        .onTapGesture(perform: {
                            Task {
                                do {
                                    try await fetchData()
                                } catch {}
                                do {
                                    try await fetchDataPos()
                                } catch {}
                                do {
                                    try await fetchBarentsWatch()
                                } catch {}
                            }
                        })
                    .frame(width: 70, height: 35)
                    .padding(5)
                    .background(
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                    )
                    
                }.padding(10)
            }
            .tabItem { Label("Spor", systemImage: "dot.circle.and.hand.point.up.left.fill")}
            
            // SETTINGS
            NavigationView {
                List {
                    Section(content: {
                        Toggle(isOn: $selectedNameInMap) {
                            Text("Vis navn i kart").foregroundStyle(Color.textColor) }
                        .tint(Color.textColor)
                        .backgroundStyle(Color.backgroundColorWeak2)
                        
                        Toggle(isOn: $selectedWithSpeed) {
                            Text("Vis kun i bevegelse").foregroundStyle(Color.textColor) }
                        .tint(Color.textColor)
                        .backgroundStyle(Color.backgroundColorWeak2)
                        
                        Picker("Karttype", selection: $selectedMap, content: {
                            Text("Standard").tag("standard")
                            Text("Hybrid").tag("hybrid")
                            Text("Satellit").tag("imagery")})
                        .tint(Color.textColor)
                        .foregroundStyle(Color.textColor)
                        .backgroundStyle(Color.backgroundColorWeak2)
                    }, header: {
                        Text("Kart").foregroundStyle(Color.textColor)
                    })
                    .listRowBackground(Color.backgroundColorWeak2)
                    .listRowSeparatorTint(Color.textColorWeak2)
                    .foregroundStyle(Color.textColor)
                    .tint(Color.textColor)
                    
                    Section(content: {
                        Toggle(isOn: $selectedNight) {
                            Text("Nattmodus").foregroundStyle(Color.textColor).tint(Color.textColor)}
                        .tint(Color.textColor)
                        .onChange(of: selectedNight) {
                            (UIApplication.shared.connectedScenes.first as?
                             UIWindowScene)?.windows.first!.overrideUserInterfaceStyle = selectedNight ?   .dark : .light
                            UserDefaultsUtils.shared.setDarkMode(enable: selectedNight)}
                        
                        Toggle(isOn: $selectedDetailed) {
                            Text("Vis stasjonsnavn i liste").foregroundStyle(Color.textColor) }
                        .tint(Color.textColor)
                        .backgroundStyle(Color.backgroundColorWeak2)
                        
                        NavigationLink {
                            NavigationView {
                                List {
                                    ForEach(stationList, id: \.self) { string in
                                        HStack {
                                            Text(string).foregroundStyle(Color.textColor)
                                            Spacer()
                                            Button(action: {
                                                if (favStation.range(of: string, options: .caseInsensitive) != nil) == true {
                                                    favStation = favStation.replacingOccurrences(of: string, with: "")
                                                } else {
                                                    favStation = "\(favStation)\(string)"
                                                }
                                            }, label: {
                                                if (favStation.range(of: string, options: .caseInsensitive) != nil) == true {
                                                    Text("❤️")
                                                } else {
                                                    Text("🖤")
                                                }
                                            })
                                        }
                                    }
                                }
                            }
                        } label: {
                            Text("Mine stasjoner")
                        }
                        .task {
                            vessels.forEach { vessel in //ForEach(vessels, id: \.id) { vessel in
                                let itemExists = stationList.contains(where: {
                                    $0.range(of: (vessel.station?.name!)!, options: .caseInsensitive) != nil
                                })
                        
                                if itemExists != true {
                                    stationList.append("\(vessel.station?.name! ?? "")")
                                }
                            }
                        }
                            
                        NavigationLink {
                            VStack {
                                Text("Om").font(.title).foregroundStyle(Color.textColor)
                                Text("Appen er utviklet på privat initativ og basert på åpne data. Redningsselskapet er ikke ansvarlige.").frame(maxWidth: .infinity, alignment: .leading).font(.footnote).foregroundStyle(Color.textColorWeak2)
                                Divider().foregroundStyle(Color.textColorWeak2)
                                Text("Noe data er lisensiert under norsk lisens for offentlige data (NLOD) og Creative Commons 4.0 BY Internasjonal. Blant annet data fra Meteorologisk Institutt. Kildene kan du finne på met.no").frame(maxWidth: .infinity, alignment: .leading).font(.footnote).foregroundStyle(Color.textColorWeak2)
                                Divider().foregroundStyle(Color.textColorWeak2)
                                Text("Værikoner er lisensiert under MIT License (MIT). Copyright © 2015-2017 Yr.no.").frame(maxWidth: .infinity, alignment: .leading).font(.footnote).foregroundStyle(Color.textColorWeak2)
                                Divider().foregroundStyle(Color.textColorWeak2)
                                Text("Tidevannet er hentet fra Kartverket og lisensiert etter CC BY 4.0. © Kartverket").frame(maxWidth: .infinity, alignment: .leading).font(.footnote).foregroundStyle(Color.textColorWeak2)
                                Divider().foregroundStyle(Color.textColorWeak2)
                                Text("Data om redningsskøytene hentes fra: https://prod-rsfeed-xml2json-proxy.rs-marine-services.rs.no").frame(maxWidth: .infinity, alignment: .leading).font(.footnote).foregroundStyle(Color.textColorWeak2)
                                Spacer()
                            }.padding()
                        } label: {
                            Text("Om")
                        }
                    }, header: {
                        Text("Generelt").foregroundStyle(Color.textColor)
                    })
                    .listRowBackground(Color.backgroundColorWeak2)
                    .listRowSeparatorTint(Color.textColorWeak2)
                    .foregroundStyle(Color.textColor)
                    .tint(Color.textColor)
                }
                .listStyle(.sidebar)
                .scrollContentBackground(.hidden)
                .background(Color.backgroundColor)
                .foregroundStyle(Color.textColor)
            }.tint(Color.textColor).tabItem { Label("Innstillinger", systemImage: "gearshape.fill").tint(Color.textColor) }
        }
        .tint(Color.textColor)
        .backgroundStyle(Color.backgroundColor)
        .preferredColorScheme(selectedNight ? .dark : .light)
    }
}

struct VesselView: View {
    @State var selectedVessel: Rescueboat
    
    @AppStorage("isExpanded1", store: .standard) var isExpanded1: Bool = false
    @AppStorage("isExpanded2", store: .standard) var isExpanded2: Bool = false
    @AppStorage("isExpanded3", store: .standard) var isExpanded3: Bool = false
    @AppStorage("isExpanded4", store: .standard) var isExpanded4: Bool = false
    @AppStorage("isExpanded5", store: .standard) var isExpanded5: Bool = false
    @AppStorage("isExpanded6", store: .standard) var isExpanded6: Bool = false
    @AppStorage("isExpanded7", store: .standard) var isExpanded7: Bool = true
    @AppStorage("selectedNight", store: .standard) var selectedNight: Bool = false
    @AppStorage("selectedDetailed", store: .standard) var selectedDetailed: Bool = false
    @AppStorage("selectedMap", store: .standard) var selectedMap: String = "hybrid"
    
    @State var selectedMapStyle: MapStyle = .hybrid
    
    var body: some View {
        let vesselPosition = CLLocationCoordinate2D(latitude: NSString(string: (selectedVessel.koordinater?.decimalLatitude ?? "")).doubleValue, longitude: NSString(string: (selectedVessel.koordinater?.decimalLongitude ?? "")).doubleValue)
        
        ZStack {
            ScrollView {
                VStack() {
                    ZStack {
                        Map(interactionModes: [.pan, .zoom]) {
                            if selectedVessel.koordinater?.decimalLatitude != nil {
                                MapCircle(center: vesselPosition, radius: CLLocationDistance(185))
                                    .foregroundStyle(findColor(iiStatusCode: (selectedVessel.extendedState?.statusID)!).opacity(0.30))
                                    .mapOverlayLevel(level: .aboveLabels)
                                MapCircle(center: vesselPosition, radius: CLLocationDistance(700))
                                    .foregroundStyle(findColor(iiStatusCode: (selectedVessel.extendedState?.statusID)!).opacity(0.0001))
                                    .mapOverlayLevel(level: .aboveLabels)
                                Annotation(Double(selectedVessel.vesselSpeed ?? 0.0) > 1.0 ? "\(selectedVessel.name!) (\(Double(selectedVessel.vesselSpeed ?? 0.0)) kn)" : selectedVessel.name!, coordinate: vesselPosition, anchor: .center) {
                                    Text("⌾")
                                        .symbolEffect(.variableColor)
                                        .scaledToFit()
                                        .frame(width: 19, height: 19)
                                        .foregroundStyle(Color.black)
                                        .background(findColor(iiStatusCode: (selectedVessel.extendedState?.statusID)!))
                                        .clipShape(Circle())
                                }
                                
                                // Add 1-hour heading marker and mark for each 10 min with current speed
                                let tCog = Double(selectedVessel.vesselCog ?? 0.0)
                                let tSog = Double(selectedVessel.vesselSpeed ?? 0.0)
                                
                                if Double(selectedVessel.vesselSpeed ?? 0.0) > 0.5 {
                                    MapPolyline(coordinates: [vesselPosition, findNewCoordinates(bearing: tCog, distanceMeters: 1852 * tSog, origin: vesselPosition)]).stroke(findColor(iiStatusCode: (selectedVessel.extendedState?.statusID)!), lineWidth: 2.0)
                                    
                                    ForEach(getCableMarkers(sog: Double(selectedVessel.vesselSpeed ?? 0.0), cog: Double(selectedVessel.vesselCog ?? 0.0), pos: vesselPosition)) { cableMark in
                                        MapPolyline(coordinates: [cableMark.from, cableMark.to]).stroke(findColor(iiStatusCode: (selectedVessel.extendedState?.statusID)!), lineWidth: 2.0)
                                    }
                                    
                                    // Arrowhead
                                    let startPos = findNewCoordinates(bearing: tCog, distanceMeters: 1852 * tSog, origin: vesselPosition)
                                    let leftCorner = findNewCoordinates(bearing: tCog - 90, distanceMeters: tSog*50, origin: startPos)
                                    let tip = findNewCoordinates(bearing: tCog, distanceMeters: tSog*100, origin: startPos)
                                    let rightCorner = findNewCoordinates(bearing: tCog + 90, distanceMeters: tSog*50, origin: startPos)
                                    MapPolygon(coordinates: [startPos, leftCorner, tip, rightCorner, startPos]).stroke(findColor(iiStatusCode: (selectedVessel.extendedState?.statusID)!), lineWidth: 2.0).foregroundStyle(findColor(iiStatusCode: (selectedVessel.extendedState?.statusID)!))
                                }
                                }
                        }
                        .shadow(color: .black.opacity(0.5), radius: 10)
                        .frame(height: 300)
                        .onAppear(perform: {
                            switch selectedMap {
                            case "standard": selectedMapStyle = .standard
                            case "hybrid": selectedMapStyle = .hybrid
                            case "imagery": selectedMapStyle = .imagery
                            default: selectedMapStyle = .standard
                            }
                        })
                        .mapStyle(self.selectedMapStyle)
                        .mapControls {
                            MapCompass()
                            MapScaleView()
                        }
                        .ignoresSafeArea()
                        
                        // PICTURE OF VESSEL
                        VStack {
                            HStack {
                                Spacer()
                                AsyncImage(url: URL(string: selectedVessel.imageURL!)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)
                                .background(Color.gray)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(findColor(iiStatusCode: (selectedVessel.extendedState?.statusID)!), lineWidth: 4))
                                .shadow(color: findColor(iiStatusCode: (selectedVessel.extendedState?.statusID)!).opacity(0.5), radius: 10)
                            }
                            Spacer()
                        }.padding()
                    }
                    
                    // MAIN TEXT
                    Text(selectedVessel.name!).font(.title)
                    Text("\(selectedVessel.extendedState?.statusText?.rawValue ?? "Mangler status.")").font(.subheadline)
                    
                    if case let .string(content) = selectedVessel.merknad { Text("Merknad: \(content)").font(.subheadline) }
                                        
                    if selectedVessel.aarsak?.rawValue ?? "Ingen årsak" != "Ingen årsak" {
                        Text("Årsak for merknad: \(selectedVessel.aarsak?.rawValue ?? "finner ikke årsak")").font(.subheadline) }
                    
                    if selectedVessel.forventetTilbake != nil {
                        Text("Forventet tilbake: \(convertTime(isDateTime:selectedVessel.forventetTilbake ?? "Feil med tidspunktet"))").font(.subheadline) }
                    
                    VStack {
                        Divider().overlay(Color.textColor)
                        
                        // VÆRET AKKURAT NÅ
                        if vesselPosition.latitude != 0 {
                            Text("Vær").font(.title2).frame(maxWidth: .infinity, alignment: .leading).bold()
                            HStack {
                                
                                // WEATHER AND TEMPERATURE
                                VStack {
                                    if selectedVessel.weatherAirTemp != nil {
                                        Image(String(describing: selectedVessel.weatherSymbol ?? ""))
                                            .resizable()
                                            
                                            .frame(width: 60.0, height: 60.0)
                                            .shadow(radius: 50)
                                    }
                                    Spacer()
                                    if let airTemperature = selectedVessel.weatherAirTemp {
                                        Text("\(airTemperature, specifier: "%.1f")°").font(.subheadline).frame(maxWidth: .infinity).foregroundStyle(airTemperature > 0 ? Color.textColor : .blue)
                                    }
                                    
                                }
                                
                                // WIND STRENGTH AND DIRECTION
                                VStack {
                                    if selectedVessel.weatherWindSpeed != nil {
                                        if let windDirection = selectedVessel.weatherWindDirection {
                                            VStack {
                                                ZStack {
                                                    Image(systemName: "wind")
                                                        .resizable()
                                                        .opacity(0.2)
                                                        .frame(width: 40.0, height: 40.0)
                                                    
                                                    Image(systemName: "arrow.up")
                                                        .resizable()
                                                        .rotationEffect(Angle(degrees: (windDirection + 180)), anchor: .center)
                                                        .frame(width: 20.0, height: 20.0)
                                                }
                                            }
                                        }
                                    }
                                    Spacer()
                                    if let windSpeed = selectedVessel.weatherWindSpeed {
                                        if selectedVessel.weatherWindDirection != nil {
                                            VStack {
                                                Text("\(windSpeed, specifier: "%.1f") m/s").font(.subheadline).frame(maxWidth: .infinity)
                                            }
                                        }
                                    }
                                }
                                
                                // WAVE HEIGHT AND DIRECTION
                                VStack {
                                    if selectedVessel.waveHeight != nil {
                                        if selectedVessel.waveDirection != nil {
                                            VStack {
                                                ZStack {
                                                    Image(systemName: "water.waves")
                                                        .resizable()
                                                        .opacity(0.2)
                                                        .frame(width: 40.0, height: 40.0)
                                                    Image(systemName: "arrow.up")
                                                        .resizable()
                                                        .rotationEffect(Angle(degrees: (selectedVessel.waveDirection! + 180)), anchor: .center)
                                                        .frame(width: 20.0, height: 20.0)
                                                }
                                            }
                                        }
                                    }
                                    Spacer()
                                    if selectedVessel.waveHeight != nil {
                                        if selectedVessel.waveDirection != nil {
                                            VStack {
                                                Text("\(selectedVessel.waveHeight!, specifier: "%.1f") m").font(.subheadline).frame(maxWidth: .infinity)
                                            }
                                        }
                                    }
                                }
                                
                                // WATER TEMPERATURE
                                VStack {
                                    if (selectedVessel.seaWaterTemp != nil) && (selectedVessel.seaWaterDirection != nil) && (selectedVessel.seaWaterSpeed != nil) {
                                        if selectedVessel.seaWaterDirection != nil {
                                            VStack {
                                                ZStack {
                                                    Image(systemName: "figure.pool.swim")
                                                        .resizable()
                                                        .opacity(0.2)
                                                        .frame(width: 40.0, height: 40.0)
                                                    Image(systemName: "arrow.up")
                                                        .resizable()
                                                        .rotationEffect(Angle(degrees: (selectedVessel.waveDirection!)), anchor: .center)
                                                        .frame(width: 20.0, height: 20.0)
                                                    Text("\(selectedVessel.seaWaterTemp!, specifier: "%.1f")°")
                                                        .offset(x: 25, y: -10).frame(maxWidth: .infinity)
                                                        .font(.subheadline)
                                                }
                                            }
                                        }
                                    }
                                    Spacer()
                                    if (selectedVessel.seaWaterTemp != nil) && (selectedVessel.seaWaterDirection != nil) && (selectedVessel.seaWaterSpeed != nil) {
                                        VStack {
                                            Text("\(selectedVessel.seaWaterSpeed!, specifier: "%.1f") m/s").font(.subheadline).frame(maxWidth: .infinity)
                                        }
                                    }
                                }
                            }
                            
                            Divider().overlay(Color.textColor)
                        }
                        
                        // TIDEVANN
                        if (selectedVessel.tideLevel?.tideForecast.count) != nil {
                            Text("Vannstand").font(.title2).frame(maxWidth: .infinity, alignment: .leading).bold()
                            Chart {
                                ForEach(selectedVessel.tideLevel!.tideForecast) { item in
                                    LineMark(
                                        x: .value("Tidspunkt", item.time),
                                        y: .value("Meter", item.value),
                                        series: .value("Tidevann", "Meldt")
                                    ).lineStyle(.init(lineWidth: 2, dash: [5,7]))
                                }
                                .foregroundStyle(Color(UIColor.red))
                                .interpolationMethod(.catmullRom)
                                
                                ForEach(selectedVessel.tideLevel!.tideObservation) { item in
                                    LineMark(
                                        x: .value("Tidspunkt", item.time),
                                        y: .value("Meter", item.value),
                                        series: .value("Tidevann", "Observert")
                                    )
                                }
                                .foregroundStyle(Color.red)
                                .interpolationMethod(.catmullRom)
                                
                                ForEach(selectedVessel.tideLevel!.tidePrediction) { item in
                                    LineMark(
                                        x: .value("Tidspunkt", item.time),
                                        y: .value("Meter", item.value),
                                        series: .value("Tidevann", "Normalen")
                                    ).lineStyle(.init(lineWidth: 2))
                                }
                                .foregroundStyle(Color(UIColor.darkGray).opacity(0.5))
                                .interpolationMethod(.catmullRom)
                                
                                ForEach(selectedVessel.tideLevel!.tideWeather) { item in
                                    LineMark(
                                        x: .value("Tidspunkt", item.time),
                                        y: .value("Meter", item.value),
                                        series: .value("Tidevann", "Værbidrag")
                                    ).lineStyle(.init(lineWidth: 2))
                                }
                                .foregroundStyle(Color(UIColor.orange))
                                .interpolationMethod(.catmullRom)
                            }
                            
                            .padding()
                            .frame(height: 200)
                            .chartLegend(position: .bottom, alignment:.center)
                            .chartXAxis {
                                AxisMarks(values: .stride(by: .hour)) { date in
                                    AxisValueLabel(format: .dateTime.hour()).foregroundStyle(Color.textColor)
                                }
                            }
                            .chartYAxis {
                                AxisMarks(values: .automatic(desiredCount: 10)) {
                                    let value = $0.as(Int.self)!
                                    AxisValueLabel {
                                        Text("\(value) cm").foregroundStyle(Color.textColor)
                                    }
                                    AxisGridLine().foregroundStyle(Color.textColorWeak2)
                                }
                                
                            }
                            
                            HStack{
                                Text("—").foregroundStyle(Color(UIColor.red)).font(.footnote)
                                Text("Observert").foregroundStyle(Color(UIColor.TextColor)).font(.footnote)
                                
                                Text("┅").foregroundStyle(Color(UIColor.red)).font(.footnote)
                                Text("Meldt ").foregroundStyle(Color(UIColor.TextColor)).font(.footnote)
                                
                                Text("—").foregroundStyle(Color(UIColor.darkGray)).font(.footnote)
                                Text("Normalt").foregroundStyle(Color(UIColor.TextColor)).font(.footnote)
                                
                                Text("—").foregroundStyle(Color(UIColor.orange)).font(.footnote)
                                Text("Værbidrag").foregroundStyle(Color(UIColor.TextColor)).font(.footnote)
                            }
                        }
                        
                        Divider().overlay(Color.textColor)
                        
                        
                        // KOMMUNIKASJON
                        Text("Kommunikasjon").font(.title2).frame(maxWidth: .infinity, alignment: .leading).bold()
                        if case let .string(content) = selectedVessel.callsign { Text("Kallesignal: \(content)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        
                        Text("MMSI: \(selectedVessel.mmsi ?? "")").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                        
                        if case let .string(content) = selectedVessel.mobile { Text("Mobil: \(content)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        
                        Text("E-post: \(selectedVessel.email ?? "")").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider().overlay(Color.textColor)
                        
                        // FARTØYET
                        Text("Fartøyet").font(.title2).frame(maxWidth: .infinity, alignment: .leading).bold()
                        
                        switch selectedVessel.port {
                            case .bergen:  Text("Hjemmehavn: Bergen").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                            case .oslo:  Text("Hjemmehavn: Oslo").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                            case .sandnessjøen:  Text("Hjemmehavn: Sandnessjøen").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                            default:  Text("Hjemmehavn: Ukjent").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Text("Byggeår: \(selectedVessel.buildingyardYear ?? "")").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                        
                        if case let .string(content) = selectedVessel.construction { Text("Bygget av: \(content)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        if case let .string(content) = selectedVessel.constructionMaterial { Text("Byggemateriale: \(content)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        if case let .string(content) = selectedVessel.speed { Text("Maksfart: \(content)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        if case let .string(content) = selectedVessel.length { Text("Lengde: \(content)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        if case let .string(content) = selectedVessel.beam { Text("Bredde: \(content)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        if case let .string(content) = selectedVessel.draft { Text("Dypgående: \(content)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        if case let .string(content) = selectedVessel.bollardPullMaximum { Text("Slepekraft: \(content)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        
                        Divider().overlay(Color.textColor)
                        
                        // UTRUSTNING
                        Text("Utrustning").font(.title2).frame(maxWidth: .infinity, alignment: .leading).bold()
                        
                        if case let .string(content) = selectedVessel.mainEngine { Text("Hovedmotorer: \(content)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        if case let .string(content) = selectedVessel.waterjet { Text("Vannjetter: \(content)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        if case let .string(content) = selectedVessel.navigationEquipment { Text("Navigasjonsutstyr: \(content)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        if case let .string(content) = selectedVessel.communicationEquipment { Text("Kommunikasjonsutstyr: \(content)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        if case let .string(content) = selectedVessel.crew { Text("Mannskap: \(content)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        
                        Divider().overlay(Color.textColor)
                        
                        // STASJONEN
                        Text("Stasjonen").font(.title2).frame(maxWidth: .infinity, alignment: .leading).bold()
                        Text("Stasjonsnavn: \(selectedVessel.station?.name ?? "")").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                        
                        switch selectedVessel.station?.type {
                            case .amb: Text("Stasjonstype: ambulansefartøy").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                            case .fast: Text("Stasjonstype: fast bemannet").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                            case .nopos: Text("Stasjonstype: ikke i operasjon").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                            case .rsrk: Text("Stasjonstype: frivillig bemannet").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                            default: Text("Stasjonstype: ukjent").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if case let .string(content) = selectedVessel.station?.phone { Text("Telefonnummer: \(content)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        if case let .string(content) = selectedVessel.station?.address { Text("Adresse: \(content)").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        if case let .string(content) = selectedVessel.station?.zipcode { Text("Postnummer: \(content) \(selectedVessel.station?.ziplocation ?? "ukjent")").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading) }
                        
                        Spacer()
                    }
                    .padding(10)
                }
                .foregroundColor(Color.textColor)
                .scrollContentBackground(.hidden)
                .background(Color.backgroundColor)
            }
        Button {
            if case let .string(content) = selectedVessel.mobile {
                guard let url = URL(string: "tel://\(content)") else { return }
                UIApplication.shared.open(url)
            }
        } label: {
            Image(systemName: "phone.fill")
                .font(.title.weight(.semibold))
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 10, x: 0, y: 10)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .task {
            do {
                let urlLocation = URL(string: "https://api.met.no/weatherapi/locationforecast/2.0/complete?lat=\(vesselPosition.latitude)&lon=\(vesselPosition.longitude)&altitude=0")!
                let requestLocation = URLRequest(url: urlLocation)
                let (dataLocation, _) = try await URLSession.shared.data(for: requestLocation)
                
                // MET.NO LOCATIONFORECAST
                do {
                    let decoder = JSONDecoder()
                    let allDataOcean = try decoder.decode(RootLocation.self, from: dataLocation)
                    
                    selectedVessel.weatherAirTemp = allDataOcean.properties?.timeseries?[0].data?.instant?.details["air_temperature"]
                    selectedVessel.weatherWindSpeed = allDataOcean.properties?.timeseries?[0].data?.instant?.details["wind_speed"]
                    selectedVessel.weatherWindDirection = allDataOcean.properties?.timeseries?[0].data?.instant?.details["wind_from_direction"]
                    selectedVessel.weatherSymbol = String(describing: allDataOcean.properties?.timeseries![0].data?.next1Hours?.summary?.symbolCode)
                    
                    let smth = (selectedVessel.weatherSymbol ?? "")
                    
                    if let index = (smth.range(of: ".")?.upperBound)
                    {
                        let afterEqualsTo = String(smth.suffix(from: index))
                        if let index2 = (afterEqualsTo.range(of: ".")?.upperBound)
                        {
                            let afterEqualsTo2 = String(afterEqualsTo.suffix(from: index2))
                            selectedVessel.weatherSymbol = String(afterEqualsTo2.dropLast())
                        }
                    }
                } catch {
                    print("Error decoding LocationForecast JSON from met.no: \(error)")
                }
                
                // MET.NO OCEANFORECAST
                let urlOcean = URL(string: "https://api.met.no/weatherapi/oceanforecast/2.0/complete?lat=\(vesselPosition.latitude)0&lon=\(vesselPosition.longitude)")!
                let requestOcean = URLRequest(url: urlOcean)
                let (dataOcean, _) = try await URLSession.shared.data(for: requestOcean)
                
                do {
                    let decoder = JSONDecoder()
                    let allDataOcean = try decoder.decode(RootOcean.self, from: dataOcean)
                    selectedVessel.waveHeight = allDataOcean.properties?.timeseries?[0].data?.instant?.details["sea_surface_wave_height"]
                    selectedVessel.waveDirection = allDataOcean.properties?.timeseries?[0].data?.instant?.details["sea_surface_wave_from_direction"]
                    selectedVessel.seaWaterTemp = allDataOcean.properties?.timeseries?[0].data?.instant?.details["sea_water_temperature"]
                    selectedVessel.seaWaterDirection = allDataOcean.properties?.timeseries?[0].data?.instant?.details["sea_water_to_direction"]
                    selectedVessel.seaWaterSpeed = allDataOcean.properties?.timeseries?[0].data?.instant?.details["sea_water_speed"]
                } catch {
                    print("Error decoding OceanForecast JSON from met.no: \(error)")
                }
                
                // KYSTVERKET.NO TIDES
                let fromTime = adjustedDateTime(-6)
                let toTime = adjustedDateTime(12)
                
                let urlTide = URL(string: "https://api.sehavniva.no/tideapi.php?lat=\(vesselPosition.latitude)&lon=\(vesselPosition.longitude)&fromtime=" + fromTime + "&totime=" + toTime + "&datatype=all&refcode=cd&place=&file=&lang=nb&interval=60&dst=0&tzone=1&tide_request=locationdata")!
                let requestTide = URLRequest(url: urlTide)
                let (dataTide, _) = try await URLSession.shared.data(for: requestTide)
                
                print("\(urlTide)")
            
                selectedVessel.tideLevel = XMLParse().startParsing(input: dataTide)
                
            } catch {
                print("\(error)")
            }
        }
        .background(Color.backgroundColor)
        .preferredColorScheme(selectedNight ? .dark : .light)
    }
    
    class XMLParse : NSObject, XMLParserDelegate {
        var temp: Tide = Tide(tideObservation: [TideData](), tidePrediction: [TideData](), tideForecast: [TideData](), tideWeather: [TideData]())
        var out: Tide?
        
       func startParsing(input: Data) -> Tide {
           let parser = XMLParser(data: input)
           parser.delegate = self
           _ = parser.parse()
           return out!
        }

        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]){
            if (attributeDict["flag"] == "forecast") {
                temp.tideForecast.append(TideData(time: getDate(input: attributeDict["time"] ?? ""), value: Double("\(attributeDict["value"] ?? "0")") ?? 0.0))
            }
            if (attributeDict["flag"] == "obs") {
                temp.tideObservation.append(TideData(time: getDate(input: attributeDict["time"] ?? ""), value: Double("\(attributeDict["value"] ?? "0")") ?? 0.0))
            }
            if ((attributeDict["flag"] == nil) && attributeDict["value"] != nil) {
                temp.tideWeather.append(TideData(time: getDate(input: attributeDict["time"] ?? ""), value: Double("\(attributeDict["value"] ?? "0")") ?? 0.0))
            }
            if (attributeDict["flag"] == "pre") {
                temp.tidePrediction.append(TideData(time: getDate(input: attributeDict["time"] ?? ""), value: Double("\(attributeDict["value"] ?? "0")") ?? 0.0))
            }
        }

        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            
        }
        
        func parserDidStartDocument(_ parser: XMLParser) {
            
        }

        func parserDidEndDocument(_ parser: XMLParser) {
            out = temp
        }
        
        func getDate(input: String) -> Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZZZZZ" //2023-12-26T03:00:00Z
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [
                .withInternetDateTime,
                .withColonSeparatorInTime,
                .withDashSeparatorInDate,
                .withTimeZone]
            
            if input == "" {
                return formatter.date(from: "2000-01-01T00:00:00+00:00")!
            } else {
                return formatter.date(from: input)!
            }
        }
    }
}


