using System;
using System.Text;
using Crestron.SimplSharp;                          				// For Basic SIMPL# Classes

namespace BlackMagicDesign
{
    public enum DebuggingLevel : int
    {
        Critical = 0,
        Error = 1,
        Warning = 2,
        Notice = 3,
        Debug = 4,
        Verbose = 5
    }

    public static class BlackMagicDesign
    {
        public static DebuggingLevel DebuggingLevel;

        public static void DebugMessage(DebuggingLevel debugLevel, string msg, params object[] args)
        {
            try
            {
                CrestronConsole.PrintLine(msg, args);
            }
            catch (FormatException e)
            {
                CrestronConsole.PrintLine("Format Exception: {0}", e.Message);
            }
        }
    }
}
