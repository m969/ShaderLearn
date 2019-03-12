//  Copyright (c) 2018-present amlovey
//  
using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using System.IO;
using System;
using System.Text;
using System.Linq;

namespace uCodeEditor
{
    /// <summary>
    /// Use this class to receive message from webpage or send message to webpage
    /// </summary>
    public partial class WebviewComService : ScriptableObject
    {
        private Webview _webview;
        private CallbackWrapper wrap;

        private const string SCRIPTOBJECTNAME = "uCodeEditor";

        public WebviewComService()
        {

        }

        private void ExecuteJavascript(string javascript)
        {
            if (this._webview != null)
            {
                this._webview.ExecuteJavascript(javascript);
            }
        }

        public void Init(Webview webview)
        {
            if (webview == null)
            {
                return;
            }

            webview.DefineScriptObject(SCRIPTOBJECTNAME, this);
            webview.SetDelegateObject(this);
            this._webview = webview;
        }

        /// <summary>
        /// Open file in code editor at specfic line
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="line"></param>
        public void UEOpenFile(string filePath, int line)
        {
            if (File.Exists(filePath))
            {
                string fileFullPath = Path.GetFullPath(filePath);
                string js = string.Format(@"window.openAtLine('{0}', {1})", Utility.PathNormalized(fileFullPath), line);
                ExecuteJavascript(js);
            }
        }

        public void LoadFile(string message, object callback)
        {
            if (string.IsNullOrEmpty(message))
            {
                return;
            }

            this.UEOpenFile(Utility.FromBase64(message));
        }

        public void UEOpenFile(string filePath, bool openNew = true)
        {
            if (File.Exists(filePath))
            {
                string fileFullPath = Path.GetFullPath(filePath);
                PlayerPrefs.SetString(Constants.CURRENT_FILE_KEY, Utility.PathNormalized(fileFullPath));
                string js = string.Format(@"window.loadCodeFile({0});", openNew ? "true" : "false");
                ExecuteJavascript(js);
            }
        }

        private void DebugLog(string message, object callback)
        {
            Debug.Log(message);
        }

        private void GetPlayerPerfsValue(string message, object callback)
        {
            var value = PlayerPrefs.GetString(message);
            if (string.IsNullOrEmpty(value))
            {
                value = string.Empty;
            }

            wrap = new CallbackWrapper(callback);
            wrap.Send(value);
        }

        private void GetEditorPerfsValue(string message, object callback)
        {
            var value = EditorPrefs.GetString(message);
            if (string.IsNullOrEmpty(value))
            {
                value = string.Empty;
            }

            wrap = new CallbackWrapper(callback);
            wrap.Send(value);
        }

        private void SetEditorPerfsValue(string message, object callback)
        {
            if (string.IsNullOrEmpty(message))
            {
                return;
            }

            var msg = Utility.FromBase64(message);
            if (string.IsNullOrEmpty(msg))
            {
                return;
            }

            var temp = msg.Split(new char[] { '$' }, StringSplitOptions.RemoveEmptyEntries);
            if (temp.Length >= 2)
            {
                var key = temp[0];
                var value = temp[1];
                EditorPrefs.SetString(key, value);
            }
        }

        private void DeletePlayerPerfsKey(string message, object callback)
        {
            if (string.IsNullOrEmpty(message))
            {
                return;
            }

            PlayerPrefs.DeleteKey(message);
        }

        private void SetPlayerPerfsValue(string message, object callback)
        {
            if (string.IsNullOrEmpty(message))
            {
                return;
            }

            var temp = Utility.FromBase64(message).Split(new char[] { '$' }, StringSplitOptions.RemoveEmptyEntries);
            if (temp.Length >= 2)
            {
                var key = temp[0];
                var value = temp[1];
                PlayerPrefs.SetString(key, value);
            }
        }

        /// <summary>
        /// Save current file
        /// </summary>
        public void SaveCurrentModel()
        {
            string js = "window.save();";
            ExecuteJavascript(js);
        }

