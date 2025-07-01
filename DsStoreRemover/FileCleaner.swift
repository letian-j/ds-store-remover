import Foundation

struct FileCleaner {
    static func clean(folder: URL) async throws {
        let fileManager = FileManager.default
        let resourceKeys: [URLResourceKey] = [.isDirectoryKey]
        let enumerator = fileManager.enumerator(at: folder, includingPropertiesForKeys: resourceKeys, options: [.skipsHiddenFiles])
        while let fileURL = enumerator?.nextObject() as? URL {
            if fileURL.lastPathComponent == ".DS_Store" {
                try? fileManager.removeItem(at: fileURL)
            }
        }
    }
} 