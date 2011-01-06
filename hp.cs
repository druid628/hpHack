//#define DEBUG

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Net.Sockets;


namespace HPPrnDisp
{
    class Program
    {
        public static int Main(string[] args)
        {

            Console.WriteLine("HP Display Hack -- sili@l0pht.com 12/8/97");
            Console.WriteLine("-- Re-coded by Kent Bolton 02 APR 2008 --");

#if DEBUG
            string host = "192.168.0.170";
            string message = "IT Rocks";
#else
            if ( args.Length != 2 ) {
                Console.WriteLine("Usage: printer \"message\"");
                Console.WriteLine("\tMessage can be up to 16 characters long (44 on 5si's)");
                return 1;
            }

            String host = args[0];
            String message = args[1];


#endif

            if (message.Length > 44)
            {
                message = message.Substring(0, 44);
            }

            Console.WriteLine("Hostname: {0}", host);
            Console.WriteLine("Message : {0}", message);

            IPAddress addr = null;
            IPEndPoint endPoint = null;

            try
            {
                addr = Dns.GetHostEntry(host).AddressList[0];
       //         Console.WriteLine("addr    : {0}",addr.ToString());

                endPoint = new IPEndPoint(addr, 9100);
       //         Console.WriteLine("endPoint: {0}", endPoint.ToString());
            }
            catch (Exception e)
            {
                Console.WriteLine("Unknown host: " + e.ToString());
                return 1;
            }

            Console.WriteLine("Connecting ...");

            Socket sock = null;

            String head = "\u001B%-12345X@PJL RDYMSG DISPLAY = \"";
            String tail = "\"\r\n\u001B%-12345X\r\n";
            System.Text.ASCIIEncoding encoding = new System.Text.ASCIIEncoding();

            try
            {
                sock = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.IP);
                sock.Connect(endPoint);

                sock.Send(encoding.GetBytes(head));
                sock.Send(encoding.GetBytes(message));
                sock.Send(encoding.GetBytes(tail));

                sock.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine("IO error: " + e.ToString());
                return 1;
            }

            int bytes = (head + message + tail).Length;

            Console.WriteLine("Sent " + bytes + " bytes");

            return 0;


        }
    }
}

