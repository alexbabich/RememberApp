//
//  CreaterView.swift
//  RememberApp
//
//  Created by alex-babich on 22.07.2020.
//  Copyright © 2020 alex-babich. All rights reserved.
//

import SwiftUI

struct CreaterView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State var image : Data = .init(count: 0)
    @State var names = ""
    @State var detail = ""
    @State var date = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                if self.image.count != 0 {
                    Button(action: {
                        
                    }) {
                        Image(uiImage: UIImage(data: self.image)!)
                    }
                } else {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .frame(width: 80, height: 70)
                            .foregroundColor(Color.gray.opacity(0.70))
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Person name")
                    TextField("names ...", text: self.$names)
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: UIScreen.main.bounds.width - 40, height: 1)
                    
                    Text("Description")
                    TextField("detail ...", text: self.$detail)
                    Rectangle()
                    .fill(Color.gray)
                    .frame(width: UIScreen.main.bounds.width - 40, height: 1)
                    
                    Text("Picture date")
                    TextField("date ...", text: self.$date)
                    Rectangle()
                    .fill(Color.gray)
                    .frame(width: UIScreen.main.bounds.width - 40, height: 1)
                }
                .padding()
                
                Button(action: {
                    
                }) {
                    Text("Create new")
                        .bold()
                        .padding()
                        .font(.system(size: 23))
                        .foregroundColor(.white)
                }
                .background(Color.gray)
                .cornerRadius(10)
                
                Spacer()
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(leading:
                Text("Add Remembers")
                    .foregroundColor(.white)
            , trailing:
                Text("Cancel")
                    .foregroundColor(.white)
            )
        }
    }
}

struct CreaterView_Previews: PreviewProvider {
    static var previews: some View {
        CreaterView()
    }
}
