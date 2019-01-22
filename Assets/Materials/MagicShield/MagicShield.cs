using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;


//[ExecuteInEditMode]
public class MagicShield : MonoBehaviour {
    public Material shieldMaterial;
    public int pointsCount = 20;
    public float pointRange = 0.5f;
    public float inTime = 0.5f;
    public float outTime = 0.5f;
    public Ease ease;
    public List<HitPoint> hitPoints = new List<HitPoint>();
    public List<Vector4> vecArray = new List<Vector4>();


    // Use this for initialization
    void Start () {
        for (int i = 0; i < pointsCount; i++)
        {
            hitPoints.Add(new HitPoint());
            vecArray.Add(Vector4.zero);
        }
        //DOTween.defaultEaseType = ease;
    }

    // Update is called once per frame
    void Update () {
        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit raycastHit;
            if (Physics.Raycast(ray, out raycastHit, 100))
            {
                var index = -1;
                foreach (var item in hitPoints)
                {
                    if (item.complete)
                    {
                        index = hitPoints.IndexOf(item);
                        break;
                    }
                }
                if (index >= 0)
                {
                    var hitPoint = new HitPoint();
                    hitPoint.complete = false;
                    hitPoint.position = new Vector4(raycastHit.point.x, raycastHit.point.y, raycastHit.point.z, 0);
                    hitPoints[index] = hitPoint;
                    DOTween.To(() => hitPoint.range, x => hitPoint.range = x, pointRange, inTime).OnComplete(() => { DOTween.To(() => hitPoint.range, x => hitPoint.range = x, 0f, outTime).OnComplete(() => { hitPoint.complete = true; }).SetEase(ease); }).SetEase(ease);
                }
            }
        }
        //var rmList = new List<HitPoint>();
        foreach (var item in hitPoints)
        {
            var p = item.position;
            item.position = new Vector4(p.x, p.y, p.z, item.range);
            //shieldMaterial.SetVector("_Point" + hitPoints.IndexOf(item), item.position);
            vecArray[hitPoints.IndexOf(item)] = item.position;
            //if (item.complete)
            //    rmList.Add(item);
        }
        //Debug.Log(vecArray.Count);
        //Shader.SetGlobalVectorArray("MyGlobalArray", vecArray);
        shieldMaterial.SetVectorArray("_Array", vecArray);
        //foreach (var item in rmList)
        //{
        //    hitPoints.Remove(item);
        //}
        //if (hitPoint != null)
        //{
        //    shieldMaterial.SetVector("_Point", hitPoint.position);// new Vector4(pointTrans.position.x, pointTrans.position.y, pointTrans.position.z, 0));
        //}
    }
}

public class HitPoint
{
    public Vector4 position = Vector4.zero;
    public float time = 0;
    public float range = 0.1f;
    public bool complete = true;
}