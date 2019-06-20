import Cocoa

class RepoWarningView: NibView {

    // MARK: - Interface Builder Outlets

    @IBOutlet var repoNameTextField: NSTextField!
    @IBOutlet var branchNameTextField: NSTextField!
    @IBOutlet var warningsStackView: NSStackView!
}
