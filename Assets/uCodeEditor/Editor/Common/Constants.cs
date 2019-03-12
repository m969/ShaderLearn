//  Copyright (c) 2018-present amlovey
//  
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace uCodeEditor
{
    public class Constants
    {
        public const string CURRENT_FILE_KEY = "ue_current_file_path_key";

        /// <summary>
        /// File extension of the files support by uCodeEditor
        /// </summary>
        public static string[] ALLOWED_FILE_EXTENSIONS = new string[] {
          ".cs", ".js", ".jsx", ".json", ".shader", ".cginc", ".cg", ".glsl", ".hlsl", ".compute",
          ".html", ".htm", ".shtml", ".xhtml", ".mdoc", ".jsp", ".asp", ".aspx", ".jshtm", ".xml",
          ".dtd", ".ascx", ".csproj", ".config", ".wxi", ".sln", ".wxl", ".wxs", ".xaml", ".svg",
          ".svgz", ".c", ".h", ".cpp", ".cc", ".cxx", ".hpp", ".hh", ".hxx", ".java", ".jav", ".m",
          ".mm", ".py", ".rpy", ".pyw", ".cpy", ".gyp", ".gypi", ".css", ".swift", ".txt", ".rsp",
          ".lua", ".css", ".scss", ".md", ".markdown"
        };
    }
}
