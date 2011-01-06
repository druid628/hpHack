<?php
define('PORT', 9100);

$stdout = fopen('php://stdout', 'w');
$stderr = fopen('php://stderr', 'w');

if($_SERVER['argc'] !== 3)
{
    fwrite($stdout, "Usage: " . $_SERVER['argv'][0] . " <printer> \"<message>\"\n");
    fwrite($stdout, "Message can be up to 16 characters long (44 characters on 5si's).\n");
    exit(1);
}
elseif(($host = gethostbyname($_SERVER['argv'][1])) === $_SERVER['argv'][1]
    && !preg_match('/^(\d{1,3}\.){3}\d{1,3}$/', $host))
{
    fwrite($stderr, "Hostname could not be found.\n");
    exit(1);
}
elseif(($sockfd = @socket_create(AF_INET, SOCK_STREAM, SOL_TCP)) === FALSE)
{
    fwrite($stderr, "Socket could not be initialized.\n");
    exit(1);
}

fwrite($stdout, "HP Display Hack -- sili@10pht.com\n");
fwrite($stdout, "PHP version by Noel Forbes <nforbes@compasstools.net>\n");
fwrite($stdout, "Hostname: " . $_SERVER['argv'][1] . "\n");
fwrite($stdout, "Message: \"" . $_SERVER['argv'][2] . "\"\n");
fwrite($stdout, "Connecting...\n");

if(@socket_connect($sockfd, $host, PORT) === FALSE)
{
    fwrite($stderr, "Could not connect to host.\n");
    exit(1);
}

$line  = "\033%-12345X@PJL RDYMSG DISPLAY = \"";
$line .= $_SERVER['argv'][2];
$line .= "\"\r\n\033%-12345X\r\n";

$bytes_sent = socket_write($sockfd, $line);

fwrite($stdout, "Sent " . $bytes_sent . " bytes.\n");

fclose($stdout);
fclose($stderr);
socket_close($sockfd);

exit(0);
?>

