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
    
    @State var sourceType : UIImagePickerController.SourceType = .camera
    @State var photo = false
    @State var show = false
    @State var create = false
    @State var ani = false
    @State var flash = false
    
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
                        ZStack {
                         Image(systemName: "camera.fill")
                            .resizable()
                            .frame(width: 70, height: 60)
                            withAnimation(Animation.default.delay(0.2)) {
                                Circle()
                                    .fill(self.flash ? Color.white : Color.white.opacity(0.40))
                                    .frame(width: 12, height: 12)
                                    .offset(x: 0, y: 3)
                            }
                            .animation(Animation.default.delay(self.flash ? 0.6 : 0.10).repeatForever(autoreverses: self.flash))
                            .onAppear {
                                self.flash.toggle()
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    
                    Group {
                        Text("Person name")
                            .bold()
                        TextField("Name the persone on the photo ...", text: self.$names)
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 1)
                    }
                    
                    Group {
                        Text("Description")
                            .bold()
                        TextField("Describe those moment ...", text: self.$detail)
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 1)
                    }
                    
                    Group {
                        Text("Picture date")
                            .bold()
                        TextField("Date of the taken photo ...", text: self.$date)
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 1)
                    }
                }
                .padding()
                
                Button(action: {
                    self.create.toggle()
                }) {
                    Text("Create new")
                        .bold()
                        .padding()
                        .font(.system(size: 23))
                        .foregroundColor(.white)
                }
                .background((self.image.count != 0 &&
                            self.names.count > 5 &&
                            self.detail.count > 10 &&
                            self.date.count >= 10) ? Color("navi") : Color.gray)
                .cornerRadius(10)
                .disabled((self.image.count != 0 &&
                            self.names.count > 5 &&
                            self.detail.count > 10 &&
                            self.date.count >= 10) ? false : true)
                
                if self.image.count != 0 {
                    Image(uiImage: UIImage(data: self.image)!)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(14)
                        .padding()
                } else {
                    withAnimation(Animation.default.delay(0.1)
                        .repeatForever(autoreverses: self.ani)) {
                            HStack {
                                Text("Preview")
                                    .fontWeight(.heavy)
                                
                                Image(systemName: "photo")
                                    .foregroundColor(Color.init("navi"))
                            }
                            .foregroundColor(Color.init("navi"))
                            .scaleEffect(self.ani ? 1.20 : 1.50)
                    }
                    .animation(Animation.default.speed(0.1)
                    .repeatForever(autoreverses: self.ani).delay(self.ani ? 1.0 : 1.0))
                    .onAppear {
                        self.ani.toggle()
                    }
                }
                Spacer()
            }
            .padding()
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(leading:
                Text("Add Remembers")
                    .foregroundColor(.white)
            , trailing:
                
                Button(action: {
                    self.dismiss.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                }
            )
            .alert(isPresented: self.$create) {
                Alert(title: Text("New remember"), message: Text("your remember \(names.uppercased()) will be added"), primaryButton: .default(Text("Yes")) {
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
                    }, secondaryButton: .default(Text("No")) {
                        self.dismiss.wrappedValue.dismiss()
                    })
            }
                
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
