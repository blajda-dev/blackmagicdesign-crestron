using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;
using BlackMagicDesign.Protocol;

namespace BlackMagicDesign.Device
{
    public static class Methods
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="videoInput"></param>
        /// <param name="auxOutput"></param>
        public static void SetAuxSourceInput(int videoInput , int auxOutput)
        {
            //indexMatch:bool = self.switcher._outBuf.getU8(1) == auxChannel_val

            //self.switcher._prepareCommandPacket("CAuS", 4, indexMatch)
            //self.switcher._outBuf.setU8Flag(0, 0)
            //self.switcher._outBuf.setU8(1, auxChannel_val)
            //self.switcher._outBuf.setU16(2, input_val)
            //self.switcher._finishCommandPacket()
        }

        public static void SetAuxSourceInput(VideoSource videoInput, int auxOutput)
        {

        }
    }
}