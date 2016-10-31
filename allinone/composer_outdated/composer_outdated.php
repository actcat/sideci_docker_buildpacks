#!/usr/bin/php
<?php

$options = getopt("c:i:o:");

if(!isset($options["c"])){
  fputs(STDERR, "'c'オプションに入力元のcomposer.jsonのファイルパスを指定してください。\n");
  return;
}

if(!isset($options["i"])){
  fputs(STDERR, "'i'オプションに入力元のcomposer.lockのファイルパスを指定してください。\n");
  return;
}

if(!isset($options["o"])){
  fputs(STDERR, "'o'オプションに出力先のJSONファイルパスを指定してください。\n");
  return;
}

$composerJsonFilePath = $options["c"];
$lockFilePath = $options["i"];
$outputFilePath = $options["o"];

// composer.jsonはjsonファイルであるため、ここでjsonデコードする
$composerJsonFile = json_decode(file_get_contents($composerJsonFilePath, true),true);

if(empty($composerJsonFile)){
  fputs(STDERR, "composer.json is not found.");
  return;
}

// composer.lockはjsonファイルであるため、ここでjsonデコードする
$file = json_decode(file_get_contents($lockFilePath, true),true);

// composer.lockの配列のうち、"packages"フィールドに各パッケージが配列として格納されている
if($file!=null && (count($file["packages"])>0 || count($file["packages-dev"])>0 )){
  $outputArr = array();
  foreach ($file["packages"] as $package) {
    $outputArr[] = checkOutdatedPackage($package);
  }
  foreach ($file["packages-dev"] as $package) {
    $outputArr[] = checkOutdatedPackage($package);
  }

  //ファイルに出力
  file_put_contents($outputFilePath, json_encode($outputArr, JSON_UNESCAPED_SLASHES));

  echo "プロセスが完了しました。\n";
}else{
  fputs(STDERR, "composer.lock is not found");
}

function checkOutdatedPackage($package) {
    echo $package["name"]." : 処理中...\n";

    // ローカル(composer.lock)のバージョン文字列
    $localVersion = trimVersionSign($package["version"]);

    // リポジトリ(composerサーバ上)のバージョン文字列
    $repositoryVersion = getRepositoryVersion($package["name"]);
    if(!empty($repositoryVersion)) $repositoryVersion = trimVersionSign($repositoryVersion);

    // ローカルのパッケージが最新であるか
    $isLatestVersion = isLatestVersion($localVersion,$repositoryVersion);

    // ローカルのrequirement
    $localRequirement = (isset($composerJsonFile["require"][$package["name"]])) ? $composerJsonFile["require"][$package["name"]] : "";

    $temp = array();
    $temp["latest"] = ($isLatestVersion) ? $localVersion : $repositoryVersion;
    $temp["locked"] = $localVersion;
    $temp["package"] = $package["name"];
    $temp["package_url"] = $package["source"]["url"];
    $temp["requirement"] = $localRequirement;
    $temp["status"] = ($isLatestVersion) ? "latest" : "outdated";

    return $temp;
}

/**
 * composerのリポジトリのバージョンを取得する
 *
 * @param string $packageName composerで管理されているパッケージ名 (i.e. doctrine/annotations)
 */
function getRepositoryVersion($packageName){
  // シェルコマンドでcomposerにリポジトリ上のバージョン情報をリクエストする
  // たとえば下記のようなコマンドをターミナルで実行することになる
  // $ composer show doctrine/annotations
  $command='composer show '.$packageName.' 2>/dev/null';
  $output=array();
  $ret=null;
  exec ( $command, $output, $ret );

  foreach ($output as $item) {
    // versionsを含む行を取得する
    if (preg_match("/versions/s", $item)) {
      // versionsの行は下記のような文字列になっている
      // versions : dev-master, 3.0.x-dev, 2.8.x-dev, 2.7.x-dev, v2.7.2, v2.7.1, v2.7.0, ........
      // ","で区切り、バージョン文字列ごとに配列に格納するための処理をここでおこなう
      $pieces = explode(",", str_replace(" ","",$item));
      foreach ($pieces as $piece) {
        // バージョン文字列のうち、先頭の"versions"を含む項目は除外する
        // バージョン文字列のうち、dev版を除外する
        // バージョン文字列のうち、beta版を除外する
        // バージョン文字列を格納した配列$piecesは降順となっている
        // そのため最初にヒットしたバージョン文字列が、ここで採用するリポジトリ上のバージョンということになる
        if (!preg_match("/versions/i", $piece) && !preg_match("/dev/i", $piece) && !preg_match("/beta/i", $piece)) {
          return $piece;
        }
      }
    }
  }
  return null;
}

/**
 * バージョンを比較する
 *
 * @param string $localVersion ローカルのバージョン文字列 (i.e. 1.2.4)
 * @param string $repositoryVersion composerから取得したリポジトリのバージョン文字列 (i.e. 1.2.5)
 * @return bool ローカルのバージョンが最新ならばtrue
 */
function isLatestVersion($localVersion,$repositoryVersion){
  list($a1,$a2,$a3) = explode(".",$localVersion);
  list($b1,$b2,$b3) = explode(".",$repositoryVersion);

  if($a1<$b1) return false;
  if($a1==$b1 && $a2<$b2) return false;
  if($a1==$b1 && $a2==$b2 && $a3<$b3) return false;

  return true;
}

/**
 * バージョン文字列から不必要な文字列を削除する
 * composerで管理されているバージョン文字列は"v1.2.4","*v1.2.4"というような文字列となっている
 * 数値のみするためにこの処理をおこなう
 * @param string $string バージョン文字列 (i.e. v1.2.4)
 * @return string 整形後のバージョン文字列 (i.e. 1.2.4)
 */
function trimVersionSign($string){
  $string = str_replace("*","",$string);
  $string = str_replace("v","",$string);
  return $string;
}


?>
