## Variable declaration.
$ports=()
$ip ="<IP>"

## One liner.
%($port in $ports){try{$socket=New-object System.Net.Sockets.TCPClient($ip,$port);}catch{};if ($socket -eq $NULL){echo $ip":"$port" - Closed";}else{echo $ip":"$port" - Open";$socket = $NULL;}}
