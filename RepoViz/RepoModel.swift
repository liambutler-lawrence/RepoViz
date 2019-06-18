import Foundation



struct RepoModel {

    private func shell(launchPath: String = "/bin/bash", _ arguments: String...) -> String?
    {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = ["-c"] + arguments

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)

        return output
    }

    let name: String

    var branchName: String? {
        let branchName = shell("git branch | grep \\* | cut -d ' ' -f2")

        guard branchName != "(HEAD" else {
            return nil
        }
        return branchName
    }

    var latestCommitDate: Date? {
        return dateOfLatestCommit(onBranch: branchName)
    }

    var numberOfCommitsBehindRemote: Int? {
        let numberString = branchName.flatMap { shell("git rev-list --count origin/\($0)...\($0)") }

        return numberString.flatMap { Int($0) }
    }

    var latestRemoteCommitDate: Date? {
        return dateOfLatestCommit(onBranch: branchName.map { "origin/\($0)" })
    }

    func dateOfLatestCommit(onBranch branchName: String?) -> Date? {
        let dateString = branchName.flatMap { shell("git show -s --format=%ct \($0)") }

        return dateString
            .flatMap { TimeInterval($0) }
            .map { Date(timeIntervalSince1970: $0) }
    }

    var timeIntervalBehindRemote: TimeInterval? {
        return latestRemoteCommitDate.flatMap { latestCommitDate?.timeIntervalSince($0) }
    }
}

//struct RepoInformationService {
//    func getInfo() -> RepoModel {
//
//    }
//}


// data
// - (req: list of repos) for each repo :
// - current branch, or none
// - (req: network fetch) number of commits behind remote branch, or none if not on branch, or none if multiple remotes, or pending during fetch
// - (req: network fetch) amount of time (m/h/d/w) behind remote branch, or none if not on branch, or none if multiple remotes, or pending during fetch
// - time of latest local commit
// - (req: network fetch) time of latest remote commit, or pending during fetch
