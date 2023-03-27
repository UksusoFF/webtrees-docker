<?php

declare(strict_types=1);

namespace Fisharebest\Webtrees;

require __DIR__ . '/vendor/autoload.php';

$webtrees = new Webtrees();
$webtrees->bootstrap();
$webtrees->cliRequest();

$wizard = app(\Fisharebest\Webtrees\Http\RequestHandlers\SetupWizard::class);

$reflector = new \ReflectionObject($wizard);
$method = $reflector->getMethod('step6Install');
$method->setAccessible(true);
try {
    $method->invoke($wizard, [
        'dbtype' => 'mysql',
        'dbhost' => 'APP_NAME_db',
        'dbport' => '3306',
        'dbname' => 'APP_NAME',
        'dbuser' => 'APP_NAME',
        'dbpass' => 'APP_NAME',
        'tblpfx' => 'wt_',
        'wtname' => 'APP_NAME',
        'wtuser' => 'APP_NAME',
        'wtpass' => 'APP_NAME',
        'wtemail' => 'APP_NAME@APP_DOMAIN',
        'lang' => 'ru',
        'baseurl' => 'https://APP_DOMAIN',
    ]);
} catch (\Throwable $e) {
    //
}
