import MediaPlayer

class MusicLibrary {
    /// OS-provided media library.
    let library = MPMediaLibrary()

    /// Whether the library is currently being loaded.
    var isLoading: Bool = false

    /// Date the library was last updated.
    var lastUpdated: Date?

    /// Set of playlists, organized by category.
    var playlists: [String: [MusicPlaylist]] = [:]

    /// Loads playlists and categories from music library.
    func loadMusic() {
        if isLoading == false {
            isLoading = true

            DispatchQueue.global().async { [self] in
                let libraryLastModifiedDate = library.lastModifiedDate
                var libraryPlaylists: [String: [MusicPlaylist]] = [:]

                if let lists = MPMediaQuery.playlists().collections as? [MPMediaPlaylist] {
                    for list in lists {
                        if let nameComponents = validName(name: list.name ?? "") {
                            let newPlaylist = MusicPlaylist(items: list.items, title: nameComponents.name)

                            libraryPlaylists[nameComponents.category, default: []].append(newPlaylist)
                        }
                    }

                    DispatchQueue.main.async {
                        playlists = libraryPlaylists
                        lastUpdated = libraryLastModifiedDate

                        isLoading = false
                    }
                }
            }
        }
    }

    /// Updates playlists if they have been changed.
    func updateMusic() {
        if let last = lastUpdated {
            if library.lastModifiedDate != last {
                loadMusic()
            }
        } else {
            loadMusic()
        }
    }

    /// Checks if the playlist has a valid name.
    fileprivate func validName(name: String) -> (category: String, name: String)? {
        let elements = name.components(separatedBy: " - ")

        if elements.count == 2 {
            return (elements[0], elements[1])
        } else {
            return nil
        }
    }
}