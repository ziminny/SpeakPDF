//
//  PDFKitView.swift
//  VozPDF
//
//  Created by Vagner Oliveira on 08/09/25.
//

import Foundation
import SwiftUI
import PDFKit

/// UIViewRepresentable que permite usar o PDFKit (`PDFView`) dentro do SwiftUI.
/// Recebe um PDFDocument e exibe o PDF ajustado na tela.
struct PDFKitView: UIViewRepresentable {
    
    /// Documento PDF que será exibido
    let document: PDFDocument
    @Binding var selection: PDFSelection?

    // MARK: - UIViewRepresentable
    
    /// Cria e configura o PDFView
    /// - Parameter context: contexto do SwiftUI
    /// - Returns: instância do PDFView configurada
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        return pdfView
    }

    /// Atualiza o PDFView com o documento atual
    /// - Parameters:
    ///   - uiView: PDFView existente
    ///   - context: contexto do SwiftUI
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = document
        if let selection = selection {
            pdfView.setCurrentSelection(selection, animate: true)
            pdfView.scrollSelectionToVisible(self)
        }
    }
}
