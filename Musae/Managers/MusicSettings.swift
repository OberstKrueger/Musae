import Combine

/// User settings.
class MusicSettings: ObservableObject {
    // MARK: - Initializations
    init() {
        sortByAveragePlayCount = defaults.sortByAveragePlayCount
        upNextMinutes = defaults.upNextMinutes
    }
    
    // MARK: - Private Properties
    /// The user defaults database.
    let defaults = Defaults()

    // MARK: - Public Properties
    @Published var _upNextMinutes: Int = 1
    @Published var _sortByAveragePlayCount: Bool = false

    // MARK: - Public Functions
    /// Sort playlist view by average playcount instead of alphabetically.
    var sortByAveragePlayCount: Bool {
        get { return _sortByAveragePlayCount }
        set {
            defaults.sortByAveragePlayCount = newValue
            _sortByAveragePlayCount = newValue
        }
    }

    /// Number of minutes for Up Next play.
    var upNextMinutes: Int {
        get { return _upNextMinutes }
        set {
            switch newValue {
            case ...0:       _upNextMinutes = 1
            case 1...480: _upNextMinutes = newValue
            default:      _upNextMinutes = 480
            }

            defaults.upNextMinutes = newValue
        }
    }
}
