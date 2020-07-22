//
//  ContentView.swift
//  RememberApp
//
//  Created by alex-babich on 21.07.2020.
//  Copyright © 2020 alex-babich. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Remmebers.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Remmebers.names, ascending: true),
        NSSortDescriptor(keyPath: \Remmebers.detail, ascending: true),
        NSSortDescriptor(keyPath: \Remmebers.imageD, ascending: true),
        NSSortDescriptor(keyPath: \Remmebers.favo, ascending: false),
        NSSortDescriptor(keyPath: \Remmebers.loved, ascending: false)
    ]) var remembers : FetchedResults<Remmebers>
    
    @State var image : Data = .init(count: 0)
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(remembers, id: \.names) { reme in
                    VStack(alignment: .leading) {
                        Text("\(reme.names ?? "")")
                            .font(.headline)
                            .underline()
                        
                        Image(uiImage: UIImage(data: reme.imageD ?? self.image)!)
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                        
                        HStack {
                            ForEach(0..<5, id: \.self) { star in
                                HStack {
                                    Button(action: {
                                        reme.favo = star
                                    }) {
                                        Image(systemName: reme.favo >= 0 ? "star.fill" : "star")
                                            .foregroundColor((reme.favo >= 0) ? Color.yellow : Color.gray)
                                    }
                                    .onTapGesture {
                                        reme.favo = star
                                        try! self.moc.save()
                                    }
                                }
                            }
                            Text("\(reme.date ?? "")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Button(action: {
                                reme.loved.toggle()
                                try! self.moc.save()
                            }) {
                                Image(systemName: reme.loved ? "heart.fill" : "heart")
                                    .foregroundColor(reme.loved ? Color.red : Color.gray)
                            }
                        }
                        
                        Text("\(reme.detail ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationBarTitle("Remember", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                
            }){
                HStack {
                    
                }
            }, trailing: )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
