import SwiftUI

struct MainView: View {
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var library = MusicLibrary()

    var body: some View {
        TabView {
            MusicDailyView(library: library)
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Daily")
                }
            MusicPlaylistsView(library: library)
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Playlists")
                }
            MusicSettingsView(library: library)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                library.startTimer()
            case .inactive:
                library.stopTimer()
            default:
                break
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
