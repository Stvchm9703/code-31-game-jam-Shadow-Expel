using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;

public class Mon004EnemyBehaviour : IEnemyBehaviour
{
    private void Start()
    {
        onStart();
    }

    private void Update()
    {
      onUpdate();
    }

}