        public void SaveAll()
        {
            string js = "window.saveAll(true);";
            ExecuteJavascript(js);
        }

        private void SaveWithRefreh(string message, object callback)
        {
            SaveInternal(message, callback, true);
        }

        private void AutoSave(string message, object callback)
        {
            // AutoSave will not cause refrsh action
            SaveInternal(message, callback, false, true);
        }

        private void SaveInternal(string message, object callback, bool forceRefresh = false, bool forceNoRefresh = false)
        {
            wrap = new CallbackWrapper(callback);

            try
            {
                string data = Utility.FromBase64(message);
                int index = data.IndexOf("?");
                if (index == -1)
                {
                    return;
                }

                string filePath = data.Substring(0, index);
                string content = data.Substring(index + 1);

                if (!string.IsNullOrEmpty(filePath))
                {
                    bool isMemoryFile = filePath.StartsWith("inmemory");
                    // if the file is not saved
                    if (isMemoryFile)
                    {
                        Utility.Log(filePath);
                        var fileName = filePath.Substring(9);
                        filePath = EditorUtility.SaveFilePanel("Save To", Application.dataPath, fileName, "");
                    }

                    if (!string.IsNullOrEmpty(filePath))
                    {
                        filePath = Path.GetFullPath(filePath);
                        File.WriteAllText(filePath, content, Encoding.UTF8);
                        wrap.Send(filePath);

                        if (forceNoRefresh)
                        {
                            return;
                        }

                        // Don't reimport cs script here, beacause it will 
                        // casue scripts compile action and Unity Editor UI
                        // may freezed. 
                        if (forceRefresh || isMemoryFile || !filePath.ToLower().EndsWith(".cs"))
                        {
                            var assetPath = ToProjectRelativePath(filePath);
                            AssetDatabase.ImportAsset(assetPath, ImportAssetOptions.Default);
                        }
                    }
                }
                else
                {
                    Debug.LogError("No file saved");
                    wrap.Send("failed");
                }
            }
            catch (Exception e)
            {
                wrap.Send("failed");
                Debug.LogError(e);
            }
        }

        private void Save(string message, object callback)
        {
            SaveInternal(message, callback, false);
        }

        private void Refresh(string message, object callback)
        {
            EditorUtility.DisplayProgressBar("Syncing", "Syncing project...", .99f);

            // This will trigger a recompile.
            AssetDatabase.Refresh();

            EditorUtility.ClearProgressBar();
        }

        private void LoadLocalSettings(string message, object callback)
        {
            wrap = new CallbackWrapper(callback);
            wrap.Send(Utility.ConvertToBase64(LocalSettings.GetLocalSettings()));
        }

        private void SaveLocalSettings(string message, object callback)
        {
            string data = Utility.FromBase64(message);
            LocalSettings.SaveLocalSettings(data);
        }

        private void GetProjectId(string message, object callback)
        {
            wrap = new CallbackWrapper(callback);
            wrap.Send(OnLoad.Id);
        }

        public void FileChanged(string path, string type)
        {
            string filePath = Path.GetFullPath(path);
            string js = string.Format("window.fileWatch('{0}', '{1}')", Utility.PathNormalized(filePath), type);
            ExecuteJavascript(js);
        }

        private void GetSearchFolder(string message, object callback)
        {
            string folder = new FileInfo(EditorApplication.applicationPath).Directory.FullName;
            folder = Utility.PathNormalized(Utility.PathCombine(folder, "Unity.app", "Contents", "CGIncludes"));
            wrap = new CallbackWrapper(callback);
            wrap.Send(folder);
        }

        private void LoadAllModels(string message, object callback)
        {
            var guids = AssetDatabase.FindAssets("t:Script");

            var filesInSearch = new List<string>();
            foreach (var id in guids)
            {
                var path = Path.GetFullPath(AssetDatabase.GUIDToAssetPath(id));
                filesInSearch.Add(path);
            }

            var files = filesInSearch.Select(f => string.Format("\"{0}\"", Utility.PathNormalized(f)));
            var filesInJson = string.Format("[{0}]", String.Join(",", files.ToArray()));
            wrap = new CallbackWrapper(callback);
            wrap.Send(filesInJson);
        }

