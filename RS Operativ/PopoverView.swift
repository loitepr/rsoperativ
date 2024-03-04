//
//  PopoverView.swift
//  RS Operativ
//
//  Created by Preben Løite on 04/03/2024.
//

import SwiftUI

struct PopoverView: View {
    @State var vShowPopup = true
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8).opacity(vShowPopup ? 0.5 : 0.0)
        VStack {
            Text("Fart: 32.5 kn").opacity(vShowPopup ? 1.0 : 0.0).foregroundStyle(.white).font(.footnote)
            Text("Heading: 350°").opacity(vShowPopup ? 1.0 : 0.0).foregroundStyle(.white).font(.footnote)
            Text("Kurs: 349°").opacity(vShowPopup ? 1.0 : 0.0).foregroundStyle(.white).font(.footnote)
        }.padding(10)
    }
}

#Preview {
    PopoverView()
}
