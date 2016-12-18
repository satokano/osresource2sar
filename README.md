# osresource2sar

千手が出力したosresourceを、普通の連続したsarに変換するperlスクリプト。
入出力はUTF-8を期待。

## 使い方

    iconv -f euc-jp -t utf-8 ./osresource_eucjp.log | perl ./osresource2sar.pl > ./sar_utf8.log

