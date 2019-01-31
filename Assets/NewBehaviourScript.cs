using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Reflection;
using System;


[Serializable]
public class Process
{
    public string Name;
    public string Script;
}


public class NewBehaviourScript : MonoBehaviour {
    public List<Process> Processes;


	// Use this for initialization
	void Start () {
        foreach (var item in Processes)
        {
            if (item.Name == "Start")
            {
                //new System.Reflection.PropertyInfo().
                //Assembly.
                Type objType = null;
                foreach (System.Reflection.Assembly ass in AppDomain.CurrentDomain.GetAssemblies())
                {
                    objType = ass.GetType("UnityEngine.Transform");
                    if (objType != null)
                        break;
                }
                var setMethod = objType.GetMethod("set_position");
                Type pType = null;
                foreach (System.Reflection.Assembly ass in AppDomain.CurrentDomain.GetAssemblies())
                {
                    pType = ass.GetType("UnityEngine.Vector3");
                    if (pType != null)
                        break;
                }
                setMethod.Invoke(transform, new object[] { Activator.CreateInstance(pType, new object[] { float.Parse("1"), float.Parse("1"), float.Parse("1") }) });
                continue;
            }
        }
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
