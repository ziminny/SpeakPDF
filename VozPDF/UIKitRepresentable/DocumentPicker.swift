//
//  DocumentPicker.swift
//  VozPDF
//
//  Created by Vagner Oliveira on 05/09/25.
//

import Foundation
import SwiftUI

/// Estrutura para exibir um seletor de documentos (PDF) usando UIKit dentro do SwiftUI.
/// Permite ao usuário escolher um PDF do sistema e copia o arquivo para a pasta temporária do app.
struct DocumentPicker: UIViewControllerRepresentable {
    
    /// Binding para armazenar a URL do PDF selecionado
    @Binding var pdfURL: URL?
    
    // MARK: - UIViewControllerRepresentable
    
    /// Cria e configura o UIDocumentPickerViewController
    /// - Parameter context: contexto do SwiftUI
    /// - Returns: instância do UIDocumentPickerViewController
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        picker.delegate = context.coordinator // define o delegado para receber eventos
        return picker
    }
    
    /// Atualiza o UIViewController (não usado aqui)
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    /// Cria o coordenador que atua como delegado do picker
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    
    /// Classe interna que implementa UIDocumentPickerDelegate
    /// Responsável por receber a URL do PDF selecionado e copiar para pasta temporária
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        /// Inicializa o coordenador com referência ao DocumentPicker
        init(_ parent: DocumentPicker) { self.parent = parent }
        
        /// Chamado quando o usuário seleciona documentos
        /// - Parameters:
        ///   - controller: instância do UIDocumentPickerViewController
        ///   - urls: URLs dos documentos selecionados
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let pickedURL = urls.first else { return } // pega apenas o primeiro PDF
            
            // Define o destino na pasta temporária do app
            let fileManager = FileManager.default
            let destination = fileManager.temporaryDirectory.appendingPathComponent(pickedURL.lastPathComponent)
            
            do {
                // Remove arquivo antigo, se existir
                if fileManager.fileExists(atPath: destination.path) {
                    try fileManager.removeItem(at: destination)
                }
                
                // Copia o PDF selecionado para a pasta temporária
                try fileManager.copyItem(at: pickedURL, to: destination)
                
                // Atualiza a binding com a URL do PDF copiado
                parent.pdfURL = destination
                print("PDF copiado para: \(destination)")
            } catch {
                print("Erro ao copiar PDF: \(error)")
            }
        }
    }
}
