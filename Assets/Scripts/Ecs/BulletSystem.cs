// using Survor.ECS.BulletComponents;
using Unity.Burst;
using Unity.Entities;
using Unity.Jobs;
using Unity.Mathematics;
using Unity.Transforms;
using Unity.Physics;
using Unity.Physics.Extensions;
using Unity.Physics.Systems;
// using Unity.Collections;
using UnityEngine;
using Unity.VisualScripting;

namespace Survor.ECS.Bullet
{
    [BurstCompile]
    [UpdateInGroup(typeof(LateSimulationSystemGroup))]
    // [WorldSystemFilter(WorldSystemFilterFlags.Default | WorldSystemFilterFlags.Editor)]
    public partial struct SpawnSystem : ISystem
    {
        [BurstCompile]
        public void OnCreate(ref SystemState state)
        {
            state.RequireForUpdate<BulletPrefabComponent>();
            state.RequireForUpdate<BulletComponent>();
        }

        [BurstCompile]
        public void OnUpdate(ref SystemState state)
        {
            foreach (
                var (generator, localToWorld) in SystemAPI
                    .Query<BulletAspect, RefRO<LocalToWorld>>()
                    .WithAll<Shooting>()
            )
            {
                Entity instance = state.EntityManager.Instantiate(generator.bulletPrefab);

                state.EntityManager.SetComponentData(
                    instance,
                    new LocalTransform
                    {
                        Position = SystemAPI
                            .GetComponent<LocalToWorld>(generator.bulletPrefab)
                            .Position,
                        Rotation = quaternion.identity,
                        Scale = SystemAPI.GetComponent<LocalTransform>(generator.bulletPrefab).Scale
                    }
                );

                state.EntityManager.SetComponentData(
                    instance,
                    new BulletComponent
                    {
                        speed = generator.speed,
                        direction = math.mul(localToWorld.ValueRO.Rotation, generator.direction),
                        lifeTime = generator.lifeTime,
                        type = generator.type,
                        damage = generator.damage

                    }
                );

            }
        }

        // [BurstCompile]
        // public void OnDestroy(ref SystemState state) { }
    }


    // Bullet Movement System
    [BurstCompile]
    [UpdateInGroup(typeof(LateSimulationSystemGroup))]
    // [WorldSystemFilter(WorldSystemFilterFlags.Default | WorldSystemFilterFlags.Editor)]
    public partial struct MovementSystem : ISystem
    {
        [BurstCompile]
        public void OnCreate(ref SystemState state)
        {
            state.RequireForUpdate<BulletComponent>();
            // state.RequireForUpdate<LocalToWorld>();
        }

        [BurstCompile]
        public void OnUpdate(ref SystemState state)
        {
            var ecbSingleton =
                SystemAPI.GetSingleton<EndSimulationEntityCommandBufferSystem.Singleton>();

            var mvJob = new MovementJob
            {
                ECB = ecbSingleton.CreateCommandBuffer(state.WorldUnmanaged),
                DeltaTime = SystemAPI.Time.DeltaTime
            };

            mvJob.Schedule();
        }
    }
     [BurstCompile]
    public partial struct MovementJob : IJobEntity
    {
        public EntityCommandBuffer ECB;
        public float DeltaTime;

        void Execute(Entity entity, ref BulletComponent movement, ref LocalTransform transform)
        {
            transform.Position += movement.direction * movement.speed * DeltaTime;

            // if (movement.speed < 0.1f)
            // {
            //     ECB.DestroyEntity(entity);
            // }
        }
    }

    // Bullet LifeTime System
    [BurstCompile]
    [UpdateInGroup(typeof(LateSimulationSystemGroup))]
    // [WorldSystemFilter(WorldSystemFilterFlags.Default | WorldSystemFilterFlags.Editor)]
    public partial struct LifeTimeSystem : ISystem
    {
        [BurstCompile]
        public void OnCreate(ref SystemState state)
        {
            state.RequireForUpdate<BulletComponent>();
        }

        [BurstCompile]
        public void OnUpdate(ref SystemState state)
        {
            var ecbSingleton =
                SystemAPI.GetSingleton<EndSimulationEntityCommandBufferSystem.Singleton>();

            var ltJob = new LifeTimeJob
            {
                ECB = ecbSingleton.CreateCommandBuffer(state.WorldUnmanaged),
                DeltaTime = SystemAPI.Time.DeltaTime
            };

            ltJob.Schedule();
        }
    }
    [BurstCompile]
    public partial struct LifeTimeJob : IJobEntity
    {
        public EntityCommandBuffer ECB;
        public float DeltaTime;

        void Execute(Entity entity, ref BulletComponent bullet)
        {

            /// if (lifeTime.lifeTime == -1)
            ///    { run until hit something }

            if (bullet.lifeTime > 0){
                bullet.lifeTime -= DeltaTime;
            }

            if (bullet.lifeTime == 0)
            {
                ECB.DestroyEntity(entity);
            }
        }
    }

    // // Bullet Damage System
    // [BurstCompile]
    // [UpdateInGroup(typeof(AfterPhysicsSystemGroup))]
    // // [WorldSystemFilter(WorldSystemFilterFlags.Default | WorldSystemFilterFlags.Editor)]
    // public partial struct DamageSystem : ISystem
    // {
    //     [BurstCompile]
    //     public void OnCreate(ref SystemState state)
    //     {
    //         state.RequireForUpdate<BulletComponent>();
    //         // state.RequireForUpdate<
    //     }

    //     [BurstCompile]
    //     public void OnUpdate(ref SystemState state)
    //     {
    //         var ecbSingleton =
    //             SystemAPI.GetSingleton<SimulationSingleton>();

    //         var dmgJob = new BulletDamageJob
    //         {
    //             ECB = ecbSingleton.CreateCommandBuffer(state.WorldUnmanaged)
    //         };

    //         // dmgJob.Schedule();
    //         state.Dependency = dmgJob.Schedule(ecbSingleton, state.Dependency);
    //     }
    // }
    [BurstCompile]
    public partial struct DamageJob : ITriggerEventsJob
    {
        [BurstCompile]
        public void Execute(TriggerEvent triggerEvent)
        {
            Debug.Log("Bullet hit something");
            var entityA = triggerEvent.EntityA;
            // ECB.DestroyEntity(entity);
        }
    }
}
