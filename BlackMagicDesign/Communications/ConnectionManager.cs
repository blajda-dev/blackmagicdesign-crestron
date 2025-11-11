using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;
using Crestron.SimplSharp.CrestronSockets;

namespace BlackMagicDesign.Communications
{
    public class ConnectionManager
    {
        private UDPServer Communications = new UDPServer();

        private int LastRemotePacketID = 0;

        private int InitPayloadPacketID = 0;

        private int LocalPacketIDCounter = 0;

        private float LastContact = 0;
        
        private bool IsSwitcherAlive = false;

        private bool HasHandshakeStarted = false;

        public bool IsConnected = false;

        public string IPAddress = String.Empty;

        public ConnectionManager()
        {
        }
    }
}