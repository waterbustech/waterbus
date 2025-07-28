import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
    override func awakeFromNib() {

        if #available(macOS 10.13, *) {
            let customToolbar = NSToolbar()
            customToolbar.showsBaselineSeparator = false
        }

        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.isMovableByWindowBackground = false

        if #available(macOS 11.0, *) {
            self.toolbarStyle = .unified
        }

        self.styleMask.insert(.fullSizeContentView)

        self.isOpaque = true
        self.backgroundColor = .black

        let flutterViewController = FlutterViewController()
        let windowFrame = self.frame
        self.contentViewController = flutterViewController
        self.setFrame(windowFrame, display: true)
        
        self.minSize = NSSize(width: 1024, height: 720)
        
        RegisterGeneratedPlugins(registry: flutterViewController)
        
        super.awakeFromNib()
    }
}
