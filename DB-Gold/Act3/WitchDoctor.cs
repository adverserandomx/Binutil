using System;
using System.Linq;
using Belphegor.Composites;
using Belphegor.Dynamics;
using Belphegor.Helpers;
using Belphegor.Settings;
using Zeta;
using Zeta.Common.Helpers;
using Zeta.CommonBot;
using Zeta.Internals.Actors;
using Zeta.TreeSharp;
using Action = Zeta.TreeSharp.Action;
namespace Belphegor.Routines
{
    public class WitchDoctor
    {

        [Class(ActorClass.WitchDoctor)]
        [Behavior(BehaviorType.Buff)]
        public static Composite WitchDoctorBuff()
        {
            return
            new PrioritySelector(
                Common.CreateWaitForAttack(),
                Spell.Buff(SNOPower.Witchdoctor_Gargantuan, extra => !Unit.HasPet("Gargantuan")),
                Spell.Buff(SNOPower.Witchdoctor_SummonZombieDog, extra => Unit.PetCount("WD_ZombieDog") < 3)
            );
        }

        [Class(ActorClass.WitchDoctor)]
        [Behavior(BehaviorType.Combat)]
        public static Composite WitchDoctorCombat()
        {
            return new PrioritySelector(ctx => CombatTargeting.Instance.FirstNpc,
                new Decorator(ctx => ctx != null,
                    new PrioritySelector(

                    Common.CreateWaitWhileIncapacitated(),
                    Common.CreateWaitForAttack(),
                    Common.CreateUsePotion(),

                    // Make sure we are within range/line of sight of the unit.
					new SelfCast(SNOPower.Witchdoctor_SpiritWalk), // faster run walk when possible
                    Movement.MoveTo(ctx => ((DiaUnit)ctx).Position, 30f),
                    //Movement.MoveToLineOfSight(ctx => (DiaUnit)ctx),

                    new SelfCast(SNOPower.Witchdoctor_SpiritWalk, extra => ZetaDia.Me.HitpointsCurrentPct <= 0.4),
                    new SelfCast(SNOPower.Witchdoctor_Sacrifice, extra => Unit.PetCount("WD_ZombieDog") > 1 && ZetaDia.Me.HitpointsCurrentPct <= BelphegorSettings.Instance.WitchDoctor.SacrificeHp),

					//added to keep faster run walk up and/or vision quest up
					new SelfCast(SNOPower.Witchdoctor_Horrify),
                     //Pets
                    Spell.Buff(SNOPower.Witchdoctor_Gargantuan, extra => !Unit.HasPet("Gargantuan")),
                    Spell.Buff(SNOPower.Witchdoctor_SummonZombieDog, extra => Unit.PetCount("WD_ZombieDog") < 3),
                    new SelfCast(SNOPower.Witchdoctor_Hex),

                    new SelfCast(SNOPower.Witchdoctor_SoulHarvest, 
                        ctx => Clusters.GetClusterCount(ZetaDia.Me, CombatTargeting.Instance.LastObjects, ClusterType.Radius, 16f) >= 2
                            || (Unit.IsElite((DiaUnit)ctx, 16f))),
                    new SelfCast(SNOPower.Witchdoctor_BigBadVoodoo, ctx => nearbycount >= 4 || Unit.IsElite((DiaUnit)ctx)),
                    new SelfCast(SNOPower.Witchdoctor_FetishArmy, ctx => nearbycount >= 4 || Unit.IsElite((DiaUnit)ctx)),
                    new SelfCast(SNOPower.Witchdoctor_Horrify, extra => nearbycount >= 4),
                    new CastOnUnit(SNOPower.Witchdoctor_MassConfusion, ctx => ((DiaUnit)ctx).ACDGuid, extra => nearbycount >= 3),

                    new CastOnUnit(SNOPower.Witchdoctor_GraspOfTheDead, ctx => ((DiaUnit)ctx).ACDGuid),

                    new Decorator(ret => _acidTimer.IsFinished && PowerManager.CanCast(SNOPower.Witchdoctor_AcidCloud),
                        new Sequence(
                            new CastAtLocation(SNOPower.Witchdoctor_AcidCloud, ctx => ((DiaUnit)ctx).Position, 
                                ctx => Clusters.GetClusterCount(((DiaUnit)ctx), CombatTargeting.Instance.LastObjects, ClusterType.Radius, 18f) >= 3),
                            new Action(ret =>_acidTimer.Reset())
                            )),

                    new CastAtLocation(SNOPower.Witchdoctor_Firebats, ctx => ((DiaUnit)ctx).Position, extra => ClusterCount >= 3),
                    new CastAtLocation(SNOPower.Witchdoctor_WallOfZombies, ctx => ((DiaUnit)ctx).Position, extra => ClusterCount >= 3),

                    new Decorator(ctx => _locustSwarmTimer.IsFinished && PowerManager.CanCast(SNOPower.Witchdoctor_Locust_Swarm) && ((DiaUnit)ctx).Distance < 16 &&
                        (Clusters.GetClusterCount((DiaUnit)ctx, CombatTargeting.Instance.LastObjects, ClusterType.Radius, 20) >= 3 || Unit.IsElite((DiaUnit)ctx)),
                        new Sequence(
                            new CastOnUnit(SNOPower.Witchdoctor_Locust_Swarm, ctx => ((DiaUnit)ctx).ACDGuid),
                            new Action(ret => _locustSwarmTimer.Reset())
                            )),

                    new Decorator(ret => _hauntTimer.IsFinished && PowerManager.CanCast(SNOPower.Witchdoctor_Haunt),
                        new Sequence(
                            new CastOnUnit(SNOPower.Witchdoctor_Haunt, ctx => ((DiaUnit)ctx).ACDGuid),
                            new Action(ret => _hauntTimer.Reset())
                            )),



                    //Other spells
                    new CastOnUnit(SNOPower.Witchdoctor_SpiritBarrage, ctx => ((DiaUnit)ctx).ACDGuid),
                    new CastOnUnit(SNOPower.Witchdoctor_ZombieCharger, ctx => ((DiaUnit)ctx).ACDGuid),

                    //Primary
                    new CastAtLocation(SNOPower.Witchdoctor_PlagueOfToads, ctx => ((DiaUnit)ctx).Position),
                    new CastAtLocation(SNOPower.Witchdoctor_CorpseSpider, ctx => ((DiaUnit)ctx).Position),
                    new CastOnUnit(SNOPower.Witchdoctor_Firebomb, ctx => ((DiaUnit)ctx).ACDGuid),
                    new CastOnUnit(SNOPower.Witchdoctor_PoisonDart, ctx => ((DiaUnit)ctx).ACDGuid)
                    )
                   ),

                   new Action(ret => RunStatus.Success)
                   );
        }

