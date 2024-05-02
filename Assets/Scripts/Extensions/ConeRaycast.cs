using System.Collections.Generic;
// using UnityEngine;

namespace UnityEngine
{
    public static class PhysicsExtendions
    {
        public static RaycastHit[] ConeCastAll(Vector3 origin, float radius, Vector3 direction, float maxDistance, float coneAngle)
        {
            RaycastHit[] sphereCastHits = Physics.SphereCastAll(origin, radius, direction, maxDistance);
            List<RaycastHit> coneCastHitList = new List<RaycastHit>();

            if (sphereCastHits.Length > 0)
            {
                for (int i = 0; i < sphereCastHits.Length; i++)
                {
                    sphereCastHits[i].collider.gameObject.GetComponent<Renderer>().material.color = new Color(1f, 1f, 1f);
                    Vector3 hitPoint = sphereCastHits[i].point;
                    Vector3 directionToHit = hitPoint - origin;
                    float angleToHit = Vector3.Angle(direction, directionToHit);

                    if (angleToHit < coneAngle)
                    {
                        coneCastHitList.Add(sphereCastHits[i]);
                    }
                }
            }
            return coneCastHitList.ToArray();
        }
        
        public static RaycastHit[] ConeCastAll(Ray ray, float radius, float maxDistance, float coneAngle, int layerMask)
        {
            RaycastHit[] sphereCastHits = Physics.SphereCastAll(ray, radius, maxDistance, layerMask);
            List<RaycastHit> coneCastHitList = new List<RaycastHit>();

            if (sphereCastHits.Length > 0)
            {
                for (int i = 0; i < sphereCastHits.Length; i++)
                {
                    // sphereCastHits[i].collider.gameObject.GetComponent<Renderer>().material.color = new Color(1f, 1f, 1f);
                    Vector3 hitPoint = sphereCastHits[i].point;
                    Vector3 directionToHit = hitPoint - ray.origin;
                    float angleToHit = Vector3.Angle(ray.direction, directionToHit);

                    if (angleToHit < coneAngle)
                    {
                        coneCastHitList.Add(sphereCastHits[i]);
                    }
                }
            }
            return coneCastHitList.ToArray();
        }
        
    }
}