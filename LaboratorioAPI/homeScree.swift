//
//  homeScree.swift
//  LaboratorioAPI
//
//  Created by Kaua Miguel on 16/08/23.
//

import SwiftUI

struct homeScree: View {
    @State var githubName:String = ""
    var body: some View {
        NavigationView {
            VStack{
                TextField("Type your github", text: $githubName)
                
                NavigationLink {
                    ContentView(githubUserName: $githubName)
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 200, height: 50)
                        .overlay {
                            Text("Search")
                                .foregroundColor(.white)
                        }
                        .padding()
                }
            }
            .padding()
        }
    }
}

struct homeScree_Previews: PreviewProvider {
    static var previews: some View {
        homeScree()
    }
}
