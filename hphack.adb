with Ada.Command_Line;
use Ada.Command_Line;

with Ada.Exceptions;
use Ada.Exceptions;

with Ada.Text_IO;
use Ada.Text_IO;

with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;

with Sockets.Stream_IO;
use Sockets, Sockets.Stream_IO;

--  uses the AdaSockets add-on package;
--  package is GPL'd
--  Submission by William Sutton (william at trilug dot org)

--  Usage: hp remotehost message
--  Example: hp localhost test

procedure hp is

    function length(S : String) return Integer is
    begin

        return S'Length;
    
    end length;

    function toMessage(S : String; maxLength : Integer) return String is
    begin

        if(S'Length > maxlength) then
            return S(1..maxLength);
        end if;

        return S;

    end toMessage;

    Outgoing_Socket : Socket_FD;
    Stream          : aliased Socket_Stream_Type;

begin
    if Argument_Count /= 2 then
        Raise_Exception
            (Constraint_Error'Identity,
            "Usage: " & Command_Name & " hostname message");
    end if;

    put("hp: HP Display hack in Ada");
    New_Line;
    put("Hostname: " & Argument(1));
    New_Line;
    put("Message: " & Argument(2));
    New_Line;

    Socket (Outgoing_Socket, PF_INET, SOCK_STREAM);
    Connect (Outgoing_Socket, Argument (1), 9100);
    Initialize (Stream, Outgoing_Socket);

    String'Write (Stream'Access,
        Character'Val(27) &                 -- ESC
        "%-12345X@PJL RDYMSG DISPLAY = " &  -- display msg
        Character'Val(34) &                 -- "
        --Argument(2) &                       -- message
        toMessage(Argument(2), 44) &        -- message
        Character'Val(34) &                 -- "
        Character'Val(13) &                 -- \r
        Character'Val(10) &                 -- \n
        Character'Val(27) &                 -- ESC
        "%-12345X" &                        -- end message
        Character'Val(13) &                 -- \r
        Character'Val(10)                   -- \n
    );

    put("Send ");
    put(46 + length(toMessage(Argument(2), 44)));
    put(" bytes");
    New_Line;

exception
    when End_Error => null;
end hp;

