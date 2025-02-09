using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WinCon : MonoBehaviour
{
    SpriteRenderer rend;
    void Start()
    {
        rend = this.gameObject.GetComponent<SpriteRenderer> ();
        rend.enabled = false;
    }

    void Update()
    {
       if (Input.GetKeyDown (KeyCode.Alpha3))
       {
            rend.enabled = true;
       }
    }
}
