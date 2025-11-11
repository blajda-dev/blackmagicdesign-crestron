using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;

namespace BlackMagicDesign.Protocol
{
    public static class MEmbers
    {
        public const int ProgramSource = 1;
        public const int PreviewSource = 2;
        public const int CaMEraSource = 1;
        public const int ColorSource = 2;
        public const int MEdiaSource = 3;
    }

    public static class Commands
    {
        public const string PrimaryInitializationCommand = "\x10\x14\x1B\xAA\x00\x00\x00\x00\x00\x1A\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00";
        public const string SecondaryInializationCommand = "\x80\x0C\x1B\xAA\x00\x00\x00\x00\x00\x27\x00\x00";
        public const string TertiaryInializationCommand = "\x80\x0C\x1B\xAA\x00\x00\x00\x00\x00\x99\x00\x00";
        public const string PongCommandFormat = "\x80\x0C{0}{1}\x00\x00\x00\x00\x00\x00";

        /// <summary>
        /// all of the commands supported by an atem switch
        /// </summary>
        public static readonly Dictionary<string, string> CommandStrings = new Dictionary<string,string> 
        {
            {"_ver", "Protocol Version"},
            {"_pin", "Product Id"},
            {"Warn", "Warning"},
            {"_top", "Topology"},
            {"_MEC", "Mix Effect Config"},
            {"_mpl", "MEdia Players"},
            {"_MvC", "Multi View Config"},
            {"_SSC", "Super Source Config"},
            {"_TlC", "Tally Channel Config"},
            {"_AMC", "Audio Mixer Config"},
            {"_VMC", "Video Mixer Config"},
            {"_MAC", "Macro Pool"},
            {"Powr", "Power"},
            {"DcOt", "Down Converter"},
            {"VidM", "Video Mode"},
            {"InPr", "Input Properties"},
            {"MvPr", "Multi Viewer Properties"},
            {"MvIn", "Multi Viewer Input"},
            {"PrgI", "Program Input"},
            {"PrvI", "Preview Input"},
            {"TrSS", "Transition"},
            {"TrPr", "Transition Preview"},
            {"TrPs", "Transition Position"},
            {"TMxP", "Transition Mix"},
            {"TDpP", "Transition Dip"},
            {"TWpP", "Transition Wipe"},
            {"TDvP", "Transition DVE"},
            {"TStP", "Transition Stinger"},
            {"KeOn", "Keyer On Air"},
            {"KeBP", "Keyer Base"},
            {"KeLm", "Key Luma"},
            {"KeCk", "Key Chroma"},
            {"KePt", "Key Pattern"},
            {"KeDV", "Key DVE"},
            {"KeFS", "Keyer Fly"},
            {"KKFP", "Keyer Fly Key FraME"},
            {"DSKB", "Downstream Keyer (B"},
            {"DSKP", "Downstream Keyer (P"},
            {"DSKS", "Downstream Keyer (S"},
            {"FtbP", "Fade-To-Black"},
            {"FtbS", "Fade-To-Black State"},
            {"ColV", "Color Generator"},
            {"AuxS", "Aux Source"},
            {"CCdP", "CaMEra Control"},
            {"RCPS", "Clip Player"},
            {"MPCE", "MEdia Player Source"},
            {"MPSp", "MEdia Pool Storage"},
            {"MPCS", "MEdia Player Clip Source"},
            {"MPAS", "MEdia Player Audio Source"},
            {"MPfe", "MEdia Player Still Files"},
            {"MRPr", "Macro Run Status"},
            {"MPrp", "Macro Properties"},
            {"MRcS", "Macro Recording Status"},
            {"SSrc", "Super Source"},
            {"SSBP", "Super Source Box ParaMEters"},
            {"AMIP", "Audio Mixer Input"},
            {"AMMO", "Audio Mixer Master"},
            {"AMmO", "Audio Mixer Monitor"},
            {"AMLv", "Audio Mixer Levels"},
            {"AMTl", "Audio Mixer Tally"},
            {"TlIn", "Tally By Index"},
            {"TlSr", "Tally By Source"},
            {"TiME", "Last State Change TiME Code"},
            {"InCm", "Initialization Complete"},
            //These commands are not really unknown,
            //but they are not impleMEnted
            //DocuMEnted as (? in Skårhøj"s protocol definition
            {"CCdo", "Not impleMEnted, CaMEra Control Options(?"},
            //Possibly from future versions of the protocol
            {"_DVE", "Not impleMEnted, _DVE"},
            {"AMHP", "Not impleMEnted, AMHP"},
            {"AMPP", "Not impleMEnted, AMPP"},
            {"ATMP", "Not impleMEnted, ATMP"},
            {"CCst", "Not impleMEnted, CCst"},
            {"LKST", "Not impleMEnted, LKST"},
            {"MMOP", "Not impleMEnted, MMOP"},
            {"MvVM", "Not impleMEnted, MvVM"},
            {"PZCS", "Not impleMEnted, PZCS"},
            {"RXCC", "Not impleMEnted, RXCC"},
            {"RXCP", "Not impleMEnted, RXCP"},
            {"RXMS", "Not impleMEnted, RXMS"},
            {"RXSS", "Not impleMEnted, RXSS"},
            {"SPtM", "Not impleMEnted, SPtM"},
            {"SPZS", "Not impleMEnted, SPZS"},
            {"TlFc", "Not impleMEnted, TlFc"},
            {"TMIP", "Not impleMEnted, TMIP"},
            {"V3sl", "Not impleMEnted, V3sl"},
            {"VuMC", "Not impleMEnted, VuMC"},
            {"VuMo", "Not impleMEnted, VuMo"},
            };
    }

