//
//  LibraryView.swift
//  MusicApp
//
//  Created by Сергей Иванов on 11.01.2021.
//

import SwiftUI

struct LibraryView: View {
    var body: some View {
        NavigationView {
            Text("Library").navigationBarTitle("Library")
        }
        .navigationBarTitle("Navigation")
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
