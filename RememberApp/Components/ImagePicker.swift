//
//  ImagePicker.swift
//  RememberApp
//
//  Created by Alex Babich on 22.07.2020.
//  Copyright © 2020 alex-babich. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var show : Bool
    @Binding var image : Data
    var sourceType : UIImagePickerController.SourceType = .camera
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(father1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext <ImagePicker>) -> UIImagePickerController  {
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext <ImagePicker>) {
        
    }
    
    class Coordinator : NSObject, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
        
        var father : ImagePicker
        init(father1 : ImagePicker) {
            father = father1
        }
        func imagePickerControllerDidCancel(_ picker : UIImagePickerController) {
            self.father.show.toggle()
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let image = info[.originalImage]as! UIImage
            let datos = image.jpegData(compressionQuality: 0.50)
            self.father.image = datos!
            self.father.show.toggle()
        }
    }
    
}
