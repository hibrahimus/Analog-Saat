//
//  ContentView.swift
//  Analog
//
//  Created by Halil İbrahim Uslu on 24.05.2020.
//  Copyright © 2020 Halil İbrahim Uslu. All rights reserved.
//

import SwiftUI

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

struct ContentView: View {
    @State var saat = 0
    @State var dakika = 0
    @State var saniye =  0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){time in
            if self.saniye < 60{
                self.saniye += 1
                print("\(self.saniye)")}
            else{
                self.setTime()
            }
        }
    }
    func setTime() {
        let gün = Date()
        let takvim = Calendar.current
        self.saat = takvim.component(.hour, from: gün)
        self.dakika = takvim.component(.minute, from: gün)
        self.saniye = takvim.component(.second, from: gün)
    }
    
    var body: some View {
        ZStack{
            Color.gray.edgesIgnoringSafeArea(.all)
            GeometryReader{geo in
                ZStack{
                    Circle()
                    ForEach(1..<13){ nr in
                        Image(systemName: "\(nr).circle\(nr == self.saat ? ".fill" : "")")
                            .font(.largeTitle)
                            .offset(y: -geo.size.width / 2.1)
                            .rotationEffect(Angle(degrees: Double(30 * nr)), anchor: .center)
                    }
                    Hand(saat: self.$saat, dakika: self.$dakika, saniye: self.$saniye)
                }.frame(width: 300, height: 300)
            }.foregroundColor(Color.yellow)
                .onAppear{
                    self.setTime()
                    self.startTimer()
            }
        }
    }
}

struct Hand: View{
    @Binding var saat : Int
    @Binding var dakika : Int
    @Binding var saniye : Int
    var body: some View{
        GeometryReader{geo in
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 4, height: geo.size.width / 5)
                    .offset(y: geo.size.width / 10)
                    .background(Color.red)
                    .rotationEffect(Angle(degrees:Double(30 * self.saat) + (0.5 * Double(self.saat))), anchor: .center)
                          
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 4, height: geo.size.width / 3)
                 .offset(y: geo.size.width / 6)
                 .background(Color.gray)
                 .rotationEffect(Angle(degrees:Double(6 * self.dakika)), anchor: .center)
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 3, height: geo.size.width / 2.5)
                    .offset(y: geo.size.width / 5)
                    .background(Color.white)
                    .rotationEffect(Angle(degrees:Double(6 * self.saniye)), anchor: .center)
            }.rotationEffect(Angle(degrees: 180), anchor: .center)
        }
    }
}
