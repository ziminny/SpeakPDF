//
//  ContentView.swift
//  VozPDF
//
//  Created by Vagner Oliveira on 05/09/25.
//

import SwiftUI
import UniformTypeIdentifiers
import PDFKit
import AVFoundation

struct HomeScreen: View {
    
    @ObservedObject var globalViewModel: GlobalViewModel = .init()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // MARK: Banner de propaganda
                BannerContentView(navigationTitle: "VozPDF")
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // MARK: Botão para carregar PDF
                        loadPDFButton
                        
                        // MARK: Mostra o nome do arquivo carregado
                        loadPDFFileName
                        
                        // Configurações de leitura
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Configurações de Leitura")
                                .font(.headline)
                            
                            // MARK: Seleção de idioma
                            acceptlanguages
                            
                            // MARK: Picker de locutor baseado no idioma
                            announcers
                            
                            // MARK: Velocidade de leitura
                            readingSpeed
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                // MARK: Inicial leitura
                startButton
                
            }
            .navigationTitle("VozPDF")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: globalViewModel.selectedIdioma, {
            globalViewModel.selectedLocutorIdentifier = globalViewModel.locutoresAtuais.first?.identifier
        })
        .onAppear {
            globalViewModel.selectedLocutorIdentifier = globalViewModel.locutoresAtuais.first?.identifier
        }
    }
    
    var startButton: some View {
        NavigationLink {
            PDFViewerScreen()
                .environmentObject(globalViewModel)
        } label: {
            Text("Iniciar")
                .foregroundColor(.white) // cor do texto
                .frame(maxWidth: .infinity) // ocupa toda largura
                .padding() // espaço interno
                .background(Color.blue) // cor de fundo
                .cornerRadius(10) // bordas arredondadas
        }
        .padding(.horizontal)
    }
    
    var loadPDFButton: some View {
        Button(action: {
            globalViewModel.showDocumentPicker = true
        }) {
            HStack {
                Image(systemName: "doc.fill")
                Text("Carregar PDF")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top)
        }
        .sheet(isPresented: $globalViewModel.showDocumentPicker) {
            DocumentPicker(pdfURL: $globalViewModel.pdfURL)
        }
    }
    
    @ViewBuilder
    var loadPDFFileName: some View {
        if let url = globalViewModel.pdfURL {
            HStack {
                Image(systemName: "doc.text")
                    .foregroundColor(.blue)
                VStack(alignment: .leading) {
                    Text(url.lastPathComponent)
                        .font(.headline)
                        .lineLimit(1)
                    Text("PDF carregado com sucesso")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .transition(.slide)
        }
    }
    
    var acceptlanguages: some View {
        Picker("Idioma", selection: $globalViewModel.selectedIdioma) {
            ForEach(Constants.languages, id: \.self) { lang in
                Text(Locale.current.localizedString(forIdentifier: lang) ?? lang)
            }
        }
        .pickerStyle(.menu)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    var announcers: some View {
        Picker("Locutor", selection: $globalViewModel.selectedLocutorIdentifier) {
            ForEach(globalViewModel.locutoresAtuais, id: \.identifier) { voice in
                Text(voice.name).tag(voice.identifier as String?)
            }
        }
        .pickerStyle(.menu)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    var readingSpeed: some View {
        VStack(alignment: .leading) {
            Text("Velocidade de Leitura: \(String(format: "%.1fx", globalViewModel.velocity))")
            Slider(value: $globalViewModel.velocity, in: 0.3...0.6, step: 0.05)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
