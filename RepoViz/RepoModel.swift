import Foundation
import ShellOut

struct RepoModel {

    let name: String
    let repoParentFolderPath: URL

    var shellCommandDirectory: String {
        return repoParentFolderPath.appendingPathComponent(name, isDirectory: true).path
    }

    var branchName: String? {
        let branchName = try? shellOut(to: "git branch | grep \\* | cut -d ' ' -f2", at: shellCommandDirectory)

        guard branchName != "(HEAD" else {
            return nil
        }
        return branchName
    }

    var latestCommitDate: Date? {
        return dateOfLatestCommit(onBranch: branchName)
    }

    var numberOfCommitsBehindRemote: Int? {
        return branchName
            .flatMap { try? shellOut(to: "git rev-list --count origin/\($0)...\($0)", at: shellCommandDirectory) }
            .flatMap { Int($0) }
    }

    var latestRemoteCommitDate: Date? {
        return dateOfLatestCommit(onBranch: branchName.map { "origin/\($0)" })
    }

    func dateOfLatestCommit(onBranch branchName: String?) -> Date? {
        return branchName
            .flatMap { try? shellOut(to: "git show -s --format=%ct \($0)", at: shellCommandDirectory) }
            .flatMap { TimeInterval($0) }
            .map { Date(timeIntervalSince1970: $0) }
    }

    var timeIntervalBehindRemote: TimeInterval? {
        return latestRemoteCommitDate.flatMap { latestCommitDate?.timeIntervalSince($0) }
    }
}


// data
// - (req: list of repos) for each repo :
// - current branch, or none
// - (req: network fetch) number of commits behind remote branch, or none if not on branch, or none if multiple remotes, or pending during fetch
// - (req: network fetch) amount of time (m/h/d/w) behind remote branch, or none if not on branch, or none if multiple remotes, or pending during fetch
// - time of latest local commit
// - (req: network fetch) time of latest remote commit, or pending during fetch
