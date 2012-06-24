using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Threading;

using Zeta;
using Zeta.Common;
using Zeta.TreeSharp;
using Zeta.Common.Plugins;
using Zeta.Internals.Actors;
using Zeta.CommonBot.Profile;
using Zeta.CommonBot.Profile.Common;
using Zeta.CommonBot;
using Zeta.XmlEngine;
using Action = Zeta.TreeSharp.Action;
using Zeta.CommonBot.Settings;
using Zeta.Internals.Actors;
using Zeta.Internals.SNO;

namespace TestInv
{    
    public class TestInv : IPlugin 
    {
        WaitHandle flagStop = new AutoResetEvent(true);
        Thread checkthread;

        void LogDiags(string message)
        {
            Logging.WriteDiagnostic(string.Format("[{0}] {1}", Name+Version.Major+"."+Version.Minor, message));
        }

        void Log(string message)
        {
            Logging.Write(string.Format("[{0}] {1}", Name + Version.Major + "." + Version.Minor, message));
        }

        void CheckNotificationUI()
        {
            Log("Start CheckNotificationUI thread");            

            do
            {
                try
                {
                    LogDiags("Check for Notification UI");
                    LogDiags(String.Format("Bot Thread = {0}, IsRunning = {1}, IsInGame = {2}",Zeta.CommonBot.BotMain.BotThread.IsAlive,Zeta.CommonBot.BotMain.IsRunning,ZetaDia.IsInGame));

                    Zeta.Internals.UIElement ui = null;
                    
                    if (Zeta.Internals.UIElement.IsValidElement(0x4CC93A73A58BAFFF) && (ui = Zeta.Internals.UIElement.FromHash(0x4CC93A73A58BAFFF))!= null)
                    {                        
                        if (ui.IsVisible)
                        {
                            Log(String.Format("Detect UI = {0}, Visible = {1}", ui.Name, ui.IsVisible));

                            Zeta.Internals.UIElement Button = null;

                            if (Zeta.Internals.UIElement.IsValidElement(0xB4433DA3F648A992) && (Button =Zeta.Internals.UIElement.FromHash(0xB4433DA3F648A992))!= null)
                            {                                
                                if (Button.IsVisible)
                                {
                                    Log("Notification OK clicked");
                                    Button.Click();

                                    // Case for click OK when Disconnect popups in Start/Resume menu
                                    if (Zeta.Internals.UIElement.IsValidElement(0x51A3923949DC80B7) && (Button = Zeta.Internals.UIElement.FromHash(0x51A3923949DC80B7)) != null)
                                    {
                                        if (Button.IsVisible && Button.IsEnabled)
                                        {
                                            Log("Resume/Start Button clicked");
                                            Button.Click();
                                        }
                                    }
                            
                                }                                
                            }
                        }
                    }
                    else if (Zeta.Internals.UIElement.IsValidElement(0x7355E17C5FE4B253) && (ui = Zeta.Internals.UIElement.FromHash(0x7355E17C5FE4B253)) != null)
                    {
                        // Party notification
                        if (ui.IsVisible)
                        {
                            Log(String.Format("Detect UI = {0}, Visible = {1}", ui.Name, ui.IsVisible));
                            Zeta.Internals.UIElement Button = null;

                            if (Zeta.Internals.UIElement.IsValidElement(0xB4433DA3F648A992) && (Button = Zeta.Internals.UIElement.FromHash(0xB4433DA3F648A992)) != null)
                            {
                                if (Button.IsVisible)
                                {
                                    Log("Party Notification click");
                                    Button.Click();
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {                    
                	LogDiags(ex.Message);
                    LogDiags(ex.StackTrace);
                }
            } while (Zeta.CommonBot.BotMain.BotThread.IsAlive && !flagStop.WaitOne(10000, false));

            if (!Zeta.CommonBot.BotMain.BotThread.IsAlive)
            {
                LogDiags("Bot thread is ended!!!");
            }

            Log("Stop CheckNotificationUI thread");
        }

        public void OnDisabled()
        {            
            Log("Disabled");
            System.IO.File.WriteAllText("notificationokclick.cfg", "0");
            ((AutoResetEvent)flagStop).Set();

            Zeta.CommonBot.BotMain.OnStart -= new Zeta.CommonBot.BotEvent(BotMain_OnStart);
            Zeta.CommonBot.BotMain.OnStop -= new Zeta.CommonBot.BotEvent(BotMain_OnStop);  
        }
        public void OnEnabled()
        {            
            Log("Enabled");
            System.IO.File.WriteAllText("notificationokclick.cfg", "1");
            ((AutoResetEvent)flagStop).Reset();

            Zeta.CommonBot.BotMain.OnStart += new Zeta.CommonBot.BotEvent(BotMain_OnStart);
            Zeta.CommonBot.BotMain.OnStop += new Zeta.CommonBot.BotEvent(BotMain_OnStop);

            if (Zeta.CommonBot.BotMain.IsRunning)
            {
                ((AutoResetEvent)flagStop).Reset();

                if (checkthread != null && checkthread.IsAlive)
                {
                    Log("Kill old CheckNotificationUI thread");
                    checkthread.Abort();
                }

                checkthread = new Thread(new ThreadStart(CheckNotificationUI));
                checkthread.Start();
            }
        }

        void BotMain_OnStop(Zeta.CommonBot.IBot bot)
        {
        	Log("OnStop");
            ((AutoResetEvent)flagStop).Set();

            if (checkthread != null && checkthread.IsAlive)
            {
                Log("Kill CheckNotificationUI thread");
                checkthread.Abort();
            }
        }

        void BotMain_OnStart(Zeta.CommonBot.IBot bot)
        {
        	Log("OnStart");
            ((AutoResetEvent)flagStop).Reset();

            if (checkthread != null && checkthread.IsAlive)
            {
                Log("Kill old CheckNotificationUI thread");
                checkthread.Abort();
            }

            checkthread = new Thread(new ThreadStart(CheckNotificationUI));
            checkthread.Start();         
        }
        public void OnInitialize()
        {
            Log("Initalized");
            bool Enabled = false;
            if (System.IO.File.Exists("notificationokclick.cfg"))
            {
                Enabled = Int32.Parse(System.IO.File.ReadAllText("notificationokclick.cfg")) == 1;
            }

            if (Enabled)
            {
                Zeta.Common.Plugins.PluginManager.SetEnabledPlugins(new string[] { "NotificationOKClick Plugin" });
            }
        }
        public void OnPulse()
        {
            //Log("OnPulse");            
        }
        public void OnShutdown()
        {
            Log("Shutdown");            
            ((AutoResetEvent)flagStop).Set();
            
            if (checkthread != null && checkthread.IsAlive)
            {
                Log("Kill CheckNotificationUI thread");
                checkthread.Abort();
            }
         
        }

        public string Author { get { return "neoz"; } }

        public string Description { get { return "neoz"; } }

        public Window DisplayWindow { get { return null; } }

        public string Name { get { return "NotificationOKClick Plugin"; } }

    public System.Version Version { get { return new Version(0, 7); } }

        public bool Equals(IPlugin other)
        {
            return (other.Name == Name) && (other.Version == Version);
        }
    }
}
