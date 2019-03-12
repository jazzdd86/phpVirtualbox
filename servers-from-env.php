<?php

// variables
$servers = array();
$config_overrides = array();


// getting global config overrides
foreach ($_SERVER as $key => $value) {
    preg_match('/(.*?)(?:_ENV_|_)?CONF_(.+)/', $key, $matches);
    if ($matches) {
        $value= (strpos($value, ',')) ? explode(',',$value) : $value;
        array_key_exists($matches[1], $config_overrides)?:$config_overrides[$matches[1]] = array();
        $config_overrides[$matches[1]] += array($matches[2] => $value);
    }
}

echo 'Using following global configuration parameters:' . PHP_EOL;
print_r($config_overrides[""]);


// getting servers from environment variables
foreach ($_SERVER as $key => $value) {
    if (substr($key, -9) === '_HOSTPORT') {
        $prefix = substr($key, 0, -9);

        $name = getenv($prefix . '_NAME');
        $pos = strrpos($name, '/');
        if ($pos !== false) {
            $name = substr($name, $pos + 1);
        }

        if (!$name) {
            $name = strtolower($prefix);
        }
        $name = ucfirst($name);

        $location = 'http://' . str_replace('tcp://', '', $value) . '/';

        $username = getenv($prefix.'_USER');
        $password = getenv($prefix.'_PW');

        if ($username == "") $username = 'username';
        if ($password == "") $password = 'password';

        $servers []= array_merge(array(
            'name' => $name,
            'username' => $username,
            'password' => $password,
            'location' => $location),
            (array_key_exists($prefix, $config_overrides)) ? $config_overrides[$prefix] : array());
    }
}

echo PHP_EOL.PHP_EOL.'Using the following linked server instances:'.PHP_EOL;
print_r($servers);


// check if there are any servers
if (!$servers) {
    echo 'Use environment variables to configure the correct vboxwebsrv connection!';
    exit(1);
}


// put servers array to file, which is then used in config.php of phpvirtualbox
file_put_contents('/var/www/config-servers.php', '<?php return ' . var_export($servers, true) . ';');

// put global config overrides into another file, which is then used in config.php of phpvirtualbox
if (array_key_exists("", $config_overrides)) {
    file_put_contents('/var/www/config-override.php','<?php return ' . var_export($config_overrides[""], true) . ';' );
}
