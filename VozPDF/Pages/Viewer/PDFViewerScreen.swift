//
//  PDFViewerScreen.swift
//  VozPDF
//
//  Created by Vagner Oliveira on 08/09/25.
//

import SwiftUI
import PDFKit
import AVFAudio

struct PDFViewerScreen: View {
    
    @EnvironmentObject var globalViewModel: GlobalViewModel

    var body: some View {
        VStack {
            if let url = globalViewModel.pdfURL, let doc = PDFDocument(url: url) {
               
                ZStack(alignment: .bottom) {
                    PDFKitView(pdfDocument: doc)
                        .edgesIgnoringSafeArea(.all)

                    HStack(spacing: 10) {
                        
                        Button {
                            globalViewModel.speakPDF()
                        } label: {
                            Text("Começar a leitura")
                        }
                        
                        if globalViewModel.showPauseButton {
                            // Pausar/Retomar
                            Button(action: {
                                if globalViewModel.synthesizer.isSpeaking && !globalViewModel.synthesizer.isPaused {
                                    globalViewModel.synthesizer.pauseSpeaking(at: .word)
                                    globalViewModel.isPaused = true
                                } else if globalViewModel.synthesizer.isPaused {
                                    globalViewModel.synthesizer.continueSpeaking()
                                    globalViewModel.isPaused = false
                                }
                            }) {
                                HStack {
                                    Image(systemName: "playpause")
                                    Text(!globalViewModel.isPaused ? "Pausar" : "Retomar")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                        
                    }
                    .padding(.horizontal)

                }
            } else {
                Text("PDF não encontrado")
                    .foregroundColor(.gray)
            }
        }
    }

}

struct PDFViewerScreen_Previews: PreviewProvider {
    static var previews: some View {
        PDFViewerScreen()
            .environmentObject(GlobalViewModel())
    }
}
