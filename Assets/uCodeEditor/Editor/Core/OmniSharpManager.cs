//  Copyright (c) 2018-present amlovey
//  
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using UnityEditor;
using System;
using System.Diagnostics;

#if UNITY_EDITOR_WIN
using System.Runtime.InteropServices;
#endif

namespace uCodeEditor
{
    /// <summary>
    /// Class that use to manage Omnisharp installation
    /// </summary>
    public class OmniSharpManager
    {
        public static string GetInstallationFolder()
        {
            string folder = Utility.PathCombine(Environment.GetFolderPath(Environment.SpecialFolder.Personal), ".uce");
            folder = Path.Combine(folder, "omnisharp");
            Directory.CreateDirectory(folder);
            return folder;
        }

        public static string GetInstalledOmnisharpPath()
        {
            return Utility.PathCombine(GetInstallationFolder(), "omnisharp", "omnisharp.exe");
        }

        public static void InstallOmnisharp()
        {
            try
            {
                string zipFilePath = GetOmnisharpZipFile();

                // If the omnisharp zip file is missing, 
                // don't do anythin and just return 
                if (!File.Exists(zipFilePath))
                {
                    return;
                }

                string title = "Install Omnisharp";
                string message = "There are no omnisharp (required by C#) installed, click 'Install' button to install one.";

                string zipFileName = GetOminsharpZipFileName();

                if (EditorUtility.DisplayDialog(title, message, "Install", ""))
                {
                    string installationFolder = GetInstallationFolder();
                    string msg = string.Format("Coping {0}", zipFileName);
                    EditorUtility.DisplayProgressBar(title, msg, 0f);

                    // 1. copy zip file to installation folder
                    string targetZipFilePath = Utility.PathCombine(installationFolder, zipFileName);
                    EditorUtility.DisplayProgressBar(title, msg, 0.3f);
                    File.Copy(zipFilePath, targetZipFilePath, true);

                    // 2. unzip it
                    msg = string.Format("Uncompressing {0}...", zipFileName);
                    EditorUtility.DisplayProgressBar(title, msg, 0.6f);
                    UnZipFile(targetZipFilePath);

                    // 3. delete zip file
                    msg = "Installing...";
                    EditorUtility.DisplayProgressBar(title, msg, 1f);
                    Clean(targetZipFilePath);
                }
            }
            catch (Exception e)
            {
                UnityEngine.Debug.Log(e);
            }
            finally
            {
                EditorUtility.ClearProgressBar();
            }
        }

        public static bool CheckInstallationExists()
        {
            return File.Exists(GetInstalledOmnisharpPath());
        }

        private static void Clean(string zipFile)
        {
            File.Delete(zipFile);
        }

        private static void UnZipFile(string zipFile)
        {
            // unzip on different platforms
            if (Application.platform == RuntimePlatform.WindowsEditor)
            {
                UnzipFileOnWindows(zipFile);
            }
            else
            {
                UnzipFileOnMac(zipFile);
            }
        }

        private static void UnzipFileOnMac(string zipFile)
        {
            Process p = new Process();
            p.StartInfo.FileName = "tar";
            p.StartInfo.Arguments = string.Format("-zxvpf {0}", zipFile);
            p.StartInfo.WorkingDirectory = GetInstallationFolder();
            p.Start();
            p.WaitForExit();
        }

        private static void UnzipFileOnWindows(string zipFile)
        {
            Process p = new Process();
            p.StartInfo.FileName = Utility.PathCombine(Application.dataPath, "uCodeEditor", "Editor", "Tools", "unzip.exe");

            string arguemnts = string.Format("\"{0}\" -d \"{1}\\omnisharp\"", zipFile, GetInstallationFolder());
            p.StartInfo.Arguments = arguemnts;

            p.StartInfo.CreateNoWindow = true;
            p.StartInfo.UseShellExecute = false;
            p.Start();
            p.WaitForExit();
        }

        private static string GetOminsharpZipFileName()
        {
#if UNITY_EDITOR_WIN
            if (Is64Bit())
            {
                return "omnisharp-win-x64.zip";
            }
            else
            {
                return "omnisharp-win-x86.zip";
            }        
#elif UNITY_EDITOR_OSX
            return "omnisharp-osx.tar.gz";
#else   
            return "";
#endif
        }

        private static string GetOmnisharpZipFile()
        {
            string folder = Utility.PathCombine(Application.dataPath, "uCodeEditor", "Editor", "Omnisharp");
            return Utility.PathCombine(folder, GetOminsharpZipFileName());
        }

#if UNITY_EDITOR_WIN
        [DllImport("kernel32.dll", SetLastError = true, CallingConvention = CallingConvention.Winapi)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool IsWow64Process([In] IntPtr hProcess, [Out] out bool lpSystemInfo);

        private static bool Is64Bit()
        {
            if (IntPtr.Size == 8 || (IntPtr.Size == 4 && Is32BitProcessOn64BitProcessor()))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        private static bool Is32BitProcessOn64BitProcessor()
        {
            bool retVal;

            IsWow64Process(Process.GetCurrentProcess().Handle, out retVal);

            return retVal;
        }
#endif
    }
}