    public static class HeaderFlags
    {
        /// <summary>
        /// Please acknowledge reception of this packet...
        /// </summary>
        public const byte AcknowledgePacketReceiptRequestByte = 0x1; 
        /// <summary>
        /// This is a handshake packet
        /// </summary>
        public const byte HandshakeByte = 0x2;                   
        /// <summary>
        /// This is a resent information
        /// </summary>
        public const byte ResentPacketByte = 0x4;               
        /// <summary>
        /// I"m requesting you to resend soMEthing to ME.
        /// </summary>
        public const byte RequestNextByte = 0x8;              
        /// <summary>
        /// Packet is ACK to packetId (byte 4-5 ackRequest
        /// </summary>
        public const byte AcknowledgePacketReceiptByte = 0x10;      

    }

    public static class UDPCommunications
    {
        /// <summary>
        /// udp communications port
        /// </summary>
        public const int Port = 9910;
    }

    public static class CommandStructure
    {
        /// <summary>
        /// Size of packet header
        /// </summary>
        public const int PacketHeaderLength = 12;

        /// <summary>
        /// size of command header (subpacket
        /// </summary>
        public const int CommandHeaderLength = 8;

        /// <summary>
        /// size of command string (in command header
        /// </summary>
        public const int CommandStringLength = 4;

        /// <summary>
        /// offset of command string (in command header
        /// </summary>
        public const int CommandStringOffset = 4;
    }

    public enum VideoSource : int
    {
        Black = 0,
        
        ColorBars = 1000,
        Color1 = 2001,
        Color2 = 2002,

        MEdiaPlayer1 = 3010,
        MEdiaPlayer1Key = 3011,
        MEdiaPlayer2 = 3020,
        MEdiaPlayer2Key = 3021,
        MEdiaPlayer3 = 3030,
        MEdiaPlayer3Key = 3031,
        MEdiaPlayer4 = 3040,
        MEdiaPlayer4Key = 3041,

        Key1Mask =  4010,
        Key2Mask =  4020,
        Key3Mask =  4030,
        Key4Mask =  4040,
        Key5Mask =  4050,
        Key6Mask =  4060,
        Key7Mask =  4070,
        Key8Mask =  4080,
        Key9Mask =  4090,
        Key10Mask = 4100,
        Key11Mask = 4110,
        Key12Mask = 4120,
        Key13Mask = 4130,
        Key14Mask = 4140,
        Key15Mask = 4150,
        Key16Mask = 4160,

        DSK1Mask = 5010,
        DSK2Mask = 5020,
        DSK3Mask = 5030,
        DSK4Mask = 5040,

        SuperSource = 6000,
        SuperSource2 = 6001,
        
        CleanFeed1 = 7001,
        CleanFeed2 = 7002,
        CleanFeed3 = 7003,
        CleanFeed4 = 7004,
        
        Auxilliary1 =  8001,
        Auxilliary2 =  8002,
        Auxilliary3 =  8003,
        Auxilliary4 =  8004,
        Auxilliary5 =  8005,
        Auxilliary6 =  8006,
        Auxilliary7 =  8007,
        Auxilliary8 =  8008,
        Auxilliary9 =  8009,
        Auxilliary10 = 8010,
        Auxilliary11 = 8011,
        Auxilliary12 = 8012,
        Auxilliary13 = 8013,
        Auxilliary14 = 8014,
        Auxilliary15 = 8015,
        Auxilliary16 = 8016,
        Auxilliary17 = 8017,
        Auxilliary18 = 8018,
        Auxilliary19 = 8019,
        Auxilliary20 = 8020,
        Auxilliary21 = 8021,
        Auxilliary22 = 8022,
        Auxilliary23 = 8023,
        Auxilliary24 = 8024,
        Auxilliary25 = 8025,
        Auxilliary26 = 8026,
        Auxilliary27 = 8027,
        Auxilliary28 = 8028,
        Auxilliary29 = 8029,
        Auxilliary30 = 8030,
        Auxilliary31 = 8031,
        Auxilliary32 = 8032,

        ME1Prog = 10010,
        ME1Prev = 10011,
        ME2Prog = 10020,
        ME2Prev = 10021,
        ME3Prog = 10030,
        ME3Prev = 10031,
        ME4Prog = 10040,
        ME4Prev = 10041,

        Input1Direct = 11001
    }

    public enum AudioSource : int
    {
        XLR = 1001,
        AES_EBU = 1101,
        RCA = 1201,
        Microphone1 = 1301,
        Microphone2 = 1302,
        MediaPlayer1 = 2001,
        MediaPlayer2 = 2002, 
        MediaPlayer3 = 2003, 
        MediaPlayer4 = 2004
    }

    public enum DownConverterMode : int
    {
        CenterCut = 0,
        LetterBox = 1,
        Anamorphic = 2
    }


}