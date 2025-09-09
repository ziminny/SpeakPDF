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
    let pdfDocument: PDFDocument?

    // MARK: - UIViewRepresentable
    
    /// Cria e configura o PDFView
    /// - Parameter context: contexto do SwiftUI
    /// - Returns: instância do PDFView configurada
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true // Ajusta automaticamente o PDF para caber na tela
        pdfView.displayMode = .singlePageContinuous // Exibe páginas em fluxo contínuo
        pdfView.displayDirection = .vertical // Scroll vertical
        return pdfView
    }

    /// Atualiza o PDFView com o documento atual
    /// - Parameters:
    ///   - uiView: PDFView existente
    ///   - context: contexto do SwiftUI
    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = pdfDocument
    }
}
