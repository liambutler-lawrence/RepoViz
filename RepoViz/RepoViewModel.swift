import Cocoa

struct RepoViewModel {

    // MARK: - Constant Properties

    let repoModel: RepoModel
    let color: NSColor

    // MARK: - Computed Properties

    var infoBranchName: String? {
        guard let branchName = repoModel.branchName else {
            return "Could not determine current branch name"
        }

        return "On \(branchName)"
    }

    var warningBehindRemote: String? {
        guard let branchName = repoModel.branchName,
            let numberOfCommitsDivergedFromRemote = repoModel.numberOfCommitsDivergedFromRemote,
            let timeIntervalBehindRemote = repoModel.timeIntervalBehindRemote.flatMap({ string(for: $0) }) else {
                return "Could not determine if behind remote or not"
        }

        guard numberOfCommitsDivergedFromRemote.behind > 0 else {
            return nil
        }

        return "Behind origin/\(branchName) by \(numberOfCommitsDivergedFromRemote.behind) commits (last updated \(timeIntervalBehindRemote) ago)"
    }

    var warningBehindDevelop: String? {
        guard repoModel.branchName != "develop" else {
            return nil
        }

        guard let numberOfCommitsDivergedFromDevelop = repoModel.numberOfCommitsDivergedFromRemoteDevelop,
            let timeIntervalSinceDivergedFromRemoteDevelop = repoModel.timeIntervalSinceDivergedFromRemoteDevelop.flatMap({ string(for: $0) }) else {
                return "Could not determine if behind remote or not"
        }

        guard numberOfCommitsDivergedFromDevelop.behind > 0 else {
            return nil
        }

        return "Behind origin/develop by \(numberOfCommitsDivergedFromDevelop.behind) commits (diverged \(timeIntervalSinceDivergedFromRemoteDevelop) ago)"
    }

    var warningAheadOfRemote: String? {
        guard let branchName = repoModel.branchName,
            let numberOfCommitsDivergedFromRemote = repoModel.numberOfCommitsDivergedFromRemote,
            let timeIntervalBehindRemote = repoModel.timeIntervalBehindRemote.flatMap({ string(for: $0) }) else {
                return "Could not determine if any commits not pushed to remote"
        }

        guard numberOfCommitsDivergedFromRemote.ahead > 0 else {
            return nil
        }

        return "\(numberOfCommitsDivergedFromRemote.ahead) commits not pushed to origin/\(branchName) (last pushed \(timeIntervalBehindRemote) ago)"
    }

    var warningNotOnAssociatedBranch: String? {
        return nil
    }

    var warningUncommitedChanges: String? {
        return nil
    }
}

private extension RepoViewModel {

    func string(for timeInterval: TimeInterval) -> String? {
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.unitsStyle = .abbreviated

        return dateComponentsFormatter.string(from: timeInterval)
    }
    
}
