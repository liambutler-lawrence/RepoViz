import Cocoa

class ViewController: NSViewController {

    // MARK: - Interface Build Outlets

    @IBOutlet var repoStackView: NSStackView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadUI()
    }

    // MARK: - Interface Builder Actions

    @IBAction func refreshButtonClicked(sender: Any) {
        reloadUI()
    }
}

private extension ViewController {

    // MARK: - Functions

    func reloadUI() {
        repoStackView.subviews.forEach { $0.removeFromSuperview() }

        let repoGraphModel = RepoGraphModel()
        repoGraphModel.repoModels.forEach { repoViewModel in
            let repoModel = repoViewModel.repoModel

            // - Repo View

            let repoView = RepoView()

            // Colored Strings

            repoView.repoNameTextField.stringValue = repoModel.name
            repoView.repoNameTextField.textColor = repoViewModel.color

            repoView.currentBranchTextField.stringValue = repoModel.branchName ?? "ERROR"
            repoView.currentBranchTextField.textColor = repoViewModel.color

            // Strings

            repoView.divergedFromDevelopCommitHashTextField.stringValue = repoModel.divergedFromDevelopCommitHash ?? "ERROR"

            // Number of Commits

            repoView.numberOfCommitsBehindRemoteTextField.stringValue = repoModel.numberOfCommitsDivergedFromRemote
                .map { "\($0.behind) behind, \($0.ahead) ahead" } ?? "ERROR"
            repoView.numberOfCommitsDivergedFromDevelopTextField.stringValue = repoModel.numberOfCommitsDivergedFromRemoteDevelop
                .map { "\($0.behind) behind, \($0.ahead) ahead" } ?? "ERROR"

            // Time Intervals

            let dateComponentsFormatter = DateComponentsFormatter()
            dateComponentsFormatter.unitsStyle = .abbreviated

            repoView.timeIntervalBehindRemoteTextField.stringValue = repoModel.timeIntervalBehindRemote
                .flatMap { dateComponentsFormatter.string(from: $0)} ?? "ERROR"
            repoView.timeIntervalSinceDivergedFromDevelopTextField.stringValue = repoModel.timeIntervalSinceDivergedFromRemoteDevelop
                .flatMap { dateComponentsFormatter.string(from: $0)} ?? "ERROR"

            // Dates

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium

            repoView.latestCommitDateTextField.stringValue = repoModel.latestCommitDate
                .map { dateFormatter.string(from: $0)} ?? "ERROR"
            repoView.latestRemoteCommitDateTextField.stringValue = repoModel.latestRemoteCommitDate
                .map { dateFormatter.string(from: $0)} ?? "ERROR"
            repoView.latestDevelopCommitDateTextField.stringValue = repoModel.latestRemoteDevelopCommitDate
                .map { dateFormatter.string(from: $0)} ?? "ERROR"
            repoView.divergedFromDevelopCommitDateTextField.stringValue = repoModel.divergedFromDevelopCommitDate
                .map { dateFormatter.string(from: $0)} ?? "ERROR"

            // - Repo Warning View

            let repoWarningView = RepoWarningView()

            // Colored Strings

            repoWarningView.repoNameTextField.stringValue = repoModel.name
            repoWarningView.repoNameTextField.textColor = repoViewModel.color

            repoWarningView.branchNameTextField.stringValue = repoModel.branchName ?? "ERROR"
            repoWarningView.branchNameTextField.textColor = repoViewModel.color

            // Warnings

            [
                repoViewModel.warningBehindRemote,
                repoViewModel.warningAheadOfRemote,
                repoViewModel.warningBehindDevelop,
                repoViewModel.warningUncommitedChanges,
                repoViewModel.warningNotOnAssociatedBranch
                ]
                .compactMap { $0 }
                .forEach { warning in
                    let warningView = NSTextField(labelWithString: warning)
                    repoWarningView.warningsStackView.addArrangedSubview(warningView)
            }

            let individualRepoStackView = NSStackView()
            individualRepoStackView.orientation = .horizontal

            individualRepoStackView.addArrangedSubview(repoView)
            individualRepoStackView.addArrangedSubview(repoWarningView)

            repoStackView.addArrangedSubview(individualRepoStackView)
        }
    }
}

// actions
// - open repo in preferred browser- sourcetree, terminal window, etc
// - set preferred browser (or just choose from list every time)
// - refresh (poll every 5 sec while open)
// - switch branch on "stack" of repos
// - pull on "stack" of repos
// - update dependencies on "stack" of repos

// notifications
// - you're running a project that has mismatched branches (IDE integration?)
// - you're running a project that has out of date branches (IDE integration?)

// visual
// - tree view
// - repos on same branch have same color
// - out of date repos have error icon/color
//
