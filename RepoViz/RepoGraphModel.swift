import Cocoa
import Foundation

struct RepoGraphModel {

    // MARK: - Constants

    let repoNames = [
        "ios-mobile-client",
        "ios-mobile-sdk",
        "mobile-client-configurations"
    ]
    let colors: [NSColor] = [
        .red,
        .blue,
        .green
    ]
    let repoParentFolderPath = "/Users/liam/repos/"

    // MARK: - Computed Properties

    var repoModels: [RepoViewModel] {
        let repoModels = repoNames.map {
            RepoModel(name: $0, repoParentFolderPath: URL(fileURLWithPath: repoParentFolderPath))
        }
        let uniqueBranchNames = Set(repoModels.map { $0.branchName })
        let colorsByBranchName = Dictionary(uniqueKeysWithValues: zip(uniqueBranchNames, colors))

        return repoModels.map {
            RepoViewModel(repoModel: $0, color: colorsByBranchName[$0.branchName]!)
        }
    }
}
