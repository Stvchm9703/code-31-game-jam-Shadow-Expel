using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;

// using UnityEngine

public class EnemyManager : MonoBehaviour
{
    public GameObject enemyPrefab;
    public int maxiumEnemiesCap;
    public List<GameObject> enemies;

    // minimum and maximum values for the enemy spawn rate
    public float minSpawnRate;
    public float maxSpawnRate;

    public List<Transform> spawnPoints;

    public bool isStopped = false;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine("SpawnEnemy");
    }

    IEnumerator SpawnEnemy()
    {
        while (isStopped == false)
        {
            // if the number of enemies is less than the maximum number of enemies
            if (enemies.Count < maxiumEnemiesCap && maxiumEnemiesCap > 0)
            {
                // create a new enemy
                // set the enemy's position to a random position within the screen

                var spawnPoint = spawnPoints[
                    UnityEngine.Random.Range(0, spawnPoints.Count)
                ].position;
                spawnPoint.x += UnityEngine.Random.Range(-1, 1) * 0.3f;
                spawnPoint.y += UnityEngine.Random.Range(-1, 1) * 0.3f;
                spawnPoint.z += 1f;

                // enemy.transform.parent= this.transform;
                GameObject enemy = Instantiate(
                    enemyPrefab,
                    spawnPoint,
                    quaternion.identity,
                    this.transform
                );

                // add the enemy to the list of enemies
                enemies.Add(enemy);
            }
            yield return new WaitForSeconds(UnityEngine.Random.Range(minSpawnRate, maxSpawnRate));
        }
    }
}
