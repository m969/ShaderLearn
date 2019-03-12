//  Copyright (c) 2018-present amlovey
//  
using UnityEngine;
using UnityEditor;
using System;
using UnityEditor.Callbacks;
using System.Linq;

namespace uCodeEditor
{
    public class MainWindow : EditorWindow
    {
        private Webview webview;
        private const string Title = "uCodeEditor";

        public static WebviewComService CommunicateServices;
        public static MainWindow Instance;

        [UnityEditor.MenuItem("Tools/uCodeEditor/Online Documentation", false, 33)]
        public static void OpenOnlineDocumentation()
        {
            Application.OpenURL("http://www.amlovey.com/uce/index/");
        }

        [UnityEditor.MenuItem("Tools/uCodeEditor/Open An Issue", false, 33)]
        public static void OpenIssue()
        {
            Application.OpenURL("https://github.com/amloveyweb/amloveyweb.github.io/issues");
        }

        [UnityEditor.MenuItem("Tools/uCodeEditor/uCodeEditor %#e", false, 11)]
        private static void OpenEditorWindowFromMenu()
        {
            PlayerPrefs.DeleteKey(Constants.CURRENT_FILE_KEY);
            LoadWindow();
        }

        public static void LoadWindow()
        {
            if (Instance == null)
            {
                Type[] desiredDockNextTo = new Type[] { typeof(SceneView) };
                Instance = EditorWindow.GetWindow<MainWindow>(Title, desiredDockNextTo);
            }

            Instance.Show();
            Instance.Focus();
        }

        public void InitWebView(Rect webviewRect)
        {
            if (webview == null)
            {
                this.webview = ScriptableObject.CreateInstance<Webview>();
                this.webview.hideFlags = HideFlags.HideAndDontSave;
            }

            this.webview.InitWebView(Webview.GetView(this), webviewRect, false);
            var path = string.Format(@"file://{0}/uCodeEditor/Editor/index.html", Application.dataPath);

#if uCE_DEV
            this.webview.AllowRightClickMenu(true);
#endif
            this.webview.LoadURL(path);
            SetFocus(true);
            InitWebviewComService();
        }

        public void Reload()
        {
            PlayerPrefs.DeleteKey(Constants.CURRENT_FILE_KEY);
            var path = string.Format(@"file://{0}/uCodeEditor/Editor/index.html", Application.dataPath);
            this.webview.LoadURL(path);
        }

        public void InitWebviewComService()
        {
            if (CommunicateServices == null)
            {
                CommunicateServices = ScriptableObject.CreateInstance<WebviewComService>();
            }

            CommunicateServices.Init(this.webview);
        }

        public void OnBecameInvisible()
        {
            if (this.webview != null)
            {
                this.webview.SetHostView(null);
                this.webview.Hide();
                this.webview.SetFocus(false);
            }
        }

        void OnDestroy()
        {
            PlayerPrefs.DeleteKey(Constants.CURRENT_FILE_KEY);
        }

        public void OnLostFocus()
        {
            this.SetFocus(false);
        }

        public void OnFocus()
        {
            SetFocus(true);
            Instance = this;
            InitWebviewComService();
        }

        public void OnEnable()
        {
            Instance = this;
            InitWebviewComService();
        }

        private int repeatedShow;
        private bool syncingFocus;
        private void SetFocus(bool value)
        {
            if (!this.syncingFocus)
            {
                this.syncingFocus = true;
                if (this.webview != null)
                {
                    if (value)
                    {
                        this.webview.SetHostView(Webview.GetView(this));
                        this.webview.Show();
                        this.repeatedShow = 5;
                    }

                    this.webview.SetFocus(value);
                }
                this.syncingFocus = false;
            }
        }

        public void Refresh()
        {
            this.webview.Hide();
            this.webview.Show();
        }

        void OnGUI()
        {
            Rect webViewRect = GUIClip.Unclip(new Rect(0f, 0, base.position.width, base.position.height));

            if (this.webview == null)
            {
                this.InitWebView(webViewRect);
            }

            if (MainWindow.CommunicateServices == null)
            {
                InitWebviewComService();
            }

            if (this.repeatedShow-- > 0)
            {
                this.Refresh();
            }

            if (Event.current.type == EventType.Repaint && webview != null)
            {
                this.webview.SetSizeAndPosition(webViewRect);
            }
        }
    }

}