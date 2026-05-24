using Microsoft.UI.Xaml;

namespace WsaPacman;

public partial class App : Application
{
    private Window? _window;

    public App()
    {
        InitializeComponent();
    }

    protected override void OnLaunched(LaunchActivatedEventArgs args)
    {
        var cmdArgs = System.Environment.GetCommandLineArgs();

        for (int i = 1; i < cmdArgs.Length; i++)
        {
            if (cmdArgs[i] == "--install" && i + 1 < cmdArgs.Length)
            {
                var apkPath = cmdArgs[i + 1];
                var win = new InstallerWindow { ApkPath = apkPath };
                win.Activate();
                _window = win;
                return;
            }
            if (cmdArgs[i] == "--uninstall" && i + 1 < cmdArgs.Length)
            {
                var packageId = cmdArgs[i + 1];
                var win = new UninstallerWindow();
                win.Initialize(packageId, string.Empty);
                win.Activate();
                _window = win;
                return;
            }
        }

        _window = new MainWindow();
        _window.Activate();
    }
}
