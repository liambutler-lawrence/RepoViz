import Foundation
import ShellOut

struct RepoModel {

    struct NumberOfCommits {
        let behind: Int
        let ahead: Int
    }

    // MARK: - Constant Properties

    let name: String
    let repoParentFolderPath: URL

    // MARK: - Computed Properties

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

    var latestRemoteCommitDate: Date? {
        return dateOfLatestCommit(onBranch: branchName.map { "origin/\($0)" })
    }

    var latestRemoteDevelopCommitDate: Date? {
        return dateOfLatestCommit(onBranch: "origin/develop")
    }

    var numberOfCommitsBehindRemote: NumberOfCommits? {
        return branchName.flatMap { numberOfCommitsBetween(upstreamBranch: "origin/\($0)", downstreamBranch: $0) }
    }

    var divergedFromDevelopCommitDate: Date? {
        return divergedFromDevelopCommitHash.flatMap { dateOfLatestCommit(onBranch: $0) }
    }

    var divergedFromDevelopCommitHash: String? {
        return branchName.flatMap { try? shellOut(to: "git merge-base \($0) origin/develop", at: shellCommandDirectory) }
    }

    var numberOfCommitsDivergedFromRemoteDevelop: NumberOfCommits? {
        return branchName.flatMap { numberOfCommitsBetween(upstreamBranch: "origin/develop", downstreamBranch: $0) }
    }

    var timeIntervalBehindRemote: TimeInterval? {
        return latestCommitDate.flatMap { latestRemoteCommitDate?.timeIntervalSince($0) }
    }

    var timeIntervalSinceDivergedFromRemoteDevelop: TimeInterval? {
        return divergedFromDevelopCommitDate.flatMap { latestRemoteDevelopCommitDate?.timeIntervalSince($0) }
    }
}

private extension RepoModel {

    // MARK: - Functions

    func dateOfLatestCommit(onBranch branchName: String?) -> Date? {
        return branchName
            .flatMap { try? shellOut(to: "git show -s --format=%ct \($0)", at: shellCommandDirectory) }
            .flatMap { TimeInterval($0) }
            .map { Date(timeIntervalSince1970: $0) }
    }

    func numberOfCommitsBetween(upstreamBranch: String, downstreamBranch: String) -> NumberOfCommits? {
        let optionalNumberOfCommits = try? shellOut(to: "git rev-list --count --left-right \(upstreamBranch)...\(downstreamBranch)", at: shellCommandDirectory)
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
            .map { Int($0) }

        guard let numberOfCommits = optionalNumberOfCommits,
            numberOfCommits.count == 2,
            let numberOfCommitsBehind = numberOfCommits.first!,
            let numberOfCommitsAhead = numberOfCommits.last! else {
                return nil
        }

        return NumberOfCommits(behind: numberOfCommitsBehind, ahead: numberOfCommitsAhead)
    }
}


// data
// - (req: list of repos) for each repo :
// - current branch, or none
// - (req: network fetch) number of commits behind remote branch, or none if not on branch, or none if multiple remotes, or pending during fetch
// - (req: network fetch) amount of time (m/h/d/w) behind remote branch, or none if not on branch, or none if multiple remotes, or pending during fetch
// - time of latest local commit
// - (req: network fetch) time of latest remote commit, or pending during fetch
