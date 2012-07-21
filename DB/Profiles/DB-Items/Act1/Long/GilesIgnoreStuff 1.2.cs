using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using Zeta;
using Zeta.Common;
using Zeta.Common.Plugins;
using Zeta.CommonBot;
using Zeta.Internals.Actors;
using Zeta.TreeSharp;

namespace GilesIgnoreStuff
{
    public class GilesLootTargetingProvider : ITargetingProvider
    {

        private ITargetingProvider source;

        public GilesLootTargetingProvider(ITargetingProvider source)
        {
            this.source = source;
        }

        private void Log(string message)
        {
            Logging.Write(string.Format("[{0}] {1}", "GilesLootTargetingProvider", message));
        }

        public List<DiaObject> GetObjectsByWeight()
        {
            List<DiaObject> dbDefaultList = source.GetObjectsByWeight();

            if (dbDefaultList != null)
            {
                dbDefaultList.RemoveAll(RemoveThisItem);
            }

            return dbDefaultList;
        }

        private bool RemoveThisItem(DiaObject thisobject)
        {
            bool bRemoveThis = false;
            bool bLogThis = true;
            string thisname = thisobject.Name;
            if (thisname.StartsWith("Gold") && thisobject is DiaItem) {
                var thisitem = (DiaItem)thisobject;
                if (thisitem.CommonData.ItemStackQuantity < 300)
                {
                    bRemoveThis = true;
                }
                bLogThis = false;
           }
            if (thisname.StartsWith("LootType2_", true, null) ||
                thisname.StartsWith("LootType3_", true, null) ||
                thisname.StartsWith("Blacksmith_Apprentice_Corpse", true, null) ||
                thisname.StartsWith("Shrine_Global_Enlightened", true, null) ||
                thisname.StartsWith("trOut_", true, null) ||
                thisname.StartsWith("Goatman_Tree_Knot", true, null) ||
                thisname.StartsWith("a1dun_Cath_chest", true, null))
            {
                bRemoveThis = true;
                bLogThis = false;
            }
            //if (bLogThis) Log(thisname);
            return bRemoveThis;
        }
        
    }



    public class GilesIgnoreStuff : IPlugin
    {
        public Version Version { get { return new Version(1, 0); } }
        public string Author { get { return "GilesSmith"; } }
        public string Description { get { return "GilesIgnoreStuff will ignore certain things like chests or corpses"; } }
        public string Name { get { return "GilesIgnoreStuff " + Version; } }
        public Window DisplayWindow { get { return null; } }
        public bool Equals(IPlugin other) { return (other.Name == Name) && (other.Version == Version); }

        private void Log(string message)
        {
            Logging.Write(string.Format("[{0}] {1}", Name, message));
        }

        public void OnInitialize()
        {
            // Replace default TargetingProvider with my version
            Zeta.CommonBot.ITargetingProvider newTargetingProvider = new GilesLootTargetingProvider(LootTargeting.Instance.Provider);
            LootTargeting.Instance.Provider = newTargetingProvider;
        }

        public void OnPulse()
        {
        }

        public void OnEnabled()
        {
        }

        public void OnDisabled()
        {
        }

        public void OnShutdown()
        {
        }
    }

}
