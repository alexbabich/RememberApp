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
    @Environment(\.presentationMode) var dismiss
    
    @State var image : Data = .init(count: 0)
    @State var names = ""
    @State var detail = ""
    @State var date = ""
    
    @State var show = false
    @State var sourceType : UIImagePickerController.SourceType = .camera
    @State var photo = false
//    @ObservedObject var users = EditView()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                if self.image.count != 0 {
                    Button(action: {
                        self.photo.toggle()
                    }) {
                        Image(uiImage: UIImage(data: self.image)!)
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .cornerRadius(6)
                    }
                } else {
                    Button(action: {
                        self.photo.toggle()
                    }) {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
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
                    
                    let new = Remmebers(context: self.moc)
                    new.names = self.names
                    new.imageD = self.image
                    new.detail = self.detail
                    new.date = self.date
                    
                    try? self.moc.save()
                    
                    self.names = ""
                    self.image.count = 0
                    self.detail = ""
                    self.date = ""
                    
                    self.dismiss.wrappedValue.dismiss()
                    
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
                .actionSheet(isPresented: self.$photo) {
                    ActionSheet(title: Text("select photo"),
                                message: Text(""),
                                buttons: [
                                    .default(Text("Camera")) {
                                        self.sourceType = .camera
                                        self.show.toggle()
                                    },
                                    .default(Text("Photo library")) {
                                        self.sourceType = .photoLibrary
                                        self.show.toggle()
                                    },
                                    .cancel()
                                ])
            }
        }
        .sheet(isPresented: self.$show) {
            ImagePicker(show: self.$show, image: self.$image, sourceType: self.sourceType)
        }
    }
}

struct CreaterView_Previews: PreviewProvider {
    static var previews: some View {
        CreaterView()
    }
}
