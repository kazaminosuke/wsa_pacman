using System.Runtime.InteropServices;
using System.Runtime.InteropServices.ComTypes;
using System.Text;
using WsaPacman.Services.Core;

namespace WsaPacman.Services;

/// <summary>内部処理設計書 §2.9. .lnk 作成（IShellLinkW COM）・スタートメニュー .lnk 削除。</summary>
public interface IShortcutService
{
    /// <summary>デスクトップに WSAアプリ起動ショートカットを作成する（apk_installer.createLaunchIcon 踏襲）。</summary>
    void CreateWsaAppShortcut(string package, string appName);

    /// <summary>スタートメニュー(Programs)配下から "*{appName}*.lnk" を再帰検索して削除する。</summary>
    int DeleteStartMenuShortcuts(string appName);
}

public sealed class ShortcutService(IWsaEnvironment environment) : IShortcutService
{
    public void CreateWsaAppShortcut(string package, string appName)
    {
        var localAppData = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
        var target = Path.Combine(localAppData, "Microsoft", "WindowsApps", environment.WsaFamilyName, "WsaClient.exe");
        var iconPath = Path.Combine(localAppData, "Packages", environment.WsaFamilyName, "LocalState", $"{package}.ico");
        var desktop = Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory);
        var lnkPath = Path.Combine(desktop, SanitizeFileName(appName) + ".lnk");

        var shellLink = (IShellLinkW)new ShellLink();
        shellLink.SetPath(target);
        shellLink.SetArguments($"/launch wsa://{package}");
        shellLink.SetIconLocation(iconPath, 0);

        ((IPersistFile)shellLink).Save(lnkPath, false);
        Marshal.ReleaseComObject(shellLink);
    }

    public int DeleteStartMenuShortcuts(string appName)
    {
        var programsDir = Environment.GetFolderPath(Environment.SpecialFolder.Programs);
        if (!Directory.Exists(programsDir)) return 0;

        var deleted = 0;
        foreach (var file in Directory.EnumerateFiles(programsDir, $"*{appName}*.lnk", SearchOption.AllDirectories))
        {
            try
            {
                File.Delete(file);
                deleted++;
            }
            catch
            {
                // Best effort, matching the Flutter PowerShell version's -ErrorAction SilentlyContinue.
            }
        }
        return deleted;
    }

    private static string SanitizeFileName(string name)
    {
        foreach (var c in Path.GetInvalidFileNameChars()) name = name.Replace(c, '_');
        return name;
    }

    [ComImport]
    [Guid("00021401-0000-0000-C000-000000000046")]
    private class ShellLink;

    [ComImport]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    [Guid("000214F9-0000-0000-C000-000000000046")]
    private interface IShellLinkW
    {
        void GetPath([Out, MarshalAs(UnmanagedType.LPWStr)] StringBuilder pszFile, int cchMaxPath, out nint pfd, int fFlags);
        void GetIDList(out nint ppidl);
        void SetIDList(nint pidl);
        void GetDescription([Out, MarshalAs(UnmanagedType.LPWStr)] StringBuilder pszName, int cchMaxName);
        void SetDescription([MarshalAs(UnmanagedType.LPWStr)] string pszName);
        void GetWorkingDirectory([Out, MarshalAs(UnmanagedType.LPWStr)] StringBuilder pszDir, int cchMaxPath);
        void SetWorkingDirectory([MarshalAs(UnmanagedType.LPWStr)] string pszDir);
        void SetArguments([MarshalAs(UnmanagedType.LPWStr)] string pszArgs);
        void GetArguments([Out, MarshalAs(UnmanagedType.LPWStr)] StringBuilder pszArgs, int cchMaxPath);
        void GetHotkey(out short pwHotkey);
        void SetHotkey(short wHotkey);
        void GetShowCmd(out int piShowCmd);
        void SetShowCmd(int iShowCmd);
        void GetIconLocation([Out, MarshalAs(UnmanagedType.LPWStr)] StringBuilder pszIconPath, int cchIconPath, out int piIcon);
        void SetIconLocation([MarshalAs(UnmanagedType.LPWStr)] string pszIconPath, int iIcon);
        void SetRelativePath([MarshalAs(UnmanagedType.LPWStr)] string pszPathRel, int dwReserved);
        void Resolve(nint hwnd, int fFlags);
        void SetPath([MarshalAs(UnmanagedType.LPWStr)] string pszFile);
    }
}
