using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LoseCon : MonoBehaviour
{
    // Start is called before the first frame update
    SpriteRenderer rend;
    void Start()
    {
        rend = this.gameObject.GetComponent<SpriteRenderer> ();
        rend.enabled = false;
    }

    void Update()
    {
       if (Input.GetKeyDown (KeyCode.Alpha1))
       {
            rend.enabled = true;
       }

       else if (Input.GetKeyDown (KeyCode.Alpha2))
       {
            rend.enabled = true;
       }

       else if (Input.GetKeyDown (KeyCode.Alpha4))
       {
            rend.enabled = true;
       }

       else if (Input.GetKeyDown (KeyCode.Alpha5))
       {
            rend.enabled = true;
       }
    }
}
