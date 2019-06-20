import Cocoa

class NibView: NSView {

    // MARK: - Variable Properties

    var contentView: NSView!

    // MARK: - Initializers

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        sharedInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
}

private extension NibView {

    // MARK: - Functions

    func sharedInit() {
        var topLevelObjects: NSArray?
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, topLevelObjects: &topLevelObjects)
        contentView = (topLevelObjects! as! [Any]).compactMap { $0 as? NSView }.first
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