        private void LoadModelByPath(string path)
        {
            string js = string.Format(@"window.loadModelByPath('{0}')", Utility.PathNormalized(path));
            this.ExecuteJavascript(js);
        }

        private string ToProjectRelativePath(string path)
        {
            return Utility.PathNormalized(path.ToLower()).Replace(Application.dataPath.ToLower(), "assets");
        }

        private void Ping(string message, object callback)
        {
            if (string.IsNullOrEmpty(message))
            {
                return;
            }

            var assetPath = ToProjectRelativePath(message);
            var obj = AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(assetPath);

            if (obj != null)
            {
                EditorGUIUtility.PingObject(obj);
            }
        }

        private void SyncSolution(string message, object callback)
        {
            FileWatcher.ClearSolution();
            FileWatcher.SyncSolution();
        }

        private void FilterNotExistFiles(string message, object callback)
        {
            var files = message.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            files = files.Where(f => File.Exists(f)).Select(f => string.Format("\"{0}\"", Utility.PathNormalized(f))).ToArray();
            var filesInJson = string.Format("[{0}]", String.Join(",", files.ToArray()));
            wrap = new CallbackWrapper(callback);
            wrap.Send(filesInJson);
        }

        private void GetSupportFilesInProject(string message, object callback)
        {
            var filesInSearch = FileWatcher.ALLOWED_FILES_CACHE;
            if (filesInSearch == null)
            {
                return;
            }

            var files = filesInSearch.Select(f => string.Format("\"{0}\"", Utility.PathNormalized(f)));
            var filesInJson = string.Format("[{0}]", String.Join(",", files.ToArray()));
            wrap = new CallbackWrapper(callback);
            wrap.Send(filesInJson);
        }

        private void ReloadCodeEditor(string message, object callback)
        {
            if (MainWindow.Instance != null)
            {
                MainWindow.Instance.Reload();
            }
        }

        private void RegisterCommands(string message, object callback)
        {
            string json = UCommandController.GetAllCommandsJson();
            string js = string.Format("window.registerCommands({0});", json);
            ExecuteJavascript(js);
        }

        private void RunCommand(string message, object callback)
        {
            if (string.IsNullOrEmpty(message))
            {
                return;
            }

            UCommandController.Run(message);
        }

        public void EditorFocus()
        {
            string js = "window.editorFocus();";
            ExecuteJavascript(js);
        }

        public void SendSearchResult(string result)
        {
            string js = string.Format("window.setSearchResults({0})", result);
            ExecuteJavascript(js);
        }

        public void SetSearchProgress(float progress)
        {
            int percentage = Mathf.FloorToInt(progress * 100);
            string progressJs = string.Format("window.setSearchTextProgress({0})", Mathf.Clamp(percentage, 0, 100));
            ExecuteJavascript(progressJs);
        }

        private void Search(string searchText, string matchCase, string useRegularExpression, object callback)
        {
            bool ignoreCase = matchCase == "false";
            bool useRegex = useRegularExpression == "true";
            FileSearch.Search(searchText, ignoreCase, useRegex, FileWatcher.ALLOWED_FILES_CACHE.ToArray());
        }

        private void GetThemes(string message, object callback)
        {
            var assetsGuid = AssetDatabase.FindAssets("t:TextAsset");
            var jsonFiles = new List<string>();
            foreach (var item in assetsGuid)
            {
                var path = AssetDatabase.GUIDToAssetPath(item);
                if (path.Contains("uCodeEditor")
                    && path.ToLower().EndsWith(".json"))
                {
                    jsonFiles.Add(Path.GetFullPath(path));
                }
            }

            wrap = new CallbackWrapper(callback);
            var files = jsonFiles.Where(f => File.Exists(f)).Select(f => string.Format("\"{0}\"", Utility.PathNormalized(f))).ToArray();
            var json = string.Format("[{0}]", String.Join(",", files.ToArray()));
            wrap.Send(json);
        }
    }
}