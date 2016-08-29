# Composer Outdated

Find Composer Outdated libs, this script need composer.json, composer.lock.

## Requirement

* php
* composer

## Useage

```
cd php_project_dir
# composer_outdated.php -i COMPOSER_LOCK_PATH -c COMPOSER_JSON_PATH -o OUTPUT_FILE_PATH
./composer_outdated.php -i composer.lock -c composer.json -o output.json
or
php composer_outdated.php -i composer.lock -c composer.json -o output.json
```

## Output Formart

Result format is json.
Example:

```
[
    {
        "latest": "1.2.6", 
        "locked": "1.2.4", 
        "package": "doctrine/annotations", 
        "package_url": "https://github.com/doctrine/annotations.git", 
        "requirement": "", 
        "status": "outdated"
    }, 
    {
        "latest": "1.4.1", 
        "locked": "1.4.1", 
        "package": "doctrine/cache", 
        "package_url": "https://github.com/doctrine/cache.git", 
        "requirement": "", 
        "status": "latest"
    }, 
    {
        "latest": "1.3.0", 
        "locked": "1.3.0", 
        "package": "doctrine/collections", 
        "package_url": "https://github.com/doctrine/collections.git", 
        "requirement": "", 
        "status": "latest"
    }, 
    {
        "latest": "2.5.0", 
        "locked": "2.5.0", 
        "package": "doctrine/common", 
        "package_url": "https://github.com/doctrine/common.git", 
        "requirement": "", 
        "status": "latest"
    }, 
    {
        "latest": "2.5.1", 
        "locked": "2.4.4", 
        "package": "doctrine/dbal", 
        "package_url": "https://github.com/doctrine/dbal.git", 
        "requirement": "<2.5", 
        "status": "outdated"
    }, 
    {
        "latest": "1.5.0", 
        "locked": "1.5.0", 
        "package": "doctrine/doctrine-bundle", 
        "package_url": "https://github.com/doctrine/DoctrineBundle.git", 
        "requirement": "~1.2", 
        "status": "latest"
    }, 
    {
        "latest": "1.0.1", 
        "locked": "1.0.1", 
        "package": "doctrine/doctrine-cache-bundle", 
        "package_url": "https://github.com/doctrine/DoctrineCacheBundle.git", 
        "requirement": "", 
        "status": "latest"
    }, 
    {
        "latest": "1.0.1", 
        "locked": "1.0.1", 
        "package": "doctrine/inflector", 
        "package_url": "https://github.com/doctrine/inflector.git", 
        "requirement": "", 
        "status": "latest"
    }, 
    {
        "latest": "1.0.1", 
        "locked": "1.0.1", 
        "package": "doctrine/lexer", 
        "package_url": "https://github.com/doctrine/lexer.git", 
        "requirement": "", 
        "status": "latest"
    }, 
    {
        "latest": "2.5.0", 
        "locked": "2.4.7", 
        "package": "doctrine/orm", 
        "package_url": "https://github.com/doctrine/doctrine2.git", 
        "requirement": "~2.2,>=2.2.3,<2.5", 
        "status": "outdated"
    }, 
    {
        "latest": "3.1.4", 
        "locked": "3.1.4", 
        "package": "friendsofsymfony/elastica-bundle", 
        "package_url": "https://github.com/FriendsOfSymfony/FOSElasticaBundle.git", 
        "requirement": "~3.1", 
        "status": "latest"
    }, 
    {
        "latest": "2.1.1", 
        "locked": "2.1.1", 
        "package": "incenteev/composer-parameter-handler", 
        "package_url": "https://github.com/Incenteev/ParameterHandler.git", 
        "requirement": "~2.0", 
        "status": "latest"
    }, 
    {
        "latest": "1.2.17", 
        "locked": "1.2.17", 
        "package": "jdorn/sql-formatter", 
        "package_url": "https://github.com/jdorn/sql-formatter.git", 
        "requirement": "", 
        "status": "latest"
    }, 
    {
        "latest": "1.3.1", 
        "locked": "1.3.1", 
        "package": "knplabs/knp-components", 
        "package_url": "https://github.com/KnpLabs/knp-components.git", 
        "requirement": "", 
        "status": "latest"
    }, 
    {
        "latest": "2.4.2", 
        "locked": "2.4.1", 
        "package": "knplabs/knp-paginator-bundle", 
        "package_url": "https://github.com/KnpLabs/KnpPaginatorBundle.git", 
        "requirement": "^2.4", 
        "status": "outdated"
    }, 
    {
        "latest": "1.2.1", 
        "locked": "1.2.1", 
        "package": "kriswallsmith/assetic", 
        "package_url": "https://github.com/kriswallsmith/assetic.git", 
        "requirement": "", 
        "status": "latest"
    }, 
    {
        "latest": "1.15.0", 
        "locked": "1.13.1", 
        "package": "monolog/monolog", 
        "package_url": "https://github.com/Seldaek/monolog.git", 
        "requirement": "^1.13", 
        "status": "outdated"
    }, 
    {
        "latest": "1.0.0", 
        "locked": "1.0.0", 
        "package": "psr/log", 
        "package_url": "https://github.com/php-fig/log.git", 
        "requirement": "", 
        "status": "latest"
    }, 
    {
        "latest": "2.2.0", 
        "locked": "2.0.0", 
        "package": "ruflin/elastica", 
        "package_url": "https://github.com/ruflin/Elastica.git", 
        "requirement": "", 
        "status": "outdated"
    }, 
    {
        "latest": "4.0.0", 
        "locked": "3.0.30", 
        "package": "sensio/distribution-bundle", 
        "package_url": "https://github.com/sensiolabs/SensioDistributionBundle.git", 
        "requirement": "~3.0,>=3.0.12", 
        "status": "outdated"
    }, 
    {
        "latest": "3.0.9", 
        "locked": "3.0.9", 
        "package": "sensio/framework-extra-bundle", 
        "package_url": "https://github.com/sensiolabs/SensioFrameworkExtraBundle.git", 
        "requirement": "~3.0,>=3.0.2", 
        "status": "latest"
    }, 
    {
        "latest": "2.5.3", 
        "locked": "2.5.3", 
        "package": "sensio/generator-bundle", 
        "package_url": "https://github.com/sensiolabs/SensioGeneratorBundle.git", 
        "requirement": "^2.5", 
        "status": "latest"
    }, 
    {
        "latest": "2.0.5", 
        "locked": "2.0.5", 
        "package": "sensiolabs/security-checker", 
        "package_url": "https://github.com/sensiolabs/security-checker.git", 
        "requirement": "", 
        "status": "latest"
    }, 
    {
        "latest": "5.4.1", 
        "locked": "5.4.1", 
        "package": "swiftmailer/swiftmailer", 
        "package_url": "https://github.com/swiftmailer/swiftmailer.git", 
        "requirement": "", 
        "status": "latest"
    }, 
    {
        "latest": "2.6.1", 
        "locked": "2.6.1", 
        "package": "symfony/assetic-bundle", 
        "package_url": "https://github.com/symfony/AsseticBundle.git", 
        "requirement": "~2.3", 
        "status": "latest"
    }, 
    {
        "latest": "2.7.1", 
        "locked": "2.7.1", 
        "package": "symfony/monolog-bundle", 
        "package_url": "https://github.com/symfony/MonologBundle.git", 
        "requirement": "~2.4", 
        "status": "latest"
    }, 
    {
        "latest": "2.3.8", 
        "locked": "2.3.8", 
        "package": "symfony/swiftmailer-bundle", 
        "package_url": "https://github.com/symfony/SwiftmailerBundle.git", 
        "requirement": "~2.3", 
        "status": "latest"
    }, 
    {
        "latest": "2.7.2", 
        "locked": "2.6.9", 
        "package": "symfony/symfony", 
        "package_url": "https://github.com/symfony/symfony.git", 
        "requirement": "2.6.*", 
        "status": "outdated"
    }, 
    {
        "latest": "1.2.0", 
        "locked": "1.2.0", 
        "package": "twig/extensions", 
        "package_url": "https://github.com/twigphp/Twig-extensions.git", 
        "requirement": "~1.0", 
        "status": "latest"
    }, 
    {
        "latest": "1.18.2", 
        "locked": "1.18.2", 
        "package": "twig/twig", 
        "package_url": "https://github.com/twigphp/Twig.git", 
        "requirement": "", 
        "status": "latest"
    }
]
```
