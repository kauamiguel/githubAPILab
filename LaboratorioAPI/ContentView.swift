//
//  ContentView.swift
//  LaboratorioAPI
//
//  Created by Kaua Miguel on 16/08/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var user:GitHubUser?
    @Binding var githubUserName:String
    
    var body: some View {
        VStack {
            
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundColor(.secondary)
            }
            .frame(width: 120, height: 120)
            
            Text(user?.login ?? "LoginProfile")
                .bold()
                .font(.title3)
            
            Text(user?.bio ?? "Bio")
                .padding()
            
            Spacer()
        }
        .padding()
        //Task é um property modifier que performa uma tarefa antes da view aparecer
        .task {
            do{
                user = try await getUser()
            }catch{
                print("Invalid user")
            }
        }
    }
    
    func getUser() async throws -> GitHubUser{
        
        let endpoint = "https://api.github.com/users/\(githubUserName)"
        print(endpoint)
        print(githubUserName)
        
        //Testar se  url é valida, convertando para o tipo URL
        guard let url = URL(string: endpoint) else{throw GHError.invalidURL}
        
            //Receber os dados da api e armazenar em uma tupla com dados e a resposta
        let (data, response) = try await URLSession.shared.data(from: url)
        
        //Caso a resposta seja diferente de 200, lançar um erro
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw GHError.invalidResponse
        }
        
        //Decodificar os dados baseado nos campos do usuario
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubUser.self
                                      , from: data)
        }catch{
            throw GHError.invalidData
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(githubUserName: .constant(""))
    }
}

struct GitHubUser : Codable{
    let login:String
    let avatarUrl:String
    let bio:String
}

enum GHError : Error{
    case invalidURL
    case invalidResponse
    case invalidData
}
