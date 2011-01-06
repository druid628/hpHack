import java.net.InetAddress;
import java.net.Socket;
import java.net.UnknownHostException;
import java.io.OutputStream;
import java.io.IOException;

public class HP {
    public static void main(String[] args) {

        System.out.println("HP Display Hack -- sili@l0pht.com 12/8/97");
        System.out.println();

        if ( args.length != 2 ) {
            System.out.println("Usage: java HP printer \"message\"");
            System.out.println("\tMessage can be up to 16 characters long (44 on 5si's)");
            System.exit(1);
        }

        String host = args[0];
        String message = args[1];

        if ( message.length() > 44 ) {
            message = message.substring(0, 44);
        }

        System.out.println("Hostname: " + host);
        System.out.println("Message: " + message);

        InetAddress addr = null;
        
        try {
            addr = InetAddress.getByName(host);
        } catch(UnknownHostException e) {
            System.out.println("Unknown host: " + e.getMessage());
            System.exit(1);
        }

        System.out.println("Connecting ...");

        Socket sock = null;

        String head = "\033%-12345X@PJL RDYMSG DISPLAY = \"";
        String tail = "\"\r\n\033%-12345X\r\n";
        
        try {
            sock = new Socket(addr, 9100);
            OutputStream out = sock.getOutputStream();
            out.write(head.getBytes());
            out.write(message.getBytes());
            out.write(tail.getBytes());
            sock.close();
        } catch(IOException e) {
            System.out.println("IO error: " + e.getMessage());
            System.exit(1);
        }

        int bytes = (head+message+tail).getBytes().length;

        System.out.println("Sent " + bytes + " bytes");

        System.exit(0);
    }
}

