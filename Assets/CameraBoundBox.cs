using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraBoundBox : MonoBehaviour
{
    public Transform GroundMap;
    // Start is called before the first frame update
    
    
    /**
     *
     * function createCameraBoundaryFromGround(groundData) {
            const scale = new Vector3(groundData.scale.x * 2, 1.5, groundData.scale.z * 2);
            const position = new Vector3(groundData.position.x, 4, groundData.position.z);
            return new CameraBoundary(scale, position);
        }

     */
    void Start()
    {
        if (this.GroundMap != null)
        {
            this.transform.localScale = new Vector3(
                GroundMap.localScale.x * 10 - 6,
                1.5f,
                GroundMap.localScale.z * 10
            );
            
            this.transform.position = new Vector3(
                GroundMap.position.x,
                GroundMap.position.y + 8,
                GroundMap.position.z - 4
            );
        }
       
    }

   
}
