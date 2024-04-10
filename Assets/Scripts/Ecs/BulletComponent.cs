using Unity.Entities;
using Unity.Jobs;
using Unity.Mathematics;
using Unity.Transforms;
using UnityEngine;

namespace Survor.ECS.Bullet
{
    public struct Shooting : IComponentData, IEnableableComponent { }
    public enum BulletType
    {
        Normal,
        Explosion,
        Slash
    }

    // Define the BulletComponent
    
    public struct BulletComponent : IComponentData
    {
        public int type; // 0 = normal, 1 = explosion, 2 = slash
        public float speed;
        public float3 direction;

        public float damage;
        public float lifeTime;
        public float deflectCount;
    }


    // for spawner
    public struct BulletPrefabComponent : IComponentData
    {
        // the entity that refer to the bullet prefab from asset (GameObject)
        public Entity prefab;

        // reference to the spawner entity, (where the bullet come from)
        public Entity spawner;

        public float3 SpawnPosition;
        public float NextSpawnTime;
        public float SpawnRate;
    }

    public readonly partial struct BulletAspect : IAspect
    {
        public readonly Entity entity;
        private readonly RefRW<LocalToWorld> _localToWorld;

        private readonly RefRO<BulletComponent> _bullet;
        private readonly RefRO<BulletPrefabComponent> _prefab;

        public readonly Entity bulletPrefab => _prefab.ValueRO.prefab;
        public readonly float speed => _bullet.ValueRO.speed;
        public readonly float3 direction => _bullet.ValueRO.direction;

        public readonly float lifeTime => _bullet.ValueRO.lifeTime;

        public readonly int type => _bullet.ValueRO.type;
        public readonly float damage => _bullet.ValueRO.damage;
    }
}
