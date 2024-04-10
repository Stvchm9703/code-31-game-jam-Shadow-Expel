using Unity.Entities;
using Unity.Jobs;
using Unity.Mathematics;
using Unity.Transforms;
using Unity.VisualScripting;
using UnityEngine;

namespace Survor.ECS.Bullet
{
    public class BulletGeneratorMono : MonoBehaviour
    {
        public GameObject normalBulletPrefab;
        public GameObject explosionBulletPrefab;
        public GameObject slashBulletPrefab;

        public Transform bulletSpawner;

        public float bulletSpeed = 20f;
        public float3 bulletDirection = new float3(0, 0, 1);
        public float bulletDamage = 10f;
        public float bulletLifeTime = 3f;

        public BulletType bulletType;

        public void Shoot()
        {
            var entity = World.DefaultGameObjectInjectionWorld.EntityManager.CreateEntity();
            World.DefaultGameObjectInjectionWorld.EntityManager.AddComponentData(entity, new BulletComponent
            {
                speed = bulletSpeed,
                direction = bulletDirection,
                damage = bulletDamage,
                lifeTime = bulletLifeTime,
                type = (int)bulletType
            });
            World.DefaultGameObjectInjectionWorld.EntityManager.AddComponentData(entity, new BulletPrefabComponent
            {
                prefab = World.DefaultGameObjectInjectionWorld.EntityManager.CreateEntity(),
                spawner = World.DefaultGameObjectInjectionWorld.EntityManager.CreateEntity()
            });
        }
    }

    public class BulletGeneratorBaker : Baker<BulletGeneratorMono>
    {
        public override void Bake(BulletGeneratorMono authoring)
        {
            var entity = GetEntity(TransformUsageFlags.Dynamic);
            var targetPrefab = authoring.normalBulletPrefab;
            int type = 0;
            if (authoring.bulletType == BulletType.Explosion)
            {
                targetPrefab = authoring.explosionBulletPrefab;
                type = 1;
            }
            else if (authoring.bulletType == BulletType.Slash)
            {
                targetPrefab = authoring.slashBulletPrefab;
                type = 2;
            }
            AddComponent<BulletPrefabComponent>(
                entity,
                new BulletPrefabComponent
                {
                    prefab = GetEntity(targetPrefab, TransformUsageFlags.Dynamic),
                    spawner = GetEntity(authoring.bulletSpawner, TransformUsageFlags.Dynamic)
                }
            );

            AddComponent<BulletComponent>(
                entity,
                new BulletComponent
                {
                    speed = authoring.bulletSpeed,
                    direction = authoring.bulletSpawner.forward,
                    type = type,
                    damage = authoring.bulletDamage,
                    lifeTime = authoring.bulletLifeTime
                }
            );
        }
    }
}
