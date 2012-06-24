using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Windows;
using Zeta;
using Zeta.Common;
using Zeta.Common.Plugins;
using Zeta.CommonBot;
using Zeta.Internals;
using Zeta.Internals.Actors;
using Zeta.Internals.Service;

namespace XPCounter
{
    public class XPCounter : IPlugin
    {
        #region Iplugin
        public bool Equals(IPlugin other)
        {
            // we should probably be comparing versions too
            return other.Name == Name;
        }

        public string Author
        {
            get { return "Inrego"; }
        }

        public string Description
        {
            get { return "Shows gained exp/h"; }
        }

        public string Name
        {
            get { return "XP Counter 1.1"; }
        }

        public Version Version
        {
            get { return new Version(1, 1); }
        }

        public Window DisplayWindow
        {
            get
            {
                PrintExpHr();
                Logging.Write("Resetting xp/hp");
                timer.Restart();
                gainedXp = 0;
                levelXp = ZetaDia.Me.ExperienceNextLevel;
                return null;
            }
        }

        /// <summary> Executes the shutdown action. This is called when the bot is shutting down. (Not when Stop() is called) </summary>
        public void OnShutdown()
        {
            timer.Stop();
        }

        /// <summary> Executes the enabled action. This is called when the user has enabled this specific plugin via the GUI. </summary>
        public void OnEnabled()
        {
            Logging.Write("XP Counter enabled");
        }

        /// <summary> Executes the disabled action. This is called whent he user has disabled this specific plugin via the GUI. </summary>
        public void OnDisabled()
        {
            Logging.Write("Stopping counter");
            timer.Stop();
        }

        #endregion

        private int currentLevel;
        private double gainedXp = 0;
        private int levelXp;
        private bool _init;
        private Stopwatch timer = new Stopwatch();

        public void OnInitialize()
        {
            
        }

        public void OnPulse()
        {
            if (!_init)
            {
                GameEvents.OnGameLeft += new EventHandler<EventArgs>(OnGameLeft);
                currentLevel = ZetaDia.Me.Level;
                levelXp = ZetaDia.Me.ExperienceNextLevel;
                Logging.Write("Starting counter");
                timer.Start();
                _init = true;
            }
            CheckExp();
        }

        public void CheckExp()
        {
            if (ZetaDia.Me.Level != currentLevel)
            {
                gainedXp += levelXp;
                levelXp = ZetaDia.Me.ExperienceNextLevel;
                currentLevel = ZetaDia.Me.Level;
            }
        }

        public void PrintExpHr()
        {
            TimeSpan elapsed = TimeSpan.FromMilliseconds(timer.ElapsedMilliseconds);
            double secs = elapsed.TotalSeconds;
            double exp = gainedXp + (levelXp - ZetaDia.Me.ExperienceNextLevel);
            double exphr = (exp/secs) * 60 * 60;
            Logging.Write("Gained {0} exp", KSeperator(exp));
            Logging.Write("Exp/Hr: {0}", KSeperator(exphr));
            Logging.Write(FormatTime("Have been calculating exp/hr for ", elapsed));
            Logging.Write(FormatTime("You will gain your next level in ", TimeToLvl(exphr)));
        }

        public string KSeperator(double input)
        {
            var wholeNum = Math.Round(input);
            return String.Format("{0:n0}", wholeNum);
        }

        public TimeSpan TimeToLvl(double expHr)
        {
            if (expHr > 0)
            {
                return TimeSpan.FromHours(ZetaDia.Me.ExperienceNextLevel / expHr);
            }
            else
            {
                return TimeSpan.Zero;
            }
        }

        public string FormatTime(string startText, TimeSpan time)
        {
            StringBuilder timeShow = new StringBuilder(startText);
            if (time.Days > 0)
                timeShow.Append(String.Format("{0}d ", time.Days));
            if (time.Hours > 0)
                timeShow.Append(String.Format("{0}h ", time.Hours));
            if (time.Minutes > 0)
                timeShow.Append(String.Format("{0}m ", time.Minutes));
            timeShow.Append(String.Format("{0}s.", time.Seconds));
            return timeShow.ToString();
        }

        public void OnGameLeft(object sender, EventArgs e)
        {
            PrintExpHr();
        }
    }
}
