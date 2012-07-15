using System;
using System.Collections.Generic;
using System.Threading;
using System.Windows;
using Zeta;
using Zeta.Common;
using Zeta.CommonBot;
using Zeta.CommonBot.Settings;
using Zeta.Common.Plugins;
using Zeta.Internals;
using Zeta.Internals.Actors;
using Zeta.Internals.Service;

namespace Eax.Plugins
{
    public class Unstucker : IPlugin
    {        
        // Maximum amount of times Unstucker should try to unstuck via movement before leaving the game.
        private const int MaximumMoveAttempts = 5;

        // Time Unstucker will wait in seconds between evaluating the logged positions. Decrease this if you find your character and Unstucker doing nothing a lot.
        private const int CheckInterval = 10;

        // Minimum distance the character must be moving every CheckInterval for it to not be considered stuck.
        private const int MinimumMoveDistance = 10;

        // Time Unstucker will wait in seconds before logging positions. I recommend you keep this at 1.
        private const int LogInterval = 1;

        // 'true' if you want Unstucker to teleport to town before leaving the game; 'false' otherwise.
        private const bool TeleportToTown = false;

        private string ProfileName { get; set; }
        private DateTime LastCheckTime { get; set; }
        private DateTime LastLogTime { get; set; }
        private List<Vector3> LoggedPositions { get; set; }
        private Random Random { get; set; }

        public string Author { get { return "eax"; } }
        public string Description { get { return "Unstucks you."; } }
        public string Name { get { return "Unstucker v" + Version.ToString(); } }
        public Version Version { get { return new Version(2, 1, 1); } }
        public Window DisplayWindow { get { return null; } }

        private void Log(string message)
        {
            Logging.Write(string.Format("[{0}] {1}", Name, message));
        }

        private static float GetMaxDistanceTraveled(List<Vector3> positions)
        {
            float max = 0F;
            for (int i = 0; i < positions.Count - 1; ++i)
                for (int j = 1; j < positions.Count; ++j)
                    max = Math.Max(max, Math.Abs(positions[i].Distance(positions[j])));
            return max;
        }

        public void OnBotStart(IBot bot)
        {
            ProfileName = GlobalSettings.Instance.LastProfile;
            LastCheckTime = DateTime.Now;
            Log("Using profile: " + ProfileName);
        }

        public void OnInitialize()
        {
            ProfileName = string.Empty;
            LastCheckTime = DateTime.Now;
            LastLogTime = DateTime.MinValue;
            LoggedPositions = new List<Vector3>();
            Random = new Random();
            BotMain.OnStart += OnBotStart;
        }

        public void OnPulse()
        {
            if (!ZetaDia.IsInGame || !ZetaDia.Me.IsValid || (ZetaDia.Me.CommonData.AnimationState == AnimationState.Casting))
            {
            //    Log("We're not in game or we're identifying rares!");
                LastCheckTime = DateTime.Now;
                LastLogTime = DateTime.Now;
                LoggedPositions.Clear();
                return;
            }

            if (DateTime.Now.Subtract(LastLogTime).TotalSeconds > LogInterval)
            {
            //    Log("Logging a position...");
                LastLogTime = DateTime.Now;
                LoggedPositions.Add(ZetaDia.Actors.Me.Position);
            }
            
            if (DateTime.Now.Subtract(LastCheckTime).TotalSeconds > CheckInterval)
            {
            //    Log("Checking positions...");
                LastCheckTime = DateTime.Now;
                if (GetMaxDistanceTraveled(LoggedPositions) < MinimumMoveDistance)
                {
                    Log("Your character appears to be stuck.");

                    LoggedPositions.Clear();
                    LoggedPositions.Add(ZetaDia.Me.Position);
                    for (int i = 0; i < MaximumMoveAttempts; ++i)
                    {
                        var position = LoggedPositions[0];
                        position.X = (DateTime.Now.Millisecond % 2 == 0) ? position.X + Random.Next(500, 6500) : position.X - Random.Next(500, 6500); 
                        position.Y = (DateTime.Now.Millisecond % 2 == 0) ? position.Y + Random.Next(500, 6500) : position.Y - Random.Next(500, 6500); 
                        position.Z = (DateTime.Now.Millisecond % 2 == 0) ? position.Z + Random.Next(500, 6500) : position.Z - Random.Next(500, 6500); 
                        Log("Moving character to " + position.ToString()); 
                        ZetaDia.Me.UsePower(SNOPower.Walk, position, ZetaDia.Me.WorldDynamicId, 2, -1);    
                        Thread.Sleep(4000);
                        LoggedPositions.Add(ZetaDia.Me.Position);
                        if (GetMaxDistanceTraveled(LoggedPositions) >= MinimumMoveDistance)
                        {
                            Log("Successfully unstucked the character by moving.");
                            LoggedPositions.Clear();
                            return;
                        }
                    }

                    Log("Attempting to unstuck by restarting the game.");

                    if (TeleportToTown)
                    {
                        Log("Teleporting to town...");
                        while (!ZetaDia.Actors.Me.IsInTown)
                        {
                            BotMain.PauseFor(System.TimeSpan.FromSeconds(6));
                            ZetaDia.Actors.Me.UseTownPortal();
                            Thread.Sleep(6000);
                        }
                    }

                    Log("Leaving game...");
                    ZetaDia.Service.Games.LeaveGame();
                    while (ZetaDia.IsInGame)
                    {
                        BotMain.PauseFor(System.TimeSpan.FromSeconds(2));
                        Thread.Sleep(2000);
                    }

                    Log(string.Format("Restarting profile '{0}'", ProfileName));
                    BotMain.PauseFor(System.TimeSpan.FromSeconds(4));
                    Zeta.CommonBot.ProfileManager.Load(ProfileName);
                }
                LoggedPositions.Clear();
            }
        }

        public void OnShutdown()
        {
        }

        public void OnEnabled()
        {
            Log("Enabled.");
        }

        public void OnDisabled()
        {
            Log("Disabled.");
        }
        
        public bool Equals(IPlugin other)
        {
            return (other.Name == Name) && (other.Version == Version);
        }
    }
}
