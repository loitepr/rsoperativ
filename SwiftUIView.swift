//
//  SwiftUIView.swift
//  RS Operativ
//
//  Created by Preben Løite on 03/03/2024.
//

import SwiftUI
import MapKit

struct SwiftUIView: View {
    @State var vShowPopup = false
    
    var body: some View {
        VStack {
            Text("Playground")
            Map() {
                Annotation("", coordinate: CLLocationCoordinate2D(latitude: 58.08, longitude: 7.98), content: {
                    Text("o")
                        .onTapGesture(perform: { vShowPopup = true })
                        .popover(isPresented: $vShowPopup,
                             attachmentAnchor: .point(.center),
                             arrowEdge: .top,
                             content: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8).foregroundStyle(.white)
                                    VStack {
                                        Text("Fart: 32.5 kn").foregroundStyle(.black).font(.footnote)
                                        Text("Heading: 350°").foregroundStyle(.black).font(.footnote)
                                        Text("Kurs: 349°").foregroundStyle(.black).font(.footnote)
                                    }.padding(10)
                                }.presentationCompactAdaptation(.none)
                    })
                })
            }
        }
    }
}

#Preview {
    SwiftUIView()
}
