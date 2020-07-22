//
//  UISearchBar.swift
//  RememberApp
//
//  Created by Alex Babich on 22.07.2020.
//  Copyright © 2020 alex-babich. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct SearchsBar: UIViewRepresentable {
    
    @Binding var text : String

    class Coordinator: NSObject, UISearchBarDelegate {
        let searchBar = UISearchBar(frame: .zero)
        
        @Binding var text : String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
            searchBar.endEditing(true)
        }
    }

    func makeCoordinator() -> SearchsBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchsBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.isSearchResultsButtonSelected = true
        searchBar.placeholder = "Search name ..."
        searchBar.barStyle = .default
        searchBar.enablesReturnKeyAutomatically = true
        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchsBar>) {
        uiView.text = text
    }

}
