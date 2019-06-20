import Cocoa

class RepoView: NibView {

    // MARK: - Interface Builder Outlets

    @IBOutlet var repoNameTextField: NSTextField!
    @IBOutlet var currentBranchTextField: NSTextField!
    @IBOutlet var latestCommitDateTextField: NSTextField!
    @IBOutlet var numberOfCommitsBehindRemoteTextField: NSTextField!
    @IBOutlet var timeIntervalBehindRemoteTextField: NSTextField!
    @IBOutlet var latestRemoteCommitDateTextField: NSTextField!
    @IBOutlet var numberOfCommitsDivergedFromDevelopTextField: NSTextField!
    @IBOutlet var timeIntervalSinceDivergedFromDevelopTextField: NSTextField!
    @IBOutlet var latestDevelopCommitDateTextField: NSTextField!
    @IBOutlet var divergedFromDevelopCommitDateTextField: NSTextField!
    @IBOutlet var divergedFromDevelopCommitHashTextField: NSTextField!
}
