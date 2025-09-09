//
//  GlobalViewModel.swift
//  VozPDF
//
//  Created by Vagner Oliveira on 08/09/25.
//

import Foundation
import AVFAudio
import PDFKit

/// ViewModel global responsável por gerenciar o estado da aplicação
/// relacionada à leitura de PDFs com voz.
/// Contém informações sobre PDF atual, sintetizador de voz, idioma,
/// velocidade da fala, locutores disponíveis e controle de UI.
class GlobalViewModel: ObservableObject {
    
    // MARK: - Propriedades
    
    /// Lista de todas as vozes disponíveis no dispositivo
    let availableVoices = AVSpeechSynthesisVoice.speechVoices()

    /// Idioma atualmente selecionado pelo usuário
    @Published var selectedIdioma: String
    
    /// Velocidade da fala do sintetizador (0.0 a 1.0, padrão 0.5)
    @Published var velocity = 0.5 as Float
    
    /// Controla se a lista de PDFs recentes deve ser exibida
    @Published var showRecentPDFs = false
    
    /// Instância do sintetizador de voz usado para falar o texto
    @Published var synthesizer = AVSpeechSynthesizer()
    
    /// URL do PDF atualmente selecionado
    @Published var pdfURL: URL? = nil
    
    /// Controla a exibição do document picker para selecionar PDF
    @Published var showDocumentPicker = false
    
    /// Identificador da voz selecionada pelo usuário
    @Published var selectedLocutorIdentifier: String? = nil
    
    /// Indica se o botão de pausa deve ser mostrado
    @Published var showPauseButton = false
    
    /// Indica se a fala está atualmente pausada
    @Published var isPaused = false
    
    // MARK: - Computed Properties
    
    /// Lista de locutores disponíveis para o idioma atualmente selecionado
    var locutoresAtuais: [AVSpeechSynthesisVoice] {
        AVSpeechSynthesisVoice.speechVoices().filter { $0.language == selectedIdioma }
    }
    
    // MARK: - Inicializador
    
    /// Inicializa o ViewModel, selecionando automaticamente o idioma
    /// que corresponde à região do dispositivo, ou "en-US" como padrão.
    init() {
        selectedIdioma = availableVoices.first { $0.language.hasSuffix(Locale.current.language.region?.identifier ?? "") }?.language ?? "en-US"
    }
    
    // MARK: - Métodos
    
    /// Inicia a leitura em voz do PDF selecionado.
    /// - Extrai o texto completo do PDF página por página.
    /// - Limpa caracteres HTML ou espaços especiais.
    /// - Configura a voz e a velocidade do `AVSpeechUtterance`.
    /// - Inicia a fala com `AVSpeechSynthesizer`.
    func speakPDF() {
        // Verifica se há PDF carregado
        guard let pdfURL = pdfURL else {
            print("Nenhum PDF carregado")
            return
        }
        
        // Tenta abrir o PDF
        guard let document = PDFDocument(url: pdfURL) else {
            print("Não foi possível abrir o PDF")
            return
        }
        
        // Extrai o texto completo do PDF
        var fullText = ""
        for i in 0..<document.pageCount {
            if let page = document.page(at: i), let pageText = page.string {
                fullText += pageText + "\n"
            }
        }
        
        // Remove tags HTML e caracteres especiais
        let sanitizedText = fullText
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression) // remove tags HTML
            .replacingOccurrences(of: "&nbsp;", with: " ") // remove espaços especiais
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Verifica se há texto para falar
        if sanitizedText.isEmpty {
            print("PDF vazio")
            return
        }
        
        // Configura o utterance com texto, voz e velocidade
        let utterance = AVSpeechUtterance(string: sanitizedText)
        utterance.rate = velocity
        if let locutorID = selectedLocutorIdentifier,
           let voice = AVSpeechSynthesisVoice(identifier: locutorID) {
            utterance.voice = voice
        }
        
        // Se já estiver falando, interrompe imediatamente
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        // Inicia a fala
        synthesizer.speak(utterance)
        
        // Mostra o botão de pausa na UI
        showPauseButton = true
    }
    
}
