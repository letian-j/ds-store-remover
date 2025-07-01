//
//  ContentView.swift
//  DS-Store-Remover
//
//  Created by administrator on 2025/7/1.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedFolders: [URL] = []
    @State private var isPickingFolder = false
    @State private var isCleaning = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button("Choose Folders") {
                    isPickingFolder = true
                }
                .fileImporter(isPresented: $isPickingFolder, allowedContentTypes: [.folder], allowsMultipleSelection: true) { result in
                    switch result {
                    case .success(let urls):
                        for url in urls where !selectedFolders.contains(url) {
                            selectedFolders.append(url)
                        }
                    case .failure(let error):
                        alertMessage = "Failed to pick folder: \(error.localizedDescription)"
                        showAlert = true
                    }
                }
            }
            .padding(.bottom)

            List {
                ForEach(selectedFolders, id: \..self) { folder in
                    HStack {
                        Text(folder.path)
                        Spacer()
                        Button(action: {
                            if let idx = selectedFolders.firstIndex(of: folder) {
                                selectedFolders.remove(at: idx)
                            }
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .onDrop(of: ["public.file-url"], isTargeted: nil) { providers in
                for provider in providers {
                    _ = provider.loadObject(ofClass: URL.self) { url, _ in
                        if let url = url, url.hasDirectoryPath, !selectedFolders.contains(url) {
                            DispatchQueue.main.async {
                                selectedFolders.append(url)
                            }
                        }
                    }
                }
                return true
            }
            .frame(minHeight: 150)

            HStack {
                Spacer()
                Button("Clean Up") {
                    isCleaning = true
                    Task {
                        do {
                            for folder in selectedFolders {
                                try await FileCleaner.clean(folder: folder)
                            }
                            alertMessage = "Cleanup complete"
                        } catch {
                            alertMessage = "Error: \(error.localizedDescription)"
                        }
                        isCleaning = false
                        showAlert = true
                    }
                }
                .disabled(selectedFolders.isEmpty || isCleaning)
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Ds Store Remover"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ContentView()
}
