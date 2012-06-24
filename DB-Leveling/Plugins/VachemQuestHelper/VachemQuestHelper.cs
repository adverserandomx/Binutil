using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Threading;
using System.Windows;
using System.Windows.Forms;
using System.Xml;
using System.Xml.Linq;
using System.Xml.XPath;
using Zeta;
using Zeta.Common;
using Zeta.CommonBot;
using Zeta.Common.Plugins;
using Zeta.Internals;
using Zeta.Internals.Actors;
using Zeta.Internals.Service;



//Created by: Edited by Newk
//Credit to: eax, No1KnowsY, w3eZle & Mduhb
//Based script on these guys work
//Created Date: 12June2012

namespace Vachem
{
    public class Vacham : IPlugin
    {
        public Version Version { get { return new Version(1, 0); } }
        public string Author { get { return "Newk, based on Mduhb, eax, w3eZle and No1KnowsY's work"; } }
        public string Description { get { return "Enable/Disable KillMonsters for Vachem Quest."; } }
        public string Name { get { return "Vachem Quest Helper " + Version; } }
        public Window DisplayWindow
        {
            get
            {
                return null;
            }
        }

        private void Log(string message)
        {
            Logging.Write(string.Format("[{0}] {1}", Name, message));
        }


        public void OnInitialize()
        {

        }

        public void OnPulse()
        {
            // if we're not in game and not in the process of restarting, do nothing
            if (!ZetaDia.IsInGame || !ZetaDia.Me.IsValid)
            {
                return;
            }
            // When we enter Khasims Outpost, disable KillMonsters
            if (ZetaDia.CurrentQuest.QuestSNO == 93396 && ZetaDia.CurrentQuest.StepId == 46 && ZetaDia.CurrentWorldDynamicId == 1999568897)
            {
                ProfileManager.CurrentProfile.KillMonsters = false;
            }
            // When we enter Command post, disable KillMonsters (not really needed I think)
            if (ZetaDia.CurrentQuest.QuestSNO == 93396 && ZetaDia.CurrentQuest.StepId == 74 && ZetaDia.CurrentWorldDynamicId == 1999634434)
            {
                ProfileManager.CurrentProfile.KillMonsters = false;
            }        
            // When the guards are not yet transformed, enable KillMonsters
            if (ZetaDia.CurrentQuest.QuestSNO == 93396 && ZetaDia.CurrentQuest.StepId == 30 && ConditionParser.ActorExistsAt(81857, 160.7686f, 117.3584f, 0.1000014f, 200) == true)
            {
                ProfileManager.CurrentProfile.KillMonsters = true;
            }
            // When guards transform, enable KillMonsters
            if (ZetaDia.CurrentQuest.QuestSNO == 93396 && ZetaDia.CurrentQuest.StepId == 30 && ConditionParser.ActorExistsAt(60816, 160.7686f, 117.3584f, 0.1000014f, 200) == true)
            {
                ProfileManager.CurrentProfile.KillMonsters = true;
            }
            // When guards are dead, disable KillMonsters
            if (ZetaDia.CurrentQuest.QuestSNO == 93396 && ZetaDia.CurrentQuest.StepId == 30 && ConditionParser.ActorExistsAt(60816, 160.7686f, 117.3584f, 0.1000014f, 200) == false)
            {
                ProfileManager.CurrentProfile.KillMonsters = false;
            }
            // When we get outside Command Post, enable KillMonsters
            if (ZetaDia.CurrentQuest.QuestSNO == 93396 && ZetaDia.CurrentQuest.StepId == 4 && ZetaDia.CurrentWorldDynamicId == 1999568897)
            {
                ProfileManager.CurrentProfile.KillMonsters = true;
            }
			
			// When Quest is done, disable KillMonsters, to avoid trying to kill Civilians
            if (ZetaDia.CurrentQuest.QuestSNO == 93396 && ZetaDia.CurrentQuest.StepId == 48 && ZetaDia.CurrentWorldDynamicId == 1999568897)
            {
                ProfileManager.CurrentProfile.KillMonsters = false;
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
