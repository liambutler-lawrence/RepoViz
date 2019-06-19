import Cocoa

class ViewController: NSViewController {

    // MARK: - Constants

    let repoParentFolderPath = "/Users/liam/repos/"
    let repoNames = [
        "ios-mobile-client",
        "ios-mobile-sdk",
        "mobile-client-configurations"
    ]

    // MARK: - Interface Build Outlets

    @IBOutlet var repoStackView: NSStackView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadUI()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    // MARK: - Interface Builder Actions

    @IBAction func refreshButtonClicked(sender: Any) {
        reloadUI()
    }
}

private extension ViewController {

    // MARK: - Functions

    func reloadUI() {
        repoNames.forEach {
            let repoName = RepoModel(
                name: $0,
                repoParentFolderPath: URL(fileURLWithPath: repoParentFolderPath)
            )

            let repoView = RepoView()
            repoStackView.addArrangedSubview(repoView)

            repoView.repoNameTextField.stringValue = repoName.name
            repoView.currentBranchTextField.stringValue = repoName.branchName ?? "ERROR"

            repoView.numberOfCommitsBehindRemoteTextField.stringValue = repoName.numberOfCommitsBehindRemote
                .map { String($0) } ?? "ERROR"

            let dateComponentsFormatter = DateComponentsFormatter()
            dateComponentsFormatter.unitsStyle = .abbreviated
            repoView.timeIntervalBehindRemoteTextField.stringValue = repoName.timeIntervalBehindRemote
                .flatMap { dateComponentsFormatter.string(from: $0)} ?? "ERROR"

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium

            repoView.latestCommitDateTextField.stringValue = repoName.latestCommitDate
                .map { dateFormatter.string(from: $0)} ?? "ERROR"
            repoView.latestRemoteCommitDateTextField.stringValue = repoName.latestRemoteCommitDate
                .map { dateFormatter.string(from: $0)} ?? "ERROR"
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
