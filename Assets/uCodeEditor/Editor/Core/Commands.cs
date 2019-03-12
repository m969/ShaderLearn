using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Diagnostics;

namespace uCodeEditor
{
	#region Core Commands
		
	[UCommand("uce.toggle.maximize.editor", "Toggle uCodeEditor Maximize", KeyCode.Shift | KeyCode.CtrlCmd | KeyCode.US_EQUAL)]
	public class ToggleEditorMaximize : UCommand
	{
		public override void Run()
		{
			if (MainWindow.Instance != null)
			{
				MainWindow.Instance.maximized = !MainWindow.Instance.maximized;
			}
		}
	}

	[UCommand("uce.online.documents", "Help: Online Documents")]
	public class OnlineDocuments : UCommand
	{
		public override void Run()
		{
			EditorApplication.ExecuteMenuItem("Tools/uCodeEditor/Online Documentation");
		}
	}

#if UNITY_EDITOR_WIN
	[UCommand("uce.open.in.shell", "Project: Open In Command Line")]
#else
	[UCommand("uce.open.in.shell", "Project: Open In Terminal")]
#endif
	public class OpenProjectInShell : UCommand
	{
		public override void Run()
		{
			var path = Utility.PathCombine(Application.dataPath, "..");

#if UNITY_EDITOR_WIN
			Process.Start("cmd", string.Format("-k {0}", path));
#else
			Process.Start("open", string.Format("-b com.apple.Terminal {0}", path));
#endif			
		}
	}

	#endregion
}