        #region timmers
        static WitchDoctor()
        {
            GameEvents.OnGameLeft += OnGameLeft;
            GameEvents.OnPlayerDied += OnGameLeft;
        }

        private static WaitTimer _acidTimer = new WaitTimer(TimeSpan.FromSeconds(5));
        private static WaitTimer _locustSwarmTimer = new WaitTimer(TimeSpan.FromSeconds(6));
        private static WaitTimer _hauntTimer = new WaitTimer(TimeSpan.FromSeconds(10));
        

        static void OnGameLeft(object sender, EventArgs e)
        {
            _acidTimer.Stop();
            _locustSwarmTimer.Stop();
            _hauntTimer.Stop();
        }
        #endregion

        private static int ClusterCount
        {
            get { return Clusters.GetClusterCount(CombatTargeting.Instance.FirstNpc, CombatTargeting.Instance.LastObjects, ClusterType.Radius, 60f); }
        }

        private static int nearbycount { get { return Clusters.GetClusterCount(ZetaDia.Me, CombatTargeting.Instance.LastObjects, ClusterType.Radius, 40f); } }


        public static void WitchDoctorOnLevelUp(object sender, EventArgs e)
        {
            if (ZetaDia.Me.ActorClass != ActorClass.WitchDoctor)
                return;

            int myLevel = ZetaDia.Me.Level;

            Logger.Write("Player leveled up, congrats! Your level is now: {0}",
                myLevel
                );

            // Set Lashing tail kick once we reach level 2
            if (myLevel == 2)
            {
                ZetaDia.Me.SetActiveSkill(SNOPower.Witchdoctor_GraspOfTheDead, -1, 1);
                Logger.Write("Setting Grasp of the Dead as Secondary");
            }

            // Set Dead reach it's better then Fists of thunder imo.
            if (myLevel == 3)
            {
                ZetaDia.Me.SetActiveSkill(SNOPower.Witchdoctor_CorpseSpider, -1, 0);
                Logger.Write("Setting Grasp of the Dead as Secondary");
            }

            // Make sure we set binding flash, useful spell in crowded situations!
            if (myLevel == 4)
            {
                ZetaDia.Me.SetActiveSkill(SNOPower.Witchdoctor_SummonZombieDog, -1, 2);
                Logger.Write("Setting Summon Zombie Dogs as Defensive");
            }

            // Make sure we set Dashing strike, very cool and useful spell great opener.
            if (myLevel == 9)
            {
                ZetaDia.Me.SetActiveSkill(SNOPower.Witchdoctor_SoulHarvest, -1, 3);
                Logger.Write("Setting Sould Harvest as Terror");
            }

            if (myLevel == 10)
            {
                ZetaDia.Me.SetTraits(SNOPower.Witchdoctor_Passive_JungleFortitude);
            }
            if (myLevel == 13)
            {
                ZetaDia.Me.SetTraits(SNOPower.Witchdoctor_Passive_SpiritualAttunement);
            }
        }
    }
}