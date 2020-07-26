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
    
    @State var show = false
    @State var alert = false
    @State var delete = false
    
    @State var text = ""
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                SearchsBar(text: $text)
                ForEach(remembers.filter({self.text.isEmpty ? true : $0.names!.localizedCaseInsensitiveContains(self.text)}), id: \.imageD) { reme in
                    VStack(alignment: .leading) {
                        Text("\(reme.names ?? "")")
                            .font(.headline)
                            .italic()
                            .underline()
                        
                        Image(uiImage: UIImage(data: reme.imageD ?? self.image)!)
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(14)
                        
                        HStack {
                            ForEach(0..<5, id: \.self) { star in
                                HStack {
                                    Button(action: {
                                        reme.favo = star
                                    }) {
                                        Image(systemName: reme.favo >= star ? "star.fill" : "star")
                                            .foregroundColor((reme.favo >= star) ? Color.yellow : Color.gray)
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
                    .contextMenu {
                        Button(action: {
                            UIImageWriteToSavedPhotosAlbum(UIImage(data: reme.imageD ?? self.image)!, 0, nil, nil)
                            self.alert.toggle()
                        }) {
                            HStack {
                                Text("Save to gallery")
                                Image(systemName: "square.and.arrow.down")
                                
                            }
                        }
                        
                        Button(action: {
                            self.delete.toggle()
                        }) {
                            HStack {
                                Text("Delete")
                                Image(systemName: "trash")
                                
                            }
                        }
                    }
                    .alert(isPresented: self.$delete) {
                        Alert(title: Text("No Undo"), message: Text("Are you sure that you want to delete this remember?"), primaryButton: .default(Text("Delete").foregroundColor(.red)) { self.delete(at: IndexSet.init(arrayLiteral: 0)) }, secondaryButton: .cancel())
                    }
                }
                .padding()
            }
            .navigationBarTitle("Remember", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.show.toggle()
            }){
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("new")
                }
                .foregroundColor(Color.white)
            }, trailing: ZStack {
                Circle()
                    .fill(Color.black.opacity(0.55))
                    .frame(width: 30, height: 30)
                
                Text("\(self.remembers.count)")
                    .foregroundColor(Color.white)
            })
            
            .alert(isPresented: self.$alert) {
                Alert(title: Text("Saved Photo"), message: Text("The photo was saved on your Photo Gallery"), dismissButton: .default(Text("Ok")))
            }
        }
        .sheet(isPresented: self.$show) {
            CreaterView().environment(\.managedObjectContext, self.moc)
        }
    }
    
    func delete(at offsets: IndexSet) {
        
        for index in offsets {
            let delet = remembers[index]
            self.moc.delete(delet)
        }
        try! self.moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
