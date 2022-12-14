using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class ShaderCimplement : MonoBehaviour
{
    public Material Shader;
    private float sum;
    private float sum2;

    private void Start()
    {
        sum = 1.0f;
        sum2 = 0f;
    }

    private void Update()
    {
        if (Input.GetKey(KeyCode.D))
        {
            Debug.Log("help");
            Shader.SetFloat("_Cloaking",sum);
            sum += .5f * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.A))
        {
            Debug.Log("help");
            Shader.SetFloat("_Cloaking",sum);
            sum -= .5f * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.W))
        {
            Debug.Log("help");
            Shader.SetFloat("_Refraction_Intensity",sum2);
            sum2 += .5f * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.S))
        {
            Debug.Log("help");
            Shader.SetFloat("_Refraction_Intensity",sum2);
            sum2 -= .5f * Time.deltaTime;
        }
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Debug.Log("help");
            if (Shader.GetInt("_RimLight_Toggle") == 1)
            {
                Shader.SetInt("_RimLight_Toggle",0);
            }
            else
            {
                Shader.SetInt("_RimLight_Toggle",1);
            }
        }
    }
}
