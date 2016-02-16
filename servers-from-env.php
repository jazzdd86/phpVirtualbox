<?php

$servers = array();

echo 'Exposing the following linked server instances:' . PHP_EOL;

foreach ($_SERVER as $key => $value) {
    // ends with vboxwebsrv default port
    if (substr($key, -15) === '_PORT_18083_TCP') {
        // get prefix of key
        $prefix = substr($key, 0, -15);

        // actual readable name is stored as "/thiscontainer/givencontainer"
        $name = getenv($prefix . '_NAME');
        $pos = strrpos($name, '/');
        if ($pos !== false) {
            $name = substr($name, $pos + 1);
        }

        if (!$name) {
            $name = ucfirst(strtolower($prefix));
        }

        $location = 'http://' . str_replace('tcp://', '', $value) . '/';

        echo '- ' . $name . ' (' . $location .')' . PHP_EOL;

        $username = getenv($prefix.'_USER');
        $password = getenv($prefix.'_PW');

		if ($username == "") $username = 'username';
		if ($password == "") $password = 'username';
		
        $servers []= array(
            'name' => $name,
            'username' => $username,
            'password' => $password,
            'authMaster' => true,
            'location' => $location
        );
    }
}

if (!$servers) {
    echo 'Error: No vboxwebsrv instance linked? Use "--link containername:myname"' . PHP_EOL;
    exit(1);
}

$config = '<?php return ' . var_export($servers, true) . ';';
file_put_contents('/var/www/config-servers.php', $config);

$config_overrides = array();
foreach ($_SERVER as $key => $value) {
    if (substr($key,0,7) === 'CONFIG_') { 
	$name = substr($key,7);
	if (strpos($value,',') !== false) {
	    $config_overrides[$name] = split(',',$value);
	} else {
	    $config_overrides[$name] = $value;
	}
    }
}

file_put_contents('/var/www/config-override.php','<?php return ' . var_export($config_overrides, true) . ';' );
