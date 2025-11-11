using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Crestron.SimplSharp;
using BlackMagicDesign.Protocol;

namespace BlackMagicDesign.Communications
{
    public class ProtocolBuffer
    {
        private int Size { get; set; }
        private object[] Buffer = new object[1];

        public int Length
        {
            get { return this.Buffer.Length; }
        }

        public delegate int SetUserOffsetCallback(int offset);
        public SetUserOffsetCallback SetUserOffset { get; set; }

        public ProtocolBuffer()
        {
            this.Size = -1;
        }

        public ProtocolBuffer(int size) : this()
        {
            this.Size = size;
            this.Buffer = new object[this.Size];
            this.Reset(this.Size);
        }

        public object this[int index]
        {
            get {
                lock (this.Buffer) { return this.Buffer[index]; }
            }
            set {
                lock (this.Buffer) { this.Buffer[index] = value; }
            }
        }

        public object Pop()
        {
            lock (this.Buffer) { return this.Buffer.Last(); }
        }

        public void Append(byte val)
        {
            object[] temp = new object[this.Buffer.Length + 1];
            lock (this.Buffer)
            {
                this.Buffer.CopyTo(temp, 0);
                temp[temp.Length - 1] = val;
                this.Buffer = temp;
            }
        }

        private void Reset(int size)
        {
            if (this.Size != -1)
            {
                this.Size = size;
                this.Buffer = new object[this.Size];
            }
        }

        public object[] GetInteger(int offset, bool signed, int bits)
        {
            int bufferIndex;
            
            if (this.SetUserOffset != null) bufferIndex = this.SetUserOffset(offset);
            else bufferIndex = offset;

            int numBytes = (int)Math.Floor(bits / 8);

            if (0 < bufferIndex && bufferIndex >= (this.Size - numBytes))
            {
                BlackMagicDesign.DebugMessage(DebuggingLevel.Critical, "ATEMBuffer.getInt(): Can't get {'S' if signed else 'U'}{0} @offset[{1}] - buffIndex[{2}] - numBytes[{3}] - buffLen[{4}]", bits, offset, bufferIndex, numBytes, this.Size);
            }
            byte[] destination = new byte[numBytes];

            //get the data from the buffer
            lock (this.Buffer) { Array.Copy(this.Buffer, bufferIndex, destination, 0, bufferIndex + numBytes); }

            try
            {
                int o = 0;
                string format = StructConverter.GetFormatSpecifierFor(o);
                return StructConverter.Unpack(format, destination);
            }
            catch (Exception e)
            {
                BlackMagicDesign.DebugMessage(DebuggingLevel.Critical, "Cannot unpack {0}", e.Message);
                return new object[1];
            }
        }

        public void SetInteger(int offset, bool signed, int bits, int value)
        {
            int bufferIndex;

            if (this.SetUserOffset != null) bufferIndex = this.SetUserOffset(offset);
            else bufferIndex = offset;

            int numBytes = (int)Math.Floor(bits / 8);

            if (0 < bufferIndex && bufferIndex >= (this.Size - numBytes))
            {
                BlackMagicDesign.DebugMessage(DebuggingLevel.Critical, "ATEMBuffer.getInt(): Can't get {'S' if signed else 'U'}{0} @offset[{1}] - buffIndex[{2}] - numBytes[{3}] - buffLen[{4}]", bits, offset, bufferIndex, numBytes, this.Size);
            }
            //pack the value
            object[] valueArray = new object[1];
            valueArray[0] = value;
            byte[] packed = StructConverter.Pack(valueArray);

            //store it in the buffer
            lock (this.Buffer) { Array.Copy(packed, 0, this.Buffer, bufferIndex, bufferIndex + numBytes); }
        }

        public void ChangeInteger(int offset, bool signed, int value)
        {
        }

        public string GetString(int offset, int numBytes)
        {
            int bufferIndex;

            if (this.SetUserOffset != null) bufferIndex = this.SetUserOffset(offset);
            else bufferIndex = offset;

            if (0 < bufferIndex && bufferIndex >= (this.Size - numBytes))
            {
                BlackMagicDesign.DebugMessage(DebuggingLevel.Critical, "ATEMBuffer.getString(): Can't get string: @offset[{0}] - buffIndex[{1}] - numBytes[{2}] - buffLen[{3}]", offset, bufferIndex, numBytes, this.Size);
            }

            //byte[] valueBuffer = new byte[numBytes];
            StringBuilder builder = new StringBuilder();
            int index = bufferIndex;

            while (index < (bufferIndex + numBytes))
            {
                builder.Append(this.Buffer[index]);
                index += 1;
            }

            return builder.ToString();
        }
    }
}