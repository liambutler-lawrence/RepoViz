import Foundation

struct RepoGraphModel {

    // MARK: - Constants

    let repoNames = [
        "ios-mobile-client",
        "ios-mobile-sdk",
        "mobile-client-configurations"
    ]
    let repoParentFolderPath = "/Users/liam/repos/"

    // MARK: - Computed Properties

    var repoModels: [RepoModel] {
        return repoNames.map {
            RepoModel(name: $0, repoParentFolderPath: URL(fileURLWithPath: repoParentFolderPath))
        }
    }
}
