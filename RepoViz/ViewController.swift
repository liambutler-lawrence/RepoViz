import Cocoa

class ViewController: NSViewController {

    @IBOutlet var currentBranchTextField: NSTextField!
    @IBOutlet var numberOfCommitsBehindRemoteTextField: NSTextField!
    @IBOutlet var timeIntervalBehindRemoteTextField: NSTextField!
    @IBOutlet var latestCommitDateTextField: NSTextField!
    @IBOutlet var latestRemoteCommitDateTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
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
