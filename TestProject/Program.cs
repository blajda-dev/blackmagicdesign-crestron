using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BlackMagicDesign.Communications;

namespace TestProject
{
    class Program
    {
        static void Main(string[] args)
        {
            ProtocolBuffer buf = new ProtocolBuffer();
            buf.Append(0xFF);
        }
    }
}
